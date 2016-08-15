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
        
        getDescriptionForRichText()
        
        view.addSubview(scrollView)
        view.addSubview(backdrop)
        
        scrollView.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
        scrollView.autoPinEdgeToSuperviewEdge(.Left)
        scrollView.autoPinEdgeToSuperviewEdge(.Right)
        scrollView.autoPinEdgeToSuperviewEdge(.Bottom)
        
        scrollView.addSubview(exhibitorImage)
        scrollView.addSubview(descriptionTextField)
        view.bringSubviewToFront(scrollView)
        
        exhibitorImage.image = exhibitor.getLogoImage()
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
        let richText = NSMutableAttributedString()
        let attrs = [NSFontAttributeName : UIFont.systemFontOfSize(16.0),
                     NSForegroundColorAttributeName : UIColor.whiteColor()]
        descriptionTextField.linkTextAttributes = [NSForegroundColorAttributeName : UIColor.cyanColor(),
                                                   NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue]
                                                   
        
        if !exhibitor.summary.isEmpty {
            let htmlString: String! = "<style>body{color: white;}</style><font size=\"5\">" + exhibitor.summary + "</font></style>";
            do {
            let description = try NSAttributedString(data: htmlString.dataUsingEncoding(NSUTF8StringEncoding)!,
                                                        options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                                            NSCharacterEncodingDocumentAttribute : NSUTF8StringEncoding],
                                                        documentAttributes: nil)
            richText.appendAttributedString(description)
            } catch {
                print("Error with richText in ExhibitorInfoViewController")
            }
        } else {
            richText.appendAttributedString(NSAttributedString(string: "Description coming soon."));
        }
        richText.appendAttributedString(NSAttributedString(string: "\n\n"))
        
        
        if !exhibitor.website.isEmpty  {
            richText.appendAttributedString(NSAttributedString(string: String("Website: " + exhibitor.website + "\n"), attributes: attrs))
        }
        if !exhibitor.contactEmail.isEmpty {
            richText.appendAttributedString(NSAttributedString(string: String("Email: " + exhibitor.contactEmail + "\n"), attributes: attrs))
        } else {
            richText.appendAttributedString(NSAttributedString(string: "Email: Not available\n", attributes: attrs))
        }
        
        descriptionTextField.attributedText = richText;
    }
    

}
