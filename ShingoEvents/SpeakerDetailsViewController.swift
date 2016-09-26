//
//  SpeakerDetailsViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/22/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import PureLayout

class SpeakerDetailsViewController: UIViewController {

    var speakerNameLabel: UILabel!
    var organizationLabel: UILabel!
    var biographyTextView: UITextView!
    var speakerImageView: UIImageView!
    
    var speaker: SISpeaker!
    var didSetupConstraints = false
    var scrollView: UIScrollView!
    
    override func loadView() {
        view = UIView()
        scrollView = UIScrollView.newAutoLayout()
        
        view.backgroundColor = SIColor.shingoBlue
        view.addSubview(scrollView)
        
        scrollView.backgroundColor = SIColor.shingoBlue
        
        // Set correct text for speaker label
        if !speaker.name.isEmpty {
            
            speakerNameLabel = UILabel.newAutoLayout()
            speakerNameLabel.text = ""
            speakerNameLabel.textColor = .white
            speakerNameLabel.numberOfLines = 0
            speakerNameLabel.lineBreakMode = .byWordWrapping
            speakerNameLabel.text = speaker.name
            
            if !speaker.title.isEmpty && !speaker.name.isEmpty {
                speakerNameLabel.text! += ", \(speaker.title)"
            }
        } else {
            speakerNameLabel.text = "Name not available"
        }
        
        scrollView.addSubview(speakerNameLabel)
        
        if !speaker.organizationName.isEmpty {
            organizationLabel = UILabel.newAutoLayout()
            
            organizationLabel.text = "From " + speaker.organizationName
            organizationLabel.numberOfLines = 0
            organizationLabel.textColor = .white
            organizationLabel.lineBreakMode = .byWordWrapping
            
            scrollView.addSubview(organizationLabel)
        }

        if !speaker.attributedBiography.string.isEmpty {
            biographyTextView = UITextView.newAutoLayout()
        
            biographyTextView.attributedText = speaker.attributedBiography
        
            biographyTextView.isEditable = false
            biographyTextView.backgroundColor = .white
            biographyTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            biographyTextView.frame = CGRect(x: 0, y: 0, width: biographyTextView.frame.width, height: biographyTextView.contentSize.height)
            biographyTextView.isScrollEnabled = false
            
            scrollView.addSubview(biographyTextView)
        }
        
        speakerImageView = UIImageView.newAutoLayout()
        speaker.getSpeakerImage() { image in
            self.speakerImageView.image = image
        }
        
        speakerImageView.contentMode = UIViewContentMode.scaleAspectFit
        speakerImageView.layer.borderColor = UIColor.clear.cgColor
        speakerImageView.layer.cornerRadius = 5.0
        speakerImageView.layer.borderWidth = 1
        speakerImageView.clipsToBounds = true
        speakerImageView.backgroundColor = .white
        scrollView.addSubview(speakerImageView)
        
        setScrollViewContentHeight()
        
        view.setNeedsUpdateConstraints()
    }

    override func updateViewConstraints() {
        if !didSetupConstraints {
            
            scrollView.autoPinEdgesToSuperviewEdges()
            
            speakerImageView.autoSetDimension(.width, toSize: 200)
            speakerImageView.autoSetDimension(.height, toSize: 200)
            
            speakerImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 10.0)
            speakerImageView.autoPinEdge(toSuperviewEdge: .left, withInset: 10.0)
            
            var previousView: UIView!
            previousView = speakerImageView
            
            if speakerNameLabel != nil {
                speakerNameLabel.autoPinEdge(.top, to: .bottom, of: previousView, withOffset: 8)
                speakerNameLabel.autoPinEdge(.left, to: .left, of: view, withOffset: 8)
                speakerNameLabel.autoPinEdge(.right, to: .right, of: view, withOffset: 8)
                previousView = speakerNameLabel
            }

            if organizationLabel != nil {
                organizationLabel.autoPinEdge(.top, to: .bottom, of: previousView, withOffset: 8)
                organizationLabel.autoPinEdge(.left, to: .left, of: view, withOffset: 8)
                organizationLabel.autoPinEdge(.right, to: .right, of: view, withOffset: 8)
                previousView = organizationLabel
            }
            
            if biographyTextView != nil {
                biographyTextView.autoPinEdge(.top, to: .bottom, of: previousView, withOffset: 8)
                biographyTextView.autoPinEdge(.left, to: .left, of: view)
                biographyTextView.autoPinEdge(.right, to: .right, of: view)
                biographyTextView.autoPinEdge(.bottom, to: .bottom, of: scrollView)
            }
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }

    func setScrollViewContentHeight()
    {
        var height:CGFloat = 0.0
        
        let insets:CGFloat = 10.0
        
        if speakerNameLabel != nil {
            height += speakerNameLabel.frame.height
        }
        if organizationLabel != nil {
            height += organizationLabel.frame.height
        }
        if speakerImageView != nil {
            height += speakerImageView.frame.height
        }
        if biographyTextView != nil {
            height += biographyTextView.frame.height
        }

        height += insets

        scrollView.contentSize = CGSize(width: self.view.frame.width, height: height)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
}














