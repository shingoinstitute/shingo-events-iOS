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
    @IBOutlet weak var abstractTextField: UITextView! {
        didSet {
            abstractTextField.backgroundColor = .shingoBlue
            abstractTextField.text = ""
            abstractTextField.textColor = .white
            abstractTextField.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
    }
    
    var scrollView: UIScrollView = UIScrollView.newAutoLayout()
    var backgroundView: UIView = {
        let view = UIView.newAutoLayout()
        view.backgroundColor = .shingoBlue
        return view
    }()
    
    var recipient: SIRecipient!
    
    var didUpdateConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChallengerInfoViewController.adjustFontForCategorySizeChange), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
        
        navigationItem.title = recipient.name
        automaticallyAdjustsScrollViewInsets = false
        
        recipient.getRecipientImage() { image in self.logoImage.image = image }
        
        let abstract = NSMutableAttributedString(attributedString: recipient.attributedSummary)
        
        let attributes = [
            NSFontAttributeName : UIFont.preferredFont(forTextStyle: .body),
            NSForegroundColorAttributeName : UIColor.white
        ]
        
        abstract.addAttributes(attributes, range: abstract.fullRange)
        
        abstractTextField.attributedText = abstract
        

        updateViewConstraints()
    }
    
    func adjustFontForCategorySizeChange() {
        abstractTextField.font = UIFont.preferredFont(forTextStyle: .body)
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

}
