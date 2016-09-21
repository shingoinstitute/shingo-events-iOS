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
            aboutTextField.textColor = UIColor.white
            aboutTextField.backgroundColor = SIColor.prussianBlue()
            aboutTextField.isScrollEnabled = false
            
            aboutTextField.layer.cornerRadius = 3
            
            aboutTextField.layer.shadowColor = UIColor.black.cgColor
            aboutTextField.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            aboutTextField.layer.shadowOpacity = 1
            aboutTextField.layer.shadowRadius = 3
            aboutTextField.layer.masksToBounds = false
            aboutTextField.layer.cornerRadius = 3
        }
    }
    
    var scrollView = UIScrollView.newAutoLayout() {
        didSet {
            scrollView.backgroundColor = .clear
        }
    }
    
    var shigeoImageView: UIImageView = {
        let view = UIImageView.newAutoLayout()
        view.image = UIImage(named: "shigeoGrad")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 3
        
        return view
    }()
    
    var shigeoNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Shigeo Shingo, 1909-1990"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    var didSetupConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        let attributesCentered = [
            NSFontAttributeName : UIFont.preferredFont(forTextStyle: .body),
            NSParagraphStyleAttributeName : SIParagraphStyle.center,
            NSForegroundColorAttributeName : UIColor.white
        ]
        
        let boldAttributesCentered = [
            NSFontAttributeName : UIFont.preferredFont(forTextStyle: .headline),
            NSParagraphStyleAttributeName : SIParagraphStyle.center,
            NSForegroundColorAttributeName : UIColor.white
        ]
        
        let attributesJustified = [
            NSFontAttributeName : UIFont.preferredFont(forTextStyle: .body),
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
        
        aboutText.append(NSAttributedString(string: "Our Namesake\n\n", attributes: boldAttributesJustified))
        aboutText.append(NSAttributedString(string: "Few individuals have contributed as much to the development of the ideas we call TQM, JIT and lean as did Shigeo Shingo. Over the course of his life, Dr. Shingo wrote and published 18 books, eight of which were translated from Japanese into English. Many years before they became popular in the Western world, Dr. Shingo wrote about the ideas of ensuring quality at the source, flowing value to customers, working with zero inventories, rapidly setting up machines through the system of “single-minute exchange of dies” (SMED) and going to the actual workplace to grasp the true situation there (“going to gemba”). He worked extensively with Toyota executives, especially Mr. Taiichi Ohno, who helped him to apply his understanding of these concepts in the real world.\n\n", attributes: attributesJustified))
        aboutText.append(NSAttributedString(string: "Always on the leading edge of new ideas, Dr. Shingo envisioned a collaboration with an organization that would further his life’s work through research, practical-yet-rigorous education and a program for recognizing the best in enterprise excellence throughout the world. In 1988, Shingo received his honorary Doctorate of Management from Utah State University and, later that year, his ambitions were realized when the Shingo Prize was organized and incorporated as part of the university. While the Shingo Prize remains an integral part of what we do, our scope has expanded to include various educational offerings, a focus on research and a growing international network of Shingo Institute Licensed Affiliates.", attributes: attributesJustified))
        
        aboutTextField.attributedText = aboutText
     
        updateViewConstraints()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        aboutTextField.setContentOffset(CGPoint.zero, animated: false)
    }

    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            view.addSubview(scrollView)
            aboutTextField.removeFromSuperview()
            scrollView.addSubviews([shigeoImageView, aboutTextField, shigeoNameLabel])
            
            scrollView.autoPinEdgesToSuperviewEdges()
            
            aboutTextField.autoPinEdge(.top, to: .top, of: scrollView, withOffset: 8)
            aboutTextField.autoPinEdge(.left, to: .left, of: view, withOffset: 8)
            aboutTextField.autoPinEdge(.right, to: .right, of: view, withOffset: -8)
            
            shigeoImageView.autoPinEdge(.top, to: .bottom, of: aboutTextField, withOffset: 16)
            shigeoImageView.autoPinEdge(.left, to: .left, of: view, withOffset: 8)
            shigeoImageView.autoPinEdge(.right, to: .right, of: view, withOffset: -8)
            
            shigeoNameLabel.autoPinEdge(.top, to: .bottom, of: shigeoImageView, withOffset: 8)
            shigeoNameLabel.autoPinEdge(.left, to: .left, of: view, withOffset: 8)
            shigeoNameLabel.autoPinEdge(.right, to: .right, of: view, withOffset: -8)
            shigeoNameLabel.autoPinEdge(.bottom, to: .bottom, of: scrollView, withOffset: -8)
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
}










