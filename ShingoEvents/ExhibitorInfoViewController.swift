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

    var exhibitor: SIExhibitor!
    
    var exhibitorImageView: UIImageView = {
        let view = UIImageView.newAutoLayoutView()
        view.backgroundColor = .clearColor()
        view.contentMode = .ScaleAspectFit
        return view
    }()
    var contentImageView: UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = .whiteColor()
        return view
    }()
    var descriptionTextField: UITextView = {
        let view = UITextView.newAutoLayoutView()
        view.text = ""
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.backgroundColor = SIColor.shingoBlueColor()
        view.editable = false
        view.scrollEnabled = false
        view.dataDetectorTypes = [UIDataDetectorTypes.Link, UIDataDetectorTypes.PhoneNumber]
        return view
    }()
    var scrollView = UIScrollView.newAutoLayoutView()

    var didUpdateConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = exhibitor.name
        view.backgroundColor = SIColor.shingoBlueColor()
        
        exhibitor.getLogoImage { (image) in
            self.exhibitorImageView.image = image
        }
        
        view.addSubview(scrollView)
        scrollView.addSubviews([contentImageView, descriptionTextField])
        contentImageView.addSubview(exhibitorImageView)
        
        getDescriptionForRichText()
        
        updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        if !didUpdateConstraints {
            
            scrollView.autoPinEdgesToSuperviewEdgesWithNavbar(self, withTopInset: 0)
            
            contentImageView.autoSetDimension(.Height, toSize: 150.0)
            contentImageView.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
            contentImageView.autoPinEdge(.Left, toEdge: .Left, ofView: view)
            contentImageView.autoPinEdge(.Right, toEdge: .Right, ofView: view)
            
            print(contentImageView)
            print(exhibitorImageView.superview)
            
            exhibitorImageView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(5, 5, 5, 5))

            descriptionTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: contentImageView, withOffset: 8)
            descriptionTextField.autoPinEdge(.Left, toEdge: .Left, ofView: view)
            descriptionTextField.autoPinEdge(.Right, toEdge: .Right, ofView: view)
            descriptionTextField.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: scrollView, withOffset: 0)
            
            didUpdateConstraints = true
        }
        super.updateViewConstraints()
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


