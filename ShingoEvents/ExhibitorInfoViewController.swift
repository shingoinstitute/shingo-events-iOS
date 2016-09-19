//
//  ExhibitorInfoViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/27/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import PureLayout
import Crashlytics

class ExhibitorInfoViewController: UIViewController {

    var exhibitor: SIExhibitor!
    
    var exhibitorImageView: UIImageView = {
        let view = UIImageView.newAutoLayout()
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        return view
    }()
    var contentImageView: UIView = {
        let view = UIView.newAutoLayout()
        view.backgroundColor = .white
        return view
    }()
    var descriptionTextField: UITextView = {
        let view = UITextView.newAutoLayout()
        view.text = ""
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.backgroundColor = SIColor.shingoBlueColor()
        view.isEditable = false
        view.isScrollEnabled = false
        view.dataDetectorTypes = [UIDataDetectorTypes.link, UIDataDetectorTypes.phoneNumber]
        return view
    }()
    var scrollView = UIScrollView.newAutoLayout()

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
            
            contentImageView.autoSetDimension(.height, toSize: 150.0)
            contentImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            contentImageView.autoPinEdge(.left, to: .left, of: view)
            contentImageView.autoPinEdge(.right, to: .right, of: view)
            
            exhibitorImageView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsetsMake(5, 5, 5, 5))

            descriptionTextField.autoPinEdge(.top, to: .bottom, of: contentImageView, withOffset: 8)
            descriptionTextField.autoPinEdge(.left, to: .left, of: view)
            descriptionTextField.autoPinEdge(.right, to: .right, of: view)
            descriptionTextField.autoPinEdge(.bottom, to: .bottom, of: scrollView, withOffset: 0)
            
            didUpdateConstraints = true
        }
        super.updateViewConstraints()
    }
    
    func getDescriptionForRichText() {
        let richText = NSMutableAttributedString()
        let attrs = [NSFontAttributeName : UIFont.systemFont(ofSize: 16.0),
                     NSForegroundColorAttributeName : UIColor.white]
        descriptionTextField.linkTextAttributes = [NSForegroundColorAttributeName : UIColor.cyan,
                                                   NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
                                                   
        
        if !exhibitor.summary.isEmpty {
            let htmlString: String! = "<style>body{color: white;}</style><font size=\"5\">" + exhibitor.summary + "</font></style>";
            do {
            let description = try NSAttributedString(data: htmlString.data(using: String.Encoding.utf8)!,
                                                        options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                                            NSCharacterEncodingDocumentAttribute : String.Encoding.utf8],
                                                        documentAttributes: nil)
            richText.append(description)
            } catch {
                let error = NSError(domain: "NSAttributedString",
                                    code: 72283,
                                    userInfo: [
                                        NSLocalizedDescriptionKey : "Could not parse text for exhibitor summary.",
                                        NSLocalizedFailureReasonErrorKey: "Could not parse text for exhibitor summary. Most likely reason is because the text passed back from the API was not UTF-8 coding compliant."
                                    ])
                Crashlytics.sharedInstance().recordError(error)
            }
        } else {
            richText.append(NSAttributedString(string: "Description coming soon."));
        }
        richText.append(NSAttributedString(string: "\n\n"))
        
        
        if !exhibitor.website.isEmpty  {
            richText.append(NSAttributedString(string: String("Website: " + exhibitor.website + "\n"), attributes: attrs))
        }
        if !exhibitor.contactEmail.isEmpty {
            richText.append(NSAttributedString(string: String("Email: " + exhibitor.contactEmail + "\n"), attributes: attrs))
        }
        
        descriptionTextField.attributedText = richText;
    }
    

}


