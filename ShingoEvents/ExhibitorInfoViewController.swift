//
//  ExhibitorInfoViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/27/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import PureLayout

class ExhibitorInfoViewController: UIViewController {

    @IBOutlet weak var exhibitorImage: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    var exhibitor:Exhibitor!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        exhibitorImage.layer.cornerRadius = 5.0

        if exhibitor.logo_image != nil
        {
            exhibitorImage.image = exhibitor.logo_image
            
            if exhibitorImage.image?.size.width >= view.frame.width * 0.9
            {
                exhibitorImage.autoSetDimension(.Height, toSize: 150.0)
                exhibitorImage.autoSetDimension(.Width, toSize: view.frame.width - 16.0)
            }

            if exhibitorImage.image?.size.width < view.frame.width * 0.9
            {
                exhibitorImage.autoSetDimension(.Height, toSize: (exhibitorImage.image?.size.height)!)
                exhibitorImage.autoSetDimension(.Width, toSize: (exhibitorImage.image?.size.width)!)
            }
            
        }
        else
        {
            exhibitorImage.image = UIImage(named: "200x200PL")
        }
        
        if exhibitor.name != nil
        {
            descriptionTextField.text = exhibitor.name + "\n"
        }

        if exhibitor.email != nil
        {
            descriptionTextField.text! += "Email: " + exhibitor.email! + "\n"
        }
        else
        {
            descriptionTextField.text! += "Email: Not available\n"
        }

        if let phoneText = exhibitor?.phone {
            descriptionTextField.text! += "Phone: " + phoneText + "\n\n"
        } else {
            descriptionTextField.text! += "Phone: Not available\n\n"
        }

        if exhibitor.description != nil
        {
            descriptionTextField.text! += exhibitor.description + "\n"
        }
        else
        {
            descriptionTextField.text! += "Company description coming soon.\n"
        }
        
        if exhibitor.website != nil
        {
            descriptionTextField.text! += "Visit " + exhibitor.name + "'s website at " + exhibitor.website + "\n"
        }

        var frame:CGRect = descriptionTextField.frame
        frame.size.height = descriptionTextField.contentSize.height
        descriptionTextField.frame = frame
        descriptionTextField.scrollEnabled = false

        

    }
    

}
