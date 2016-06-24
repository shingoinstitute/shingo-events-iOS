//
//  ChallengerInfoViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/26/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class ChallengerInfoViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var abstractTextField: UITextView!
    var scrollView: UIScrollView = UIScrollView.newAutoLayoutView()
    var backgroundView = UIView.newAutoLayoutView()
    
    var recipient: SIRecipient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = recipient.name
        
        let shingoBlue = UIColor(netHex: 0x002f56)
        backgroundView.backgroundColor = shingoBlue
        abstractTextField.backgroundColor = shingoBlue
        
        logoImage.removeFromSuperview()
        abstractTextField.removeFromSuperview()
        
        view.addSubview(scrollView)
        view.addSubview(backgroundView)
        view.bringSubviewToFront(scrollView)
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
        
        abstractTextField.text = ""
        abstractTextField.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.automaticallyAdjustsScrollViewInsets = false
        logoImage.contentMode = UIViewContentMode.ScaleAspectFit
        if recipient.logoBookCoverImage != nil
        {
            logoImage.image = recipient.logoBookCoverImage
        }
        else
        {
            logoImage.image = UIImage(named: "logoComingSoon500x500")
            logoImage.layer.borderColor = UIColor.lightGrayColor().CGColor
            logoImage.layer.borderWidth = 1.0
            logoImage.layer.cornerRadius = 4.0
        }
        
        if recipient.richAbstract != nil {
            do {
                let htmlString: String! = "<style>body{color:white;}</style><font size=\"5\">" + recipient.richAbstract! + "</font></style>";
                abstractTextField.attributedText = try NSAttributedString(data: htmlString.dataUsingEncoding(NSUTF8StringEncoding)!,
                                                                      options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                                                                NSCharacterEncodingDocumentAttribute : NSUTF8StringEncoding],
                                                                      documentAttributes: nil)
            } catch {
                print("Error with richText in ChallengerInfoViewController")
            }
        } else {
            abstractTextField.text! = recipient.abstract
            abstractTextField.textColor = .whiteColor()
            abstractTextField.font = UIFont.systemFontOfSize(16)
        }
        
        

    }
    


}
