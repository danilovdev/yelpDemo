//
//  CustomInfoWindow.swift
//  YelpDemo
//
//  Created by Alexey Danilov on 29.05.17.
//  Copyright © 2017 danilov. All rights reserved.
//

import UIKit
import Cosmos

class CustomInfoWindow: UIView {
    
    var restaurant: Restaurant! {
        didSet {
            self.ratingStarsView.rating = self.restaurant.rating
            self.ratingLabel.text = String(format: "%.2g", self.restaurant.rating)
            self.nameLabel.text = self.restaurant.name
            self.addressLabel.text = self.restaurant.getAddressStr()
        }
    }

    @IBOutlet weak var ratingStarsView: CosmosView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    
}
