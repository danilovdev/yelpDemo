//
//  Restaurant.swift
//  YelpDemo
//
//  Created by Alexey Danilov on 28.05.17.
//  Copyright © 2017 danilov. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SwiftyJSON

class Restaurant: NSObject, MKAnnotation {
    
//    var restaurantImage: UIImage!
//    
//    var name: String!
//    
//    var phoneNumber: String!
//    
//    var categories: String!
//    
//    var rating: Double!
//    
//    var reviews: Array<String>!
//    
//    var coordinate: CLLocationCoordinate2D
    
    init(rating: Double,
         phone: String,
         id: String,
         categories: Array<Category>,
         reviewCount: Int,
         name: String,
         coordinate: CLLocationCoordinate2D,
         imageUrlStr: String,
         address: Address) {
        
        
        self.rating = rating
        self.phone = phone
        self.id = id
        self.categories = categories
        self.reviewCount = reviewCount
        self.name = name
        self.coordinate = coordinate
        self.imageUrlStr = imageUrlStr
        self.address = address
        
        super.init()
    }
    
    static func fromJSON(json: JSON) -> Restaurant {
        
        let rating = json["rating"].doubleValue
        let phone = json["phone"].stringValue
        let id = json["id"].stringValue
        
        var categories = Array<Category>()
        let categoriesJsonArray = json["categories"].array!
        for item in categoriesJsonArray {
            let category = Category.fromJSON(json: item)
            categories.append(category)
        }
        
        
        let latitude = json["coordinates"]["latitude"].doubleValue
        let longitude = json["coordinates"]["longitude"].doubleValue
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let reviewCount = json["review_count"].intValue
        let name = json["name"].stringValue
        let imageUrlStr = json["image_url"].stringValue
        
        let address = Address.fromJSON(json: json["location"])
        
        
        return Restaurant(rating: rating,
                          phone: phone,
                          id: id,
                          categories: categories,
                          reviewCount: reviewCount,
                          name: name,
                          coordinate: coordinate,
                          imageUrlStr: imageUrlStr,
                          address: address)
    }
    
    var rating: Double!
    
    var phone: String!
    
    var id: String!
    
    var categories: Array<Category>!
    
    var reviewCount: Int!
    
    var name: String!
    
    var coordinate: CLLocationCoordinate2D
    
    var imageUrlStr: String!
    
    var address: Address!
    
    var reviews: Array<Review>!
    
    func getAddressStr() -> String {
        return self.address.getAddressString()
    }
    
    func getCategoriesString() -> String {
        var catStr = ""
        for i in 0...(self.categories.count - 1) {
            let cat = self.categories[i]
            catStr += cat.title
            if i != (self.categories.count - 1) {
                catStr += ", "
            }
        }
        return catStr
    }
    
}
