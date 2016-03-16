//
//  ChallengerInfoViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/26/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class ChallengerInfoViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var abstractTextField: UITextView!
//    @IBOutlet weak var scrollView: UIScrollView!
    
    var recipient:Recipient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        abstractTextField.text = ""
        self.automaticallyAdjustsScrollViewInsets = false
        if recipient.logo_book_cover_image != nil
        {
            logoImage.image = recipient.logo_book_cover_image
            if logoImage.image?.size.width > (view.frame.width * 0.75) {
                var height = logoImage.image?.size.height
                var width = logoImage.image?.size.width
                let aspectRatio = height! / width!
                
                width = view.frame.width * 0.75
                height = width! * aspectRatio
                logoImage.autoSetDimensionsToSize(CGSize(width: width!, height: height!))
            }
        }
        else
        {
            logoImage.image = UIImage(named: "logoComingSoon500x500")
            logoImage.autoSetDimensionsToSize(CGSize(width: 200, height: 200))
            logoImage.layer.borderColor = UIColor.lightGrayColor().CGColor
            logoImage.layer.borderWidth = 1.0
            logoImage.layer.cornerRadius = 4.0
        }
        


        
        if recipient.name != nil && recipient.award != nil {
            abstractTextField.text = ("Presenting ") + recipient.name
            abstractTextField.text! += ", recipient of the " + recipient.award + ".\n\n"
        }
        
        if let text = recipient.abstract {
            abstractTextField.text! += text
        }
        
        abstractTextField.textColor = .whiteColor()
        abstractTextField.font = UIFont.systemFontOfSize(16)

    }
    


}
