//
//  Category.swift
//  YelpDemo
//
//  Created by Alexey Danilov on 29.05.17.
//  Copyright © 2017 danilov. All rights reserved.
//

import Foundation
import SwiftyJSON

class Category {
    
    var alias: String!
    
    var title: String!
    
    static func fromJSON(json: JSON) -> Category {
        let alias = json["alias"].stringValue
        let title = json["title"].stringValue
        return  Category(alias: alias, title: title)
    }
    
    init(alias: String, title: String) {
        self.alias = alias
        self.title = title
    }
    
}
