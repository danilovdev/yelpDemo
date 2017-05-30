//
//  RestaurantDetailViewController.swift
//  YelpDemo
//
//  Created by Alexey Danilov on 28.05.17.
//  Copyright © 2017 danilov. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Cosmos
import SnapKit

class RestaurantDetailViewController: UIViewController {
    
    @IBOutlet weak var containerStackView: ContainerStackView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var restaurant: Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.text = self.restaurant.name
        nameLabel.numberOfLines = 0
        self.containerStackView.addArrangedSubview(nameLabel)
        
        let nameContainerView = UIView()
        nameContainerView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(5)
            make.bottom.equalTo(5)
        }
        
        self.containerStackView.addArrangedSubview(nameContainerView)
        
        if let imageUrlStr = self.restaurant.imageUrlStr {
            if let imageUrl = URL(string: imageUrlStr) {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                imageView.af_setImage(withURL: imageUrl)
                self.containerStackView.insertArrangedSubview(imageView, at: 1)
                imageView.snp.makeConstraints({ make in
                    make.width.equalTo(self.view)
                    make.height.equalTo(self.view).multipliedBy(0.4)
                })
            }
        }
        
        let ratingStackView = UIStackView()
        ratingStackView.axis = .horizontal
        ratingStackView.spacing = 5
        
        let ratingStarsView = CosmosView()
        ratingStarsView.settings.fillMode = StarFillMode(rawValue: 2)!
        ratingStarsView.settings.emptyBorderColor = .lightGray
        ratingStarsView.settings.emptyColor = .lightGray
        ratingStarsView.rating = self.restaurant.rating
        ratingStackView.addArrangedSubview(ratingStarsView)

        
        let ratingLabel = UILabel()
        ratingLabel.textAlignment = .left
        ratingLabel.text = "(" + String(format: "%.2g", self.restaurant.rating) + ")"
        ratingStackView.addArrangedSubview(ratingLabel)
        
        
        let ratingContainerView = UIView()
        ratingContainerView.addSubview(ratingStackView)
        
        self.containerStackView.addArrangedSubview(ratingContainerView)
        
        ratingStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(5)
            make.bottom.equalTo(5)
        }
        
        let attributedString = NSMutableAttributedString(string: self.restaurant.phone)
        let textRange = NSMakeRange(0, (self.restaurant.phone.characters.count))
        
        let boldItalicsFont = UIFont(name: "Avenir-HeavyOblique", size: 18.0)!
        
        attributedString.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
        
        attributedString.addAttribute(
                    NSLinkAttributeName, value: self.restaurant.phone,
                    range: textRange)
        
        attributedString.addAttribute(
                    NSForegroundColorAttributeName, value: UIColor.blue,
                    range: textRange)
        
        attributedString.addAttribute(NSFontAttributeName, value: boldItalicsFont, range: textRange)
        
        
        let phoneStackView = UIStackView()
        phoneStackView.axis = .horizontal
        phoneStackView.spacing = 5
        
        let phoneTitleLabel = UILabel()
        phoneTitleLabel.text = "Phone: "
        phoneTitleLabel.textAlignment = .right
        
        phoneStackView.addArrangedSubview(phoneTitleLabel)
        
        let phoneLabel = UILabel()
        phoneLabel.textAlignment = .left
        phoneLabel.isUserInteractionEnabled = true
        phoneLabel.attributedText = attributedString
        
        phoneStackView.addArrangedSubview(phoneLabel)
        
        let phoneContainerView = UIView()
        
        phoneContainerView.addSubview(phoneStackView)
        
        phoneStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(5)
            make.bottom.equalTo(5)
        }
        
        self.containerStackView.addArrangedSubview(phoneContainerView)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RestaurantDetailViewController.phoneClicked))
        phoneLabel.addGestureRecognizer(gestureRecognizer)
        
        
        if self.restaurant.categories.count > 0 {
            let categoriesTitleLabel = UILabel()
            categoriesTitleLabel.text = "Categories"
            categoriesTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            categoriesTitleLabel.textAlignment = .center
            self.containerStackView.addArrangedSubview(categoriesTitleLabel)
            
            let categoriesValueLabel = UILabel()
            categoriesValueLabel.numberOfLines = 0
            categoriesValueLabel.textAlignment = .center
            categoriesValueLabel.text = self.restaurant.getCategoriesString()
            self.containerStackView.addArrangedSubview(categoriesValueLabel)
        }
        
        let reviewsTitleLabel = UILabel()
        reviewsTitleLabel.text = "Reviews"
        reviewsTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        reviewsTitleLabel.textAlignment = .center
        self.containerStackView.addArrangedSubview(reviewsTitleLabel)
        
        self.loadReviewsFor(id: self.restaurant.id)
        
    }
    
    func phoneClicked() {
        guard let number = URL(string: "telprompt://" + self.restaurant.phone) else { return }
        
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
   
    func loadReviewsFor(id: String) {
        DataService.sharedInstance.loadReviewsFor(id: self.restaurant.id, successCallback: { reviewsArray in
            
            if reviewsArray.count == 0 {
                
                let noReviewsLabel = UILabel()
                noReviewsLabel.text = "There are no reviews!"
                noReviewsLabel.textAlignment = .center
                self.containerStackView.addArrangedSubview(noReviewsLabel)
                
            }
            
            for item in reviewsArray {
                let review = Review.fromJSON(json: item)
                
                let userReview = UserReview()
                userReview.review = review
                self.containerStackView.addArrangedSubview(userReview)
            }
        }, errorHandler: { errorMessage in
            self.showAlert(title: "Error", message: errorMessage)
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.contentSize = CGSize(width: self.containerStackView.frame.width, height: self.containerStackView.frame.height)
    }
 
}
