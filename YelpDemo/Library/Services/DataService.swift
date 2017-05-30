//
//  DataService.swift
//  YelpDemo
//
//  Created by Alexey Danilov on 28.05.17.
//  Copyright © 2017 danilov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DataService {
    
    let cientID = "A6jJ20wf9AauCAi_qVvuWw"
    
    let clientSecret = "OvN0vbq4yuH7Lq8yLmj6Jfg4hbTabM0WhKXKaSc5tqj7cgFC3yRzbZQLP6L7F2in"
    
    var accessToken = "A6Dyw2nasLSbiylrEBlc7RG3-GbVVXyOiILJQjbWxrVdUJxGxV9MPEeujc0zJRn2SwfiKtE2F9TLYEioEg-xwCaXRZL1cpcPj1TFUT7QUqdAEfC7gi9SsupAj-AqWXYx"
    
    static let sharedInstance = DataService()
    
    private init() {}
    
    func loadRestaurantsForLatLong(latitude: Double, longitude: Double, successCallback: @escaping (_ restaurantArray: Array<JSON>) -> Void, errorHandler: @escaping (_ errorMessage: String) -> Void) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.accessToken)"
        ]
        
        let parameters: Parameters = [
            "latitude": latitude,
            "longitude": longitude,
            "term": "restaurants"
            
        ]
        
        Alamofire.request(GlobalConstants.YelpAPIUrls.search, parameters: parameters, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    let reviews = json["businesses"]
                    if let array = reviews.array {
                        successCallback(array)
                    } else {
                        successCallback(Array<JSON>())
                    }
                }
            case .failure(let error):
                errorHandler(error.localizedDescription)
            }
        }
    }
    
    func loadReviewsFor(id: String, successCallback: @escaping (_ reviewsArray: Array<JSON>) -> Void,
                        errorHandler: @escaping (_ errorMessage: String) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.accessToken)"
        ]
        
        Alamofire.request(GlobalConstants.YelpAPIUrls.businesses + id + "/reviews", headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    let reviews = json["reviews"]
                    if let array = reviews.array {
                        successCallback(array)
                    } else {
                        successCallback(Array<JSON>())
                    }
                }
            case .failure(let error):
                errorHandler(error.localizedDescription)
            }
        }
    }
    
}
