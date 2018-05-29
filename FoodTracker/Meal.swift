//
//  Meal.swift
//  FoodTracker
//
//  Created by Alexander Ogilvie on 28/05/2018.
//  Copyright © 2018 Alexander Ogilvie. All rights reserved.
//

import UIKit

class Meal {
    //MARK: Properties
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: Initialisation
    init?(name: String, photo: UIImage?, rating: Int) {
        // Name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusive
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // Initialise stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
    }
}
