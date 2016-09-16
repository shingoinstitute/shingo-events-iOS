//
//  AboutPageViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/10/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class AboutPageViewController: UIViewController {

    @IBOutlet weak var aboutTextField: UITextView! {
        didSet {
            aboutTextField.textColor = UIColor.whiteColor()
            aboutTextField.backgroundColor = SIColor.prussianBlueColor()
            aboutTextField.scrollEnabled = false
            
            aboutTextField.layer.cornerRadius = 3
            
            aboutTextField.layer.shadowColor = UIColor.blackColor().CGColor
            aboutTextField.layer.shadowOffset = CGSizeMake(0, 2.0)
            aboutTextField.layer.shadowOpacity = 1
            aboutTextField.layer.shadowRadius = 3
            aboutTextField.layer.masksToBounds = false
            aboutTextField.layer.cornerRadius = 3
        }
    }
    
    var scrollView = UIScrollView.newAutoLayoutView() {
        didSet {
            scrollView.backgroundColor = .clearColor()
        }
    }
    
    var shigeoImageView: UIImageView = {
        let view = UIImageView.newAutoLayoutView()
        view.image = UIImage(named: "shigeoGrad")
        view.clipsToBounds = true
        view.contentMode = .ScaleAspectFill
        view.layer.cornerRadius = 3
        
        return view
    }()
    
    var shigeoNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Shigeo Shingo, 1909-1990"
        label.textAlignment = .Center
        label.textColor = .blackColor()
        return label
    }()
    
    var didSetupConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        let centeredStyle = NSMutableParagraphStyle()
        centeredStyle.alignment = .Center
        
        let justifiedStyle = NSMutableParagraphStyle()
        justifiedStyle.alignment = .Justified
        
        let attributesCentered = [
            NSFontAttributeName : UIFont.helveticaOfFontSize(15),
            NSParagraphStyleAttributeName : centeredStyle,
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        
        let boldAttributesCentered = [
            NSFontAttributeName : UIFont.boldHelveticaOfFontSize(15),
            NSParagraphStyleAttributeName : centeredStyle,
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        
        let attributesJustified = [
            NSFontAttributeName : UIFont.helveticaOfFontSize(15),
            NSParagraphStyleAttributeName : justifiedStyle,
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        
        let boldAttributesJustified = [
            NSFontAttributeName : UIFont.boldHelveticaOfFontSize(15),
            NSParagraphStyleAttributeName : justifiedStyle,
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        
        let aboutText = NSMutableAttributedString(string: "Our Purpose:\n\n", attributes: boldAttributesCentered)
        aboutText.appendAttributedString(NSAttributedString(string: "Based on timeless principles, we shape cultures that drive operational excellence.\n\n", attributes: attributesCentered))
        aboutText.appendAttributedString(NSAttributedString(string: "Our Mission:\n\n", attributes: boldAttributesCentered))
        aboutText.appendAttributedString(NSAttributedString(string: "We conduct cutting edge research, provide relevant education, perform insightful enterprise assessment, and recognize organizations committed to achieving sustainable world-class results.\n\n", attributes: attributesCentered))
        
        aboutText.appendAttributedString(NSAttributedString(string: "Our Namesake\n\n", attributes: boldAttributesJustified))
        aboutText.appendAttributedString(NSAttributedString(string: "Few individuals have contributed as much to the development of the ideas we call TQM, JIT and lean as did Shigeo Shingo. Over the course of his life, Dr. Shingo wrote and published 18 books, eight of which were translated from Japanese into English. Many years before they became popular in the Western world, Dr. Shingo wrote about the ideas of ensuring quality at the source, flowing value to customers, working with zero inventories, rapidly setting up machines through the system of “single-minute exchange of dies” (SMED) and going to the actual workplace to grasp the true situation there (“going to gemba”). He worked extensively with Toyota executives, especially Mr. Taiichi Ohno, who helped him to apply his understanding of these concepts in the real world.\n\n", attributes: attributesJustified))
        aboutText.appendAttributedString(NSAttributedString(string: "Always on the leading edge of new ideas, Dr. Shingo envisioned a collaboration with an organization that would further his life’s work through research, practical-yet-rigorous education and a program for recognizing the best in enterprise excellence throughout the world. In 1988, Shingo received his honorary Doctorate of Management from Utah State University and, later that year, his ambitions were realized when the Shingo Prize was organized and incorporated as part of the university. While the Shingo Prize remains an integral part of what we do, our scope has expanded to include various educational offerings, a focus on research and a growing international network of Shingo Institute Licensed Affiliates.", attributes: attributesJustified))
        
        aboutTextField.attributedText = aboutText
     
        updateViewConstraints()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        aboutTextField.setContentOffset(CGPointZero, animated: false)
    }

    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            view.addSubview(scrollView)
            aboutTextField.removeFromSuperview()
            scrollView.addSubviews([shigeoImageView, aboutTextField, shigeoNameLabel])
            
            scrollView.autoPinEdgesToSuperviewEdges()
            
            aboutTextField.autoPinEdge(.Top, toEdge: .Top, ofView: scrollView, withOffset: 8)
            aboutTextField.autoPinEdge(.Left, toEdge: .Left, ofView: view, withOffset: 8)
            aboutTextField.autoPinEdge(.Right, toEdge: .Right, ofView: view, withOffset: -8)
            
            shigeoImageView.autoPinEdge(.Top, toEdge: .Bottom, ofView: aboutTextField, withOffset: 16)
            shigeoImageView.autoPinEdge(.Left, toEdge: .Left, ofView: view, withOffset: 8)
            shigeoImageView.autoPinEdge(.Right, toEdge: .Right, ofView: view, withOffset: -8)
            
            shigeoNameLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: shigeoImageView, withOffset: 8)
            shigeoNameLabel.autoPinEdge(.Left, toEdge: .Left, ofView: view, withOffset: 8)
            shigeoNameLabel.autoPinEdge(.Right, toEdge: .Right, ofView: view, withOffset: -8)
            shigeoNameLabel.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: scrollView, withOffset: -8)
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
}










