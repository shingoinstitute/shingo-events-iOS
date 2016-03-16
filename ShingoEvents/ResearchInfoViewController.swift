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
//    @IBOutlet weak var scrollView: UIScrollView!
    
    var recipient:Recipient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false

        if recipient.logo_book_cover_image != nil {
             bookImage.image = recipient.logo_book_cover_image
        } else {
            bookImage.image = UIImage(named: "shingo_icon")
        }
        
        abstractTextField.text = ""
        if recipient.authors != nil && recipient.name != nil{
            if (recipient.authors.rangeOfString("&") != nil) {
                abstractTextField.text = "Presenting the authors of \"" + recipient.name + "\", " + recipient.authors + ", recipients of the Research Award.\n\n"
            } else {
                abstractTextField.text = "Presenting the author of \"" + recipient.name + "\", " + recipient.authors + ", recipient of the Research Award.\n\n"
            }
        } else {
            if recipient.authors != nil {
                if recipient.authors.rangeOfString(",") != nil {
                    abstractTextField.text! += "Presenting " + recipient.authors + ", recipients of the Research Award.\n\n"
                } else {
                    abstractTextField.text! += "Presenting " + recipient.authors + ", recipient of the Research Award.\n\n"
                }
            }
            
            if recipient.name != nil {
                abstractTextField.text! += "Presenting the book \"" + recipient.name + "\", for being rewarded the Research Award.\n\n"
            }
        }
        
        if recipient.abstract != nil {
            abstractTextField.text! += recipient.abstract
        } else {
            abstractTextField.text! += "Book description coming soon."
        }

        

        
//        var frame:CGRect = abstractTextField.frame
//        frame.size.height = abstractTextField.contentSize.height
//        abstractTextField.frame = frame
//        abstractTextField.scrollEnabled = false
//        calculateScrollViewContent()
    }
    
//    func calculateScrollViewContent() {
//        var height:CGFloat = 0
//        let uiOffset:CGFloat = 8.0
//        
//        abstractTextField.sizeToFit()
//        abstractTextField.layoutIfNeeded()
//        
//        height += bookImage.frame.height
//        height += abstractTextField.contentSize.height
//        height += (uiOffset * 3.0)
//        
//        scrollView.contentSize = CGSize(width: view.frame.width, height: height)
//        
//    }

}
