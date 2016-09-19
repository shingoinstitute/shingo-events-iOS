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
    var scrollView = UIScrollView.newAutoLayout()
    var backdrop = UIView.newAutoLayout()
    
    var affiliate: SIAffiliate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = affiliate.name
        
        view.backgroundColor = .white
        
        logoImage.removeFromSuperview()
        abstractTextField.removeFromSuperview()
        view.addSubview(scrollView)
        view.addSubview(backdrop)
        view.bringSubview(toFront: scrollView)
        scrollView.addSubview(logoImage)
        scrollView.addSubview(abstractTextField)
        
        scrollView.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        scrollView.autoPinEdge(toSuperviewEdge: .left)
        scrollView.autoPinEdge(toSuperviewEdge: .right)
        scrollView.autoPinEdge(toSuperviewEdge: .bottom)
        
        logoImage.contentMode = .scaleAspectFit
        logoImage.autoSetDimension(.width, toSize: view.frame.width - 16)
        logoImage.autoPinEdge(.top, to: .top, of: scrollView, withOffset: 8)
        logoImage.autoPinEdge(.left, to: .left, of: view, withOffset: 8)
        
        abstractTextField.backgroundColor = SIColor.prussianBlueColor()
        abstractTextField.text = ""
        abstractTextField.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        abstractTextField.autoPinEdge(.top, to: .bottom, of: logoImage, withOffset: 8)
        abstractTextField.autoPinEdge(.left, to: .left, of: view)
        abstractTextField.autoPinEdge(.right, to: .right, of: view)
        abstractTextField.autoPinEdge(.bottom, to: .bottom, of: scrollView)
        abstractTextField.isEditable = false
        abstractTextField.dataDetectorTypes = [UIDataDetectorTypes.link, UIDataDetectorTypes.phoneNumber]
        
        backdrop.autoPinEdge(.top, to: .bottom, of: logoImage, withOffset: 8)
        backdrop.autoPinEdge(.left, to: .left, of: view, withOffset: 0)
        backdrop.autoPinEdge(.right, to: .right, of: view, withOffset: 0)
        backdrop.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: 0)
        backdrop.backgroundColor = SIColor.prussianBlueColor()
        
        affiliate.getLogoImage() { image in
            self.logoImage.image = image
        }
        
        logoImage.contentMode = .scaleAspectFit
  
        abstractTextField.linkTextAttributes = [NSForegroundColorAttributeName : UIColor.cyan,
                                                   NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
        do {
            
            let attrs = [NSFontAttributeName : UIFont.systemFont(ofSize: 16.0),
                         NSForegroundColorAttributeName : UIColor.white]
            
            let attributedText = try NSMutableAttributedString(data: affiliate.summary.data(using: String.Encoding.utf8)!,
                                                               options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                                                        NSCharacterEncodingDocumentAttribute : String.Encoding.utf8],
                                                                 documentAttributes: nil)
            attributedText.addAttributes(attrs, range: NSMakeRange(0, attributedText.string.characters.count))
        
            abstractTextField.attributedText = attributedText
        } catch {
            print("Error with richText in affiliateViewController")
        }

        var frame:CGRect = abstractTextField.frame
        frame.size.height = abstractTextField.contentSize.height
        abstractTextField.frame = frame
        abstractTextField.isScrollEnabled = false
    }





}
