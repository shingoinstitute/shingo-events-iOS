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
        
        setSummaryText()

        updateViewConstraints()
        
    }
    
    override func updateViewConstraints() {
        if !didUpdateConstraints {
            
            logoImage.removeFromSuperview()
            abstractTextField.removeFromSuperview()

            view.addSubviews([backgroundView, scrollView])
            scrollView.addSubviews([logoImage, abstractTextField])
            
            scrollView.autoPinToTopLayoutGuideOfViewController(self, withInset: 8)
            scrollView.autoPinEdgeToSuperviewEdge(.Left)
            scrollView.autoPinEdgeToSuperviewEdge(.Right)
            scrollView.autoPinEdgeToSuperviewEdge(.Bottom)
            
            logoImage.autoPinEdgeToSuperviewEdge(.Top)
            logoImage.autoPinEdge(.Left, toEdge: .Left, ofView: view, withOffset: 8)
            logoImage.autoPinEdge(.Right, toEdge: .Right, ofView: view, withOffset: 8)
            logoImage.contentMode = .ScaleAspectFit
            
            abstractTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: logoImage, withOffset: 8)
            abstractTextField.autoPinEdge(.Left, toEdge: .Left, ofView: view, withOffset: 0)
            abstractTextField.autoPinEdge(.Right, toEdge: .Right, ofView: view, withOffset: 0)
            abstractTextField.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: scrollView, withOffset: 0)
            abstractTextField.scrollEnabled = false
            
            backgroundView.autoPinEdge(.Top, toEdge: .Bottom, ofView: logoImage, withOffset: 8)
            backgroundView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: view)
            backgroundView.autoPinEdge(.Left, toEdge: .Left, ofView: view)
            backgroundView.autoPinEdge(.Right, toEdge: .Right, ofView: view)
            
            didUpdateConstraints = true
        }
        super.updateViewConstraints()
    }
    
    private func setSummaryText() {
        
        abstractTextField.backgroundColor = SIColor.prussianBlueColor()
        abstractTextField.text = ""
        abstractTextField.textColor = .whiteColor()
        abstractTextField.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        recipient.getRecipientImage() { image in
            self.logoImage.image = image
        }
        
        if !recipient.summary.isEmpty {
            do {
                let attributedText = try NSMutableAttributedString(data: recipient.summary.dataUsingEncoding(NSUTF8StringEncoding)!,
                                                                          options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                                                            NSCharacterEncodingDocumentAttribute : NSUTF8StringEncoding,
                                                                            NSForegroundColorAttributeName : UIColor.whiteColor()],
                                                                          documentAttributes: nil)
                attributedText.addAttributes([NSFontAttributeName : UIFont.helveticaOfFontSize(16), NSForegroundColorAttributeName : UIColor.whiteColor()], range: NSMakeRange(0, attributedText.string.characters.count - 1))
                
                abstractTextField.attributedText = attributedText
            } catch {
                let error = NSError(domain: "NSAttributedString",
                                    code: 72283,
                                    userInfo: [
                                        NSLocalizedDescriptionKey : "Could not parse text for recipient summary.",
                                        NSLocalizedFailureReasonErrorKey: "Could not parse text for recipient summary. Most likely reason is because the text passed back from the API was not UTF-8 coding compliant."
                                    ])
                Crashlytics.sharedInstance().recordError(error)
            }
        }
    }

}
