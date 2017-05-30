//
//  ContainerView.swift
//  YelpDemo
//
//  Created by Alexey Danilov on 30.05.17.
//  Copyright © 2017 danilov. All rights reserved.
//

import Foundation
import UIKit

class ContainerView : UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, with: event)
        if result == self { return nil }
        return result
    }
    
}
