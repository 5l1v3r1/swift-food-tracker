import Foundation
import Kitura
import LoggerAPI
import Configuration
import CloudEnvironment
import KituraContracts
import Health

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()

public class App {
    let router = Router()
    let cloudEnv = CloudEnv()
    
    private var mealStore: [String: Meal] = [:]

    public init() throws {
        // Run the metrics initializer
        initializeMetrics(router: router)
    }

    func postInit() throws {
        // Endpoints
        initializeHealthRoutes(app: self)
        
        router.post("/meals", handler: storeHandler)
        router.get("/meals", handler: loadHandler)
        router.get("/summary", handler: summaryHandler)
    }
    
    func storeHandler(meal: Meal, completion: (Meal?, RequestError?) -> Void) {
        mealStore[meal.name] = meal
        completion(mealStore[meal.name], nil)
    }
    
    func loadHandler(completion: ([Meal]?, RequestError?) -> Void) {
        let meals: [Meal] = self.mealStore.map({ $0.value })
        completion(meals, nil)
    }
    
    func summaryHandler(completion: (Summary?, RequestError?) -> Void) {
        let summary: Summary = Summary(self.mealStore)
        completion(summary, nil)
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: cloudEnv.port, with: router)
        Kitura.run()
    }
}
