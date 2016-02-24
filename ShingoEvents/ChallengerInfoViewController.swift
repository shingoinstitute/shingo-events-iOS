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
    
    var recipient:Recipient!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        abstractTextField.text = ""
        
        if recipient.logo_book_cover_image != nil {
            logoImage.image = recipient.logo_book_cover_image
        } else {
            logoImage.image = UIImage(named: "shingo_icon")
        }
        
        logoImage.image = recipient.logo_book_cover_image
        logoImage.layer.borderColor = UIColor.blackColor().CGColor
        logoImage.layer.cornerRadius = 5.0
        
        if recipient.name != nil && recipient.award != nil {
            abstractTextField.text = ("Presenting ") + recipient.name
            abstractTextField.text! += ", recipient of the " + recipient.award + ".\n"
        }
        
        if let text = recipient.abstract {
            abstractTextField.text! += text
        }
        
        abstractTextField.textColor = .whiteColor()
        abstractTextField.font = UIFont.systemFontOfSize(16)
        
        var frame:CGRect = abstractTextField.frame
        frame.size.height = abstractTextField.contentSize.height
        abstractTextField.frame = frame
        abstractTextField.scrollEnabled = false
    }

}
