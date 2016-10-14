//
//  AboutPageViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/10/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class AboutPageViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var aboutTextField: UITextView!
    @IBOutlet weak var shigeoImageView: UIImageView! { didSet { shigeoImageView.layer.cornerRadius = 3 } }
    @IBOutlet weak var shigeoNameLabel: UILabel!
    
    var didUpdateViewConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightShingoBlue
        let gradientLayer = RadialGradientLayer()
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        aboutTextField.attributedText = getAboutText()
        
        updateViewConstraints()
        
    }

    override func updateViewConstraints() {
        if !didUpdateViewConstraints {
            
            aboutTextField.autoPinEdge(.top, to: .top, of: contentView, withOffset: 8)
            aboutTextField.autoPinEdge(.left, to: .left, of: contentView, withOffset: 8)
            aboutTextField.autoPinEdge(.right, to: .right, of: contentView, withOffset: -8)
            
            shigeoNameLabel.autoPinEdge(.top, to: .bottom, of: aboutTextField, withOffset: 8)
            shigeoNameLabel.autoPinEdge(.left, to: .left, of: contentView, withOffset: 8)
            shigeoNameLabel.autoPinEdge(.right, to: .right, of: contentView, withOffset: -8)
            
            shigeoImageView.autoSetDimension(.height, toSize: 160)
            shigeoImageView.autoPinEdge(.top, to: .bottom, of: shigeoNameLabel, withOffset: 8)
            shigeoImageView.autoPinEdge(.left, to: .left, of: contentView, withOffset: 8)
            shigeoImageView.autoPinEdge(.right, to: .right, of: contentView, withOffset: -8)
            shigeoImageView.autoPinEdge(.bottom, to: .bottom, of: contentView, withOffset: -8)
            
            scrollView.frame = view.frame
            let size = contentView.sizeThatFits(CGSize(width: view.frame.width - 16, height: CGFloat.greatestFiniteMagnitude))
            contentView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            scrollView.bounds = contentView.frame
            
            didUpdateViewConstraints = true
        }
        
        super.updateViewConstraints()
        
    }
    
    func getAboutText() -> NSAttributedString {
        let attributesCentered = [
            NSFontAttributeName : UIFont.systemFont(ofSize: 15),
            NSParagraphStyleAttributeName : SIParagraphStyle.center,
            NSForegroundColorAttributeName : UIColor.white
        ]
        
        let boldAttributesCentered = [
            NSFontAttributeName : UIFont.preferredFont(forTextStyle: .headline),
            NSParagraphStyleAttributeName : SIParagraphStyle.center,
            NSForegroundColorAttributeName : UIColor.white
        ]
        
        let attributesJustified = [
            NSFontAttributeName : UIFont.systemFont(ofSize: 15),
            NSParagraphStyleAttributeName : SIParagraphStyle.justified,
            NSForegroundColorAttributeName : UIColor.white
        ]
        
        let boldAttributesJustified = [
            NSFontAttributeName : UIFont.preferredFont(forTextStyle: .headline),
            NSParagraphStyleAttributeName : SIParagraphStyle.justified,
            NSForegroundColorAttributeName : UIColor.white
        ]
        
        let aboutText = NSMutableAttributedString(string: "Our Purpose:\n\n", attributes: boldAttributesCentered)
        aboutText.append(NSAttributedString(string: "Based on timeless principles, we shape cultures that drive operational excellence.\n\n", attributes: attributesCentered))
        aboutText.append(NSAttributedString(string: "Our Mission:\n\n", attributes: boldAttributesCentered))
        aboutText.append(NSAttributedString(string: "We conduct cutting edge research, provide relevant education, perform insightful enterprise assessment, and recognize organizations committed to achieving sustainable world-class results.\n\n", attributes: attributesCentered))
        
        aboutText.append(NSAttributedString(string: "Our Namesake:\n", attributes: boldAttributesJustified))
        aboutText.append(NSAttributedString(string: "Few individuals have contributed as much to the development of the ideas we call TQM, JIT and lean as did Shigeo Shingo. Over the course of his life, Dr. Shingo wrote and published 18 books, eight of which were translated from Japanese into English. Many years before they became popular in the Western world, Dr. Shingo wrote about the ideas of ensuring quality at the source, flowing value to customers, working with zero inventories, rapidly setting up machines through the system of “single-minute exchange of dies” (SMED) and going to the actual workplace to grasp the true situation there (“going to gemba”). He worked extensively with Toyota executives, especially Mr. Taiichi Ohno, who helped him to apply his understanding of these concepts in the real world.\n\n", attributes: attributesJustified))
        aboutText.append(NSAttributedString(string: "Always on the leading edge of new ideas, Dr. Shingo envisioned a collaboration with an organization that would further his life’s work through research, practical-yet-rigorous education and a program for recognizing the best in enterprise excellence throughout the world. In 1988, Shingo received his honorary Doctorate of Management from Utah State University and, later that year, his ambitions were realized when the Shingo Prize was organized and incorporated as part of the university. While the Shingo Prize remains an integral part of what we do, our scope has expanded to include various educational offerings, a focus on research and a growing international network of Shingo Institute Licensed Affiliates.", attributes: attributesJustified))
        
        return aboutText
    }
    
}










