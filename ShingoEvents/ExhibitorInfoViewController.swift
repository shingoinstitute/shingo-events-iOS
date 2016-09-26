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
        view.backgroundColor = SIColor.shingoBlue
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
        view.backgroundColor = SIColor.shingoBlue
        
        exhibitor.getLogoImage { (image) in
            self.exhibitorImageView.image = image
        }
        
        view.addSubview(scrollView)
        scrollView.addSubviews([contentImageView, descriptionTextField])
        contentImageView.addSubview(exhibitorImageView)
        
        setDescriptionText()
        
//        descriptionTextField.attributedText = exhibitor.attributedSummary
        
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
    
    func setDescriptionText() {
        let attributedString = NSMutableAttributedString()
        
        let attrs = [NSFontAttributeName : UIFont.preferredFont(forTextStyle: .body),
                     NSForegroundColorAttributeName : UIColor.white]
        
        if exhibitor.attributedSummary.string.isEmpty {
            attributedString.append(NSAttributedString(string: "Description coming soon."))
        } else {
            attributedString.append(exhibitor.attributedSummary)
        }
        
        attributedString.append(NSAttributedString(string: "\n\n"))
        
        
        if !exhibitor.website.isEmpty  {
            attributedString.append(NSAttributedString(string: String("Website: \(exhibitor.website)\n")))
        }
        
        if !exhibitor.contactEmail.isEmpty {
            attributedString.append(NSAttributedString(string: String("Email: \(exhibitor.contactEmail)\n")))
        }
        
        attributedString.addAttributes(attrs, range: attributedString.fullRange)
        
        descriptionTextField.attributedText = attributedString
        
        descriptionTextField.linkTextAttributes = [NSForegroundColorAttributeName : UIColor.cyan,
                                                   NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
    }
    

}


