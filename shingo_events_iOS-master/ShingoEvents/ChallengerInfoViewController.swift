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
    
    let logoImage__c:UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clearColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var recipient:Recipient!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        abstractTextField.text = ""
        
        if recipient.logo_book_cover_image != nil
        {
            logoImage.image = recipient.logo_book_cover_image
            logoImage.layer.borderColor = UIColor.grayColor().CGColor
            logoImage.layer.borderWidth = 1.0
            logoImage.layer.cornerRadius = 1.0
        }
        else
        {
            logoImage.removeFromSuperview() // Why? Because screw you interface builder, that's why.
            view.addSubview(logoImage__c)
            logoImage__c.autoSetDimensionsToSize(CGSize(width: 200, height: 200))
            logoImage__c.autoPinToTopLayoutGuideOfViewController(self, withInset: 8.0)
            logoImage__c.autoPinEdgeToSuperviewEdge(.Left, withInset: 8.0)

            abstractTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: logoImage__c, withOffset: 8.0)
            
            logoImage__c.image = UIImage(named: "logoComingSoon500x500")

            logoImage__c.layer.borderColor = UIColor.grayColor().CGColor
            logoImage__c.layer.borderWidth = 1.0
            logoImage__c.layer.cornerRadius = 4.0
        }
        

        
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
