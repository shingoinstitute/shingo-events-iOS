//
//  AfilliateViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 2/1/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class AfilliateViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var phoneLabel: UILabel!
//    @IBOutlet weak var websiteTextField: UITextView!
    @IBOutlet weak var abstractTextField: UITextView!
    
    var affiliate:Affiliate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newline = "\n"
        
        if affiliate.logo_image != nil {
            logoImage.image = affiliate.logo_image
        }
        
        if affiliate.name != nil {
            abstractTextField.text = affiliate.name
        } else {
            abstractTextField.text = "Company name not available."
        }
        abstractTextField.text! += newline
        
        if affiliate.phone != nil {
            abstractTextField.text! += "Phone: " + affiliate.phone + newline
        }
        
        if affiliate.email != nil {
            abstractTextField.text! += "Email: " + affiliate.email + newline
        }
        abstractTextField.text! += newline
        
        if affiliate.abstract != nil {
            abstractTextField.text! += affiliate.abstract + newline
        }
        
        if affiliate.website_url != nil {
            abstractTextField.text! += "Visit \(affiliate.name)'s website at "  + affiliate.website_url
        }

    }





}
