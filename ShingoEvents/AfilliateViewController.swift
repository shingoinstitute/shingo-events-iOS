//
//  AfilliateViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 2/1/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class AfilliateViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var abstractTextField: UITextView!
    var scrollView = UIScrollView.newAutoLayoutView()
    var backdrop = UIView.newAutoLayoutView()
    
    var affiliate: SIAffiliate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = affiliate.name
        let newline = "\n"
        let shingoBlue = UIColor(netHex: 0x002f56)
        
        view.backgroundColor = .whiteColor()
        
        logoImage.removeFromSuperview()
        abstractTextField.removeFromSuperview()
        view.addSubview(scrollView)
        view.addSubview(backdrop)
        view.bringSubviewToFront(scrollView)
        scrollView.addSubview(logoImage)
        scrollView.addSubview(abstractTextField)
        
        scrollView.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
        scrollView.autoPinEdgeToSuperviewEdge(.Left)
        scrollView.autoPinEdgeToSuperviewEdge(.Right)
        scrollView.autoPinEdgeToSuperviewEdge(.Bottom)
        
        logoImage.contentMode = .ScaleAspectFit
        logoImage.autoSetDimension(.Width, toSize: view.frame.width - 16)
        logoImage.autoPinEdge(.Top, toEdge: .Top, ofView: scrollView, withOffset: 8)
        logoImage.autoPinEdge(.Left, toEdge: .Left, ofView: view, withOffset: 8)
        
        abstractTextField.backgroundColor = shingoBlue
        abstractTextField.text = ""
        abstractTextField.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        abstractTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: logoImage, withOffset: 8)
        abstractTextField.autoPinEdge(.Left, toEdge: .Left, ofView: view)
        abstractTextField.autoPinEdge(.Right, toEdge: .Right, ofView: view)
        abstractTextField.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: scrollView)
        abstractTextField.editable = false
        abstractTextField.dataDetectorTypes = [UIDataDetectorTypes.Link, UIDataDetectorTypes.PhoneNumber]
        
        backdrop.autoPinEdge(.Top, toEdge: .Bottom, ofView: logoImage, withOffset: 8)
        backdrop.autoPinEdge(.Left, toEdge: .Left, ofView: view, withOffset: 0)
        backdrop.autoPinEdge(.Right, toEdge: .Right, ofView: view, withOffset: 0)
        backdrop.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: view, withOffset: 0)
        backdrop.backgroundColor = shingoBlue
        
        logoImage.image = affiliate.getLogoImage()
        logoImage.contentMode = .ScaleAspectFit
        
        let attrs = [NSFontAttributeName : UIFont.systemFontOfSize(16.0),
                     NSForegroundColorAttributeName : UIColor.whiteColor()]
        var richText = NSMutableAttributedString()
        abstractTextField.linkTextAttributes = [NSForegroundColorAttributeName : UIColor.cyanColor(),
                                                   NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue]
        do {
            let htmlString: String! = "<style>body{color:white;}</style><font size=\"5\">" + affiliate.summary + "</font></style>"
            richText = try NSMutableAttributedString(data: htmlString.dataUsingEncoding(NSUTF8StringEncoding)!,
                                                                         options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                                                            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding],
                                                                         documentAttributes: nil)
        } catch {
            print("Error with richText in affiliateViewController")
        }
        
        var plainText = String()
        if !affiliate.name.isEmpty {
            plainText = newline + newline + affiliate.name + newline
        } else {
            plainText = newline + newline + "Company name not available" + newline
        }
        
        richText.appendAttributedString(NSAttributedString(string: plainText, attributes: attrs))
        abstractTextField.attributedText = richText

        var frame:CGRect = abstractTextField.frame
        frame.size.height = abstractTextField.contentSize.height
        abstractTextField.frame = frame
        abstractTextField.scrollEnabled = false
    }





}
