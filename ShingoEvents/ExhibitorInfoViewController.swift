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

    var exhibitorImage = UIImageView.newAutoLayoutView()
    var descriptionTextField = UITextView.newAutoLayoutView()
    var scrollView = UIScrollView.newAutoLayoutView()
    var backdrop: UIView = {
        let view = UIView()
        view.backgroundColor = SIColor().shingoBlueColor
        return view
    }()
    
    var exhibitor: SIExhibitor!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = exhibitor.name
        
        descriptionTextField.text = ""
        
        if exhibitor.richDescription != nil {
            getDescriptionForRichText()
        } else {
            getDescriptionForPlainText()
        }
    
        
        view.addSubview(scrollView)
        view.addSubview(backdrop)
        
        scrollView.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
        scrollView.autoPinEdgeToSuperviewEdge(.Left)
        scrollView.autoPinEdgeToSuperviewEdge(.Right)
        scrollView.autoPinEdgeToSuperviewEdge(.Bottom)
        
        scrollView.addSubview(exhibitorImage)
        scrollView.addSubview(descriptionTextField)
        view.bringSubviewToFront(scrollView)
        
        exhibitorImage.image = exhibitor.logoImage
        exhibitorImage.contentMode = .ScaleAspectFit
        exhibitorImage.autoSetDimension(.Height, toSize: 150.0)
        exhibitorImage.autoPinEdgeToSuperviewEdge(.Top, withInset: 8)
        exhibitorImage.autoAlignAxisToSuperviewAxis(.Vertical)
        exhibitorImage.layer.cornerRadius = 3
        exhibitorImage.clipsToBounds = true
        
        descriptionTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: exhibitorImage, withOffset: 8)
        descriptionTextField.autoPinEdge(.Left, toEdge: .Left, ofView: view)
        descriptionTextField.autoPinEdge(.Right, toEdge: .Right, ofView: view)
        descriptionTextField.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: scrollView, withOffset: 0)
        descriptionTextField.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        descriptionTextField.backgroundColor = SIColor().shingoBlueColor
        descriptionTextField.editable = false
        descriptionTextField.dataDetectorTypes = [UIDataDetectorTypes.Link, UIDataDetectorTypes.PhoneNumber]
        
        backdrop.autoPinEdge(.Top, toEdge: .Top, ofView: descriptionTextField)
        backdrop.autoPinEdgeToSuperviewEdge(.Right)
        backdrop.autoPinEdgeToSuperviewEdge(.Left)
        backdrop.autoPinEdgeToSuperviewEdge(.Bottom)
        
        
        var frame:CGRect = descriptionTextField.frame
        frame.size.height = descriptionTextField.contentSize.height
        descriptionTextField.frame = frame
        descriptionTextField.scrollEnabled = false
    }
    
    
    
    func getDescriptionForRichText() {
        let richText = NSMutableAttributedString();
        let attrs = [NSFontAttributeName : UIFont.systemFontOfSize(16.0),
                     NSForegroundColorAttributeName : UIColor.whiteColor()]
        descriptionTextField.linkTextAttributes = [NSForegroundColorAttributeName : UIColor.cyanColor(),
                                                   NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue]
                                                   
        
        if exhibitor.richDescription != nil {
            let htmlString: String! = "<style>body{color:white;}</style><font size=\"5\">" + exhibitor.richDescription! + "</font></style>";
            do {
            let description = try NSAttributedString(data: htmlString.dataUsingEncoding(NSUTF8StringEncoding)!,
                                                        options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                                            NSCharacterEncodingDocumentAttribute : NSUTF8StringEncoding],
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
    
    func getDescriptionForPlainText() {
        if !exhibitor.name.isEmpty {
            descriptionTextField.text = exhibitor.name + "\n"
        }
        
        if exhibitor.email != nil {
            descriptionTextField.text! += "Email: " + exhibitor.email! + "\n"
        } else {
            descriptionTextField.text! += "Email: Not available\n"
        }
        
        if let phoneText = exhibitor?.phone {
            descriptionTextField.text! += "Phone: " + phoneText + "\n\n"
        } else {
            descriptionTextField.text! += "Phone: Not available\n\n"
        }
        
        if exhibitor.description != nil {
            descriptionTextField.text! += exhibitor.description + "\n"
        } else {
            descriptionTextField.text! += "Company description coming soon.\n"
        }
        
        if exhibitor.website != nil {
            descriptionTextField.text! += "Visit " + exhibitor.name + "'s website at " + exhibitor.website + "\n"
        }
    }
    

}
