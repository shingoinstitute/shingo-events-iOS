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
        
        abstractTextField.backgroundColor = SIColor.prussianBlueColor()
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
        backdrop.backgroundColor = SIColor.prussianBlueColor()
        
        affiliate.getLogoImage() { image in
            self.logoImage.image = image
        }
        
        logoImage.contentMode = .ScaleAspectFit
  
        abstractTextField.linkTextAttributes = [NSForegroundColorAttributeName : UIColor.cyanColor(),
                                                   NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue]
        do {
            
            let attrs = [NSFontAttributeName : UIFont.systemFontOfSize(16.0),
                         NSForegroundColorAttributeName : UIColor.whiteColor()]
            
            let attributedText = try NSMutableAttributedString(data: affiliate.summary.dataUsingEncoding(NSUTF8StringEncoding)!,
                                                               options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                                                        NSCharacterEncodingDocumentAttribute : NSUTF8StringEncoding],
                                                                 documentAttributes: nil)
            attributedText.addAttributes(attrs, range: NSMakeRange(0, attributedText.string.characters.count))
        
            abstractTextField.attributedText = attributedText
        } catch {
            print("Error with richText in affiliateViewController")
        }

        var frame:CGRect = abstractTextField.frame
        frame.size.height = abstractTextField.contentSize.height
        abstractTextField.frame = frame
        abstractTextField.scrollEnabled = false
    }





}
