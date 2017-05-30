//
//  GlobalConstants.swift
//  YelpDemo
//
//  Created by Alexey Danilov on 29.05.17.
//  Copyright © 2017 danilov. All rights reserved.
//

import Foundation

import ChameleonFramework

class GlobalConstants {
    
    struct Color {
        static let mainColor =  UIColor(hexString: "64a9c3")!
    }
    
    struct YelpAPIUrls {
        
        static let token =  "https://api.yelp.com/oauth2/token"
        
        static let businesses =  "https://api.yelp.com/v3/businesses/"
        
        static let search =  YelpAPIUrls.businesses + "search"
        
    }
    
    static let GOOGLE_API_KEY = "AIzaSyAg3hDYe_WFhKxbUY7WHb3N0NxMOv1R2gQ"
    
    static let YELP_CLIENT_ID = "A6jJ20wf9AauCAi_qVvuWw"
    
    static let YELP_CLIENT_SECRET = "OvN0vbq4yuH7Lq8yLmj6Jfg4hbTabM0WhKXKaSc5tqj7cgFC3yRzbZQLP6L7F2in"
    
    static let YELP_ACCESS_TOKEN = "A6Dyw2nasLSbiylrEBlc7RG3-GbVVXyOiILJQjbWxrVdUJxGxV9MPEeujc0zJRn2SwfiKtE2F9TLYEioEg-xwCaXRZL1cpcPj1TFUT7QUqdAEfC7gi9SsupAj-AqWXYx"
    
}
