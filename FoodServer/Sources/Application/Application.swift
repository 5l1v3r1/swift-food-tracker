import Foundation
import Kitura
import LoggerAPI
import Configuration
import CloudEnvironment
import KituraContracts
import Health
import SwiftKueryORM
import SwiftKueryPostgreSQL
import KituraStencil

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()

extension Meal: Model {
    static var idColumnName = "name"
}

class Persistence {
    static func setUp() {
        let pool = PostgreSQLConnection.createPool(host: "localhost", port: 5432, options: [.databaseName("FoodDatabase")], poolOptions: ConnectionPoolOptions(initialCapacity: 10, maxCapacity: 50, timeout: 10000))
        Database.default = Database(pool)
    }
}

public class App {
    let router = Router()
    let cloudEnv = CloudEnv()
    
    private var fileManager = FileManager.default
    private var rootPath = StaticFileServer().absoluteRootPath

    public init() throws {
        // Run the metrics initializer
        initializeMetrics(router: router)
    }

    func postInit() throws {
        // Endpoints
        initializeHealthRoutes(app: self)
        
        router.get("/images", middleware: StaticFileServer())
        router.post("/meals", handler: storeHandler)
        router.get("/meals", handler: loadHandler)
        router.get("/summary", handler: summaryHandler)
        router.delete("/meal", handler: deleteHandler)
        
        router.add(templateEngine: StencilTemplateEngine())
        router.get("/foodtracker") { request, response, next in
            // Build a JSON string description of FoodTracker store
            Meal.findAll { (result: [Meal]?, error: RequestError?) in
                guard let meals = result else {
                    return
                }
                var allMeals: [String: [[String:Any]]] = ["meals" :[]]
                for meal in meals {
                    allMeals["meals"]?.append(["name": meal.name, "rating": meal.rating])
                }
                // Render stencil template and add to response
                do {
                    try response.render("FoodTemplate.stencil", context: allMeals)
                } catch let error {
                    response.send(json: ["Error": error.localizedDescription])
                }
                
                next()
            }
        }
        
        Persistence.setUp()
        do {
            try Meal.createTableSync()
        } catch let error {
            print(error)
        }
    }
    
    func storeHandler(meal: Meal, completion: @escaping (Meal?, RequestError?) -> Void) {
        meal.save(completion)
        
        let path = rootPath + "/" + meal.name + ".jpg"
        fileManager.createFile(atPath: path, contents: meal.photo)
    }
    
    func loadHandler(completion: @escaping ([Meal]?, RequestError?) -> Void) {
        Meal.findAll(completion)
    }
    
    func summaryHandler(completion: @escaping (Summary?, RequestError?) -> Void) {
        Meal.findAll { meals, error in
            guard let meals = meals else {
                completion(nil, .internalServerError)
                return
            }
        completion(Summary(meals), nil)
        }
    }
    
    func deleteHandler(id: String, completion: @escaping (RequestError?) -> Void) {
        Meal.delete(id: id, completion)
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: cloudEnv.port, with: router)
        Kitura.run()
    }
}
