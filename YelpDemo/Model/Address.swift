//
//  Address.swift
//  YelpDemo
//
//  Created by Alexey Danilov on 29.05.17.
//  Copyright © 2017 danilov. All rights reserved.
//

import Foundation
import SwiftyJSON

class Address {
    
    var city: String!
    
    var country: String!
    
    var address2: String!
    
    var address3: String!
    
    var state: String!
    
    var address1: String!
    
    var zipCode: String!
    
    static func fromJSON(json: JSON) -> Address {
        
        let city = json["city"].stringValue
        let country = json["country"].stringValue
        let address2 = json["address2"].stringValue
        let address3 = json["address3"].stringValue
        let state = json["state"].stringValue
        let address1 = json["address1"].stringValue
        let zipCode = json["zip_code"].stringValue
        
        return Address(city: city,
                       country: country,
                       address2: address2,
                       address3: address3,
                       state: state,
                       address1: address1,
                       zipCode: zipCode)
        
       
    }
    
    init(city: String,
         country: String,
         address2: String,
         address3: String,
         state: String,
         address1: String,
         zipCode: String!) {
        
        self.city = city
        self.country = country
        self.address2 = address2
        self.address3 = address3
        self.state = state
        self.address1 = address1
        self.zipCode = zipCode
        
    }
    
    func getAddressString() -> String {
        return "\(self.zipCode!), \(self.address1!), \(self.city!)"
    }

}
