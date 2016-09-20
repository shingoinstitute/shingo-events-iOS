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
    
    var scrollView: UIScrollView = UIScrollView.newAutoLayout()
    var backgroundView: UIView = {
        let view = UIView.newAutoLayout()
        view.backgroundColor = SIColor.prussianBlue()
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
            
            scrollView.autoPin(toTopLayoutGuideOf: self, withInset: 8)
            scrollView.autoPinEdge(toSuperviewEdge: .left)
            scrollView.autoPinEdge(toSuperviewEdge: .right)
            scrollView.autoPinEdge(toSuperviewEdge: .bottom)
            
            logoImage.autoPinEdge(toSuperviewEdge: .top)
            logoImage.autoPinEdge(.left, to: .left, of: view, withOffset: 8)
            logoImage.autoPinEdge(.right, to: .right, of: view, withOffset: 8)
            logoImage.contentMode = .scaleAspectFit
            
            abstractTextField.autoPinEdge(.top, to: .bottom, of: logoImage, withOffset: 8)
            abstractTextField.autoPinEdge(.left, to: .left, of: view, withOffset: 0)
            abstractTextField.autoPinEdge(.right, to: .right, of: view, withOffset: 0)
            abstractTextField.autoPinEdge(.bottom, to: .bottom, of: scrollView, withOffset: 0)
            abstractTextField.isScrollEnabled = false
            
            backgroundView.autoPinEdge(.top, to: .bottom, of: logoImage, withOffset: 8)
            backgroundView.autoPinEdge(.bottom, to: .bottom, of: view)
            backgroundView.autoPinEdge(.left, to: .left, of: view)
            backgroundView.autoPinEdge(.right, to: .right, of: view)
            
            didUpdateConstraints = true
        }
        super.updateViewConstraints()
    }
    
    fileprivate func setSummaryText() {
        
        abstractTextField.backgroundColor = SIColor.prussianBlue()
        abstractTextField.text = ""
        abstractTextField.textColor = .white
        abstractTextField.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        recipient.getRecipientImage() { image in
            self.logoImage.image = image
        }
        
        if !recipient.summary.isEmpty {
            do {
                let attributedText = try NSMutableAttributedString(data: recipient.summary.data(using: String.Encoding.utf8)!,
                                                                          options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                                                            NSCharacterEncodingDocumentAttribute : String.Encoding.utf8.rawValue,
                                                                            NSForegroundColorAttributeName : UIColor.white],
                                                                          documentAttributes: nil)
                attributedText.addAttributes([NSFontAttributeName : UIFont.helveticaOfFontSize(16), NSForegroundColorAttributeName : UIColor.white], range: NSMakeRange(0, attributedText.string.characters.count - 1))
                
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
