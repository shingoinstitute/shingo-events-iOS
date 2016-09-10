//
//  ChallengerInfoViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/26/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import Crashlytics

class ChallengerInfoViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var abstractTextField: UITextView!
    
    var scrollView: UIScrollView = UIScrollView.newAutoLayoutView()
    var backgroundView: UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = SIColor.prussianBlueColor()
        return view
    }()
    
    var recipient: SIRecipient!
    
    var didUpdateConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = recipient.name
        automaticallyAdjustsScrollViewInsets = false
        
        recipientSetup()

        view.setNeedsUpdateConstraints()
        
    }
    
    override func updateViewConstraints() {
        if !didUpdateConstraints {
            
            logoImage.removeFromSuperview()
            abstractTextField.removeFromSuperview()

            view.addSubviews([backgroundView, scrollView])
            
            scrollView.autoPinToTopLayoutGuideOfViewController(self, withInset: 8)
            scrollView.autoPinEdgeToSuperviewEdge(.Left)
            scrollView.autoPinEdgeToSuperviewEdge(.Right)
            scrollView.autoPinEdgeToSuperviewEdge(.Bottom)
            scrollView.addSubview(logoImage)
            scrollView.addSubview(abstractTextField)
            
            logoImage.autoPinEdgeToSuperviewEdge(.Top)
            logoImage.autoPinEdgeToSuperviewEdge(.Left, withInset: 8)
            logoImage.autoPinEdgeToSuperviewEdge(.Right, withInset: 8)
            logoImage.contentMode = .ScaleAspectFit
            
            abstractTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: logoImage, withOffset: 8)
            abstractTextField.autoPinEdge(.Left, toEdge: .Left, ofView: view, withOffset: 0)
            abstractTextField.autoPinEdge(.Right, toEdge: .Right, ofView: view, withOffset: 0)
            abstractTextField.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: scrollView, withOffset: 0)
            abstractTextField.scrollEnabled = false
            
            backgroundView.autoPinEdge(.Top, toEdge: .Bottom, ofView: logoImage)
            backgroundView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: view)
            backgroundView.autoPinEdge(.Left, toEdge: .Left, ofView: view)
            backgroundView.autoPinEdge(.Right, toEdge: .Right, ofView: view)
            
            didUpdateConstraints = true
        }
        super.updateViewConstraints()
    }
    
    private func recipientSetup() {
        
        abstractTextField.backgroundColor = SIColor.prussianBlueColor()
        abstractTextField.text = ""
        abstractTextField.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        recipient.getRecipientImage() { image in
            if let image = image {
                self.logoImage.image = image
            }
        }
        
        if !recipient.summary.isEmpty {
            do {
                let htmlString: String! = "<style>body{color:white;}</style><font size=\"5\">" + recipient.summary + "</font></style>";
                abstractTextField.attributedText = try NSAttributedString(data: htmlString.dataUsingEncoding(NSUTF8StringEncoding)!,
                                                                          options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                                                            NSCharacterEncodingDocumentAttribute : NSUTF8StringEncoding],
                                                                          documentAttributes: nil)
            } catch {
                let error = NSError(domain: "NSAttributedString",
                                    code: 111,
                                    userInfo: ["Richtext formatting error" : "Could not parse text for recipient summary."])
                Crashlytics.sharedInstance().recordError(error)
            }
        }
    }

}
