//
//  Review.swift
//  YelpDemo
//
//  Created by Alexey Danilov on 29.05.17.
//  Copyright © 2017 danilov. All rights reserved.
//

import Foundation
import SwiftyJSON

class Review {
    
    var rating: Double!
    
    var userImageUrlStr: String!
    
    var userName: String!
    
    var text: String!
    
    var timeCreated: String!
    
    var urlStr: String!
    
    init(rating: Double, userName: String, userImageUrlStr: String, text: String, timeCreated: String, urlStr: String) {
        self.rating = rating
        self.userName = userName
        self.userImageUrlStr = userImageUrlStr
        self.text = text
        self.timeCreated = timeCreated
        self.urlStr = urlStr
    }
    
    static func fromJSON(json: JSON) -> Review {
        
        let rating = json["rating"].doubleValue
        let userName = json["user"]["name"].stringValue
        let userImageUrlStr = json["user"]["image_url"].stringValue
        let text = json["text"].stringValue
        let timeCreated = json["time_created"].stringValue
        let urlStr = json["url"].stringValue
        
        return Review(rating: rating, userName: userName, userImageUrlStr: userImageUrlStr, text: text, timeCreated: timeCreated, urlStr: urlStr)
        
        
    }
    
}
