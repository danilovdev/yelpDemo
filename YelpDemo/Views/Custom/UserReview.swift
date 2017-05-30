//
//  UserReview.swift
//  YelpDemo
//
//  Created by Alexey Danilov on 30.05.17.
//  Copyright © 2017 danilov. All rights reserved.
//

import Foundation
import UIKit
import Cosmos
import Alamofire
import AlamofireImage


class UserReview: ContainerView {
    
    var review: Review! {
        didSet {
            self.reviewTextLabel.text = self.review.text
            self.ratingLabel.text = String(format: "%.2g", self.review.rating)
            self.usernameLabel.text = self.review.userName
            self.ratingStarsView.rating = self.review.rating
            self.reviewDateTimeLabel.text = self.review.timeCreated
            
            if let userImageUrlStr = self.review.userImageUrlStr {
                if let userImageUrl = URL(string: userImageUrlStr) {
                    self.userImageView.af_setImage(withURL: userImageUrl)
                }
            }
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var reviewTextLabel: UILabel!
    
    @IBOutlet weak var reviewDateTimeLabel: UILabel!
    
    @IBOutlet weak var ratingStarsView: CosmosView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet var mainView: ContainerView!
    
    @IBOutlet weak var bottomLineView: UIView!
    
    @IBOutlet weak var linkToReviewLabel: UILabel!
    
    @IBOutlet weak var topContainer: UIView!
    
    @IBOutlet weak var bottomContainer: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadViewFromNib()
    }
    
    private func loadViewFromNib() {
        Bundle.main.loadNibNamed("UserReview", owner: self, options: nil)
        self.mainView.frame = self.bounds
        self.mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(self.mainView)
        self.configureLinkLabel()
        
    }
    
    func configureLinkLabel() {
        let str = "See full review on www.yelp.com"
        let attributedString = NSMutableAttributedString(string: str)
        let textRange = NSMakeRange(0, (str.characters.count))
        
        let boldItalicsFont = UIFont(name: "Avenir-HeavyOblique", size: 18.0)!
        
        attributedString.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
        
        attributedString.addAttribute(
            NSLinkAttributeName, value: str,
            range: textRange)
        
        attributedString.addAttribute(
            NSForegroundColorAttributeName, value: UIColor.blue,
            range: textRange)
        
        attributedString.addAttribute(NSFontAttributeName, value: boldItalicsFont, range: textRange)
        
        self.linkToReviewLabel.isUserInteractionEnabled = true
        self.linkToReviewLabel.attributedText = attributedString
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UserReview.linkClicked))
        self.linkToReviewLabel.isUserInteractionEnabled = true
        self.linkToReviewLabel.addGestureRecognizer(gestureRecognizer)
    }
    
    func linkClicked() {
        UIApplication.shared.open(URL(string: self.review.urlStr)!, options: [:], completionHandler: nil)
    }
    
}
