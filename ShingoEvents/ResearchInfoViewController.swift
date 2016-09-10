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
    var scrollView: UIScrollView = UIScrollView.newAutoLayoutView()
    var backdrop = UIView.newAutoLayoutView()
    
    var recipient: SIRecipient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = recipient.name
        
        bookImage.removeFromSuperview()
        abstractTextField.removeFromSuperview()
        view.addSubview(scrollView)
        view.addSubview(backdrop)
        scrollView.addSubview(bookImage)
        scrollView.addSubview(abstractTextField)
        
        scrollView.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
        scrollView.autoPinEdgeToSuperviewEdge(.Left)
        scrollView.autoPinEdgeToSuperviewEdge(.Right)
        scrollView.autoPinEdgeToSuperviewEdge(.Bottom)
        
        bookImage.autoPinEdgeToSuperviewEdge(.Top, withInset: 8)
        bookImage.autoPinEdgeToSuperviewEdge(.Left, withInset: 8)
        bookImage.autoPinEdgeToSuperviewEdge(.Right, withInset:  8)
        bookImage.contentMode = .ScaleAspectFit
        
        abstractTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: bookImage, withOffset: 8)
        abstractTextField.autoPinEdge(.Left, toEdge: .Left, ofView: view, withOffset: 0)
        abstractTextField.autoPinEdge(.Right, toEdge: .Right, ofView: view, withOffset: 0)
        abstractTextField.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: scrollView, withOffset: 0)
        abstractTextField.scrollEnabled = false
        abstractTextField.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        abstractTextField.backgroundColor = SIColor.shingoBlueColor()
        
        view.bringSubviewToFront(scrollView)
        backdrop.autoPinEdge(.Top, toEdge: .Bottom, ofView: bookImage, withOffset: 8)
        backdrop.autoPinEdgeToSuperviewEdge(.Left)
        backdrop.autoPinEdgeToSuperviewEdge(.Right)
        backdrop.autoPinEdgeToSuperviewEdge(.Bottom)
        backdrop.backgroundColor = SIColor.shingoBlueColor()
        
        automaticallyAdjustsScrollViewInsets = false

        recipient.getRecipientImage() { image in
            self.bookImage.image = image
        }
        
        abstractTextField.text = ""
        
        if !recipient.summary.isEmpty {
            
            do {
                let htmlString: String! = "<style>body{color:white;}</style><font size=\"5\">" + recipient.summary + "</font></style>";
                abstractTextField.attributedText = try NSAttributedString(data: htmlString.dataUsingEncoding(NSUTF8StringEncoding)!,
                                                                      options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                                                                NSCharacterEncodingDocumentAttribute : NSUTF8StringEncoding],
                                                                      documentAttributes: nil)
            } catch {
                print("Error with richText in ResearchInfoViewController")
            }
            
        }
        
    }
    

}
