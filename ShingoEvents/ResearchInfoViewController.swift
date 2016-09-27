//
//  ResearchInfoViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/26/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class ResearchInfoViewController: UIViewController {

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var abstractTextField: UITextView!
    var scrollView: UIScrollView = UIScrollView.newAutoLayout()
    var backdrop = UIView.newAutoLayout()
    
    var recipient: SIRecipient!
    
    var didUpdateConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipient.getRecipientImage() { image in self.bookImage.image = image }
        
        navigationItem.title = recipient.name
        
        NotificationCenter.default.addObserver(self, selector: #selector(ResearchInfoViewController.adjustFontForCategorySizeChange), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
        
        bookImage.removeFromSuperview()
        abstractTextField.removeFromSuperview()
        view.addSubview(scrollView)
        view.addSubview(backdrop)
        scrollView.addSubview(bookImage)
        scrollView.addSubview(abstractTextField)
        
        automaticallyAdjustsScrollViewInsets = false

        let summary = NSMutableAttributedString(attributedString: recipient.attributedSummary)
        
        let attributes = [
            NSFontAttributeName : UIFont.preferredFont(forTextStyle: .body),
            NSForegroundColorAttributeName : UIColor.white
        ]
        
        summary.addAttributes(attributes, range: summary.fullRange)
        
        abstractTextField.attributedText = summary
        
        updateViewConstraints()
    }
    
    func adjustFontForCategorySizeChange() {
        abstractTextField.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    override func updateViewConstraints() {
        if !didUpdateConstraints {
            
            scrollView.autoPin(toTopLayoutGuideOf: self, withInset: 0)
            scrollView.autoPinEdge(toSuperviewEdge: .left)
            scrollView.autoPinEdge(toSuperviewEdge: .right)
            scrollView.autoPinEdge(toSuperviewEdge: .bottom)
            
            bookImage.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
            bookImage.autoPinEdge(toSuperviewEdge: .left, withInset: 8)
            bookImage.autoPinEdge(toSuperviewEdge: .right, withInset:  8)
            bookImage.contentMode = .scaleAspectFit
            
            abstractTextField.autoPinEdge(.top, to: .bottom, of: bookImage, withOffset: 8)
            abstractTextField.autoPinEdge(.left, to: .left, of: view, withOffset: 0)
            abstractTextField.autoPinEdge(.right, to: .right, of: view, withOffset: 0)
            abstractTextField.autoPinEdge(.bottom, to: .bottom, of: scrollView, withOffset: 0)
            abstractTextField.isScrollEnabled = false
            abstractTextField.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            abstractTextField.backgroundColor = .shingoBlue
            
            view.bringSubview(toFront: scrollView)
            backdrop.autoPinEdge(.top, to: .bottom, of: bookImage, withOffset: 8)
            backdrop.autoPinEdge(toSuperviewEdge: .left)
            backdrop.autoPinEdge(toSuperviewEdge: .right)
            backdrop.autoPinEdge(toSuperviewEdge: .bottom)
            backdrop.backgroundColor = .shingoBlue
            
            didUpdateConstraints = true
        }
        super.updateViewConstraints()
    }
    

}
