//
//  PhotoViewController.swift
//  Photos
//
//  Created by Kunal Patel on 11/15/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import Foundation
import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    @IBOutlet weak var isLikedImage: UIImageView!
    var photo:Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.text   = photo!.username
        
        numberOfLikesLabel.text = String(photo!.likes)
        
        let url = NSURL(string: photo!.url)
        if let data = NSData(contentsOfURL: url!) {
            image.image = UIImage(data: data)
        }
        if (photo!.isLiked) {
            isLikedImage.image = UIImage(named: "heartRed.png")
        }
        else {
            isLikedImage.image = UIImage(named: "heartGrey.png")
        }
        
        isLikedImage.userInteractionEnabled  = true
        isLikedImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action:Selector("tappedLikeButton")))
    }
    
    func tappedLikeButton() {
        
        if (photo!.isLiked) {
            numberOfLikesLabel.text = String (photo!.likes)
            photo!.isLiked = false
            isLikedImage.image = UIImage(named: "heartGrey.png")

        }
        else {
//            photo!.likes + = 1
            numberOfLikesLabel.text = String (photo!.likes + 1)
            photo!.isLiked = true
            isLikedImage.image = UIImage(named: "heartRed.png")

        }
    }
}