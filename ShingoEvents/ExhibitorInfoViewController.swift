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

        if exhibitor.logo_image != nil {
            exhibitorImage.image = exhibitor.logo_image
            exhibitorImage.contentMode = .ScaleAspectFit
            exhibitorImage.autoSetDimension(.Height, toSize: 150.0)
            exhibitorImage.autoSetDimension(.Width, toSize: view.frame.width - 16.0)
        }
        
        descriptionTextField.text = "";
        
        if exhibitor.richDescription != nil {
            descriptionForRichText()
        } else {
            descriptionForPlainText()
        }
    


        var frame:CGRect = descriptionTextField.frame
        frame.size.height = descriptionTextField.contentSize.height
        descriptionTextField.frame = frame
        descriptionTextField.scrollEnabled = false
    }
    
    func descriptionForRichText() {
        let richText = NSMutableAttributedString();
        let attrs = [NSFontAttributeName : UIFont.systemFontOfSize(16.0),
                     NSForegroundColorAttributeName : UIColor.whiteColor()]
        descriptionTextField.linkTextAttributes = [NSForegroundColorAttributeName : UIColor.cyanColor(),
                                                   NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue]
                                                   
        
        if exhibitor.richDescription != nil {
            let htmlString: String! = "<style>body{color:white;}</style><font size=\"5\">" + exhibitor.richDescription! + "</font></style>";
            do {
            let description = try NSAttributedString(data: htmlString.dataUsingEncoding(NSUTF8StringEncoding)!,
                                                        options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType],
                                                        documentAttributes: nil)
            richText.appendAttributedString(description);
            } catch {
                print("Error with richText in ExhibitorInfoViewController")
            }
        } else {
            richText.appendAttributedString(NSAttributedString(string: "Description coming soon."));
        }
        richText.appendAttributedString(NSAttributedString(string: "\n\n"))
        
        
        if exhibitor.website != nil {
            richText.appendAttributedString(NSAttributedString(string: String("Website: " + exhibitor.website + "\n"), attributes: attrs))
        }
        if exhibitor.email != nil {
            richText.appendAttributedString(NSAttributedString(string: String("Email: " + exhibitor.email + "\n"), attributes: attrs))
        } else {
            richText.appendAttributedString(NSAttributedString(string: "Email: Not available\n", attributes: attrs))
        }
        if exhibitor.phone != nil {
            richText.appendAttributedString(NSAttributedString(string: String("Phone: " + exhibitor.phone + "\n"), attributes: attrs))
        } else {
            richText.appendAttributedString(NSAttributedString(string: "Phone: Not available\n", attributes: attrs))
        }
        
        descriptionTextField.attributedText = richText;
    }
    
    func descriptionForPlainText() {
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
    }
    

}
