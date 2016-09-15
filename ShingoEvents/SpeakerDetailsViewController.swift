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
        scrollView = UIScrollView.newAutoLayoutView()
        
        view.backgroundColor = SIColor.shingoBlueColor()
        view.addSubview(scrollView)
        
        scrollView.backgroundColor = SIColor.shingoBlueColor()
        
        // Set correct text for speaker label
        if !speaker.name.isEmpty {
            
            speakerNameLabel = UILabel.newAutoLayoutView()
            speakerNameLabel.text = ""
            speakerNameLabel.textColor = .whiteColor()
            speakerNameLabel.numberOfLines = 0
            speakerNameLabel.lineBreakMode = .ByWordWrapping
            speakerNameLabel.text = speaker.name
            
            if !speaker.title.isEmpty && !speaker.name.isEmpty {
                speakerNameLabel.text! += ", \(speaker.title)"
            }
        } else {
            speakerNameLabel.text = "Name not available"
        }
        
        scrollView.addSubview(speakerNameLabel)
        
        if !speaker.organizationName.isEmpty {
            organizationLabel = UILabel.newAutoLayoutView()
            
            organizationLabel.text = "From " + speaker.organizationName
            organizationLabel.numberOfLines = 0
            organizationLabel.textColor = .whiteColor()
            organizationLabel.lineBreakMode = .ByWordWrapping
            
            scrollView.addSubview(organizationLabel)
        }

        if !speaker.biography.isEmpty {
            biographyTextView = UITextView.newAutoLayoutView()
        
            var htmlString = speaker.biography
            do {
                htmlString = "<font size=\"5\">" + htmlString + "</font>"
                let attributedText = try NSMutableAttributedString(data: htmlString.dataUsingEncoding(NSUTF8StringEncoding)!,
                                                        options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                                            NSCharacterEncodingDocumentAttribute : NSUTF8StringEncoding],
                                                        documentAttributes: nil)
                biographyTextView.attributedText = attributedText
                
            } catch {
                print("Error in SpeakerDetailsViewController")
            }
        
            biographyTextView.editable = false
            biographyTextView.backgroundColor = .whiteColor()
            biographyTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            biographyTextView.frame = CGRect(x: 0, y: 0, width: biographyTextView.frame.width, height: biographyTextView.contentSize.height)
            biographyTextView.scrollEnabled = false
            
            scrollView.addSubview(biographyTextView)
        }
        
        speakerImageView = UIImageView.newAutoLayoutView()
        speaker.getSpeakerImage() { image in
            self.speakerImageView.image = image
        }
        speakerImageView.contentMode = UIViewContentMode.ScaleAspectFit
        speakerImageView.layer.borderColor = UIColor.clearColor().CGColor
        speakerImageView.layer.cornerRadius = 5.0
        speakerImageView.layer.borderWidth = 1
        speakerImageView.clipsToBounds = true
        speakerImageView.backgroundColor = .whiteColor()
        scrollView.addSubview(speakerImageView)
        
        setScrollViewContentHeight()
        
        view.setNeedsUpdateConstraints()
    }

    override func updateViewConstraints() {
        if !didSetupConstraints
        {
            
//            if speakerNameLabel != nil {
//                speakerNameLabel.autoSetDimensionsToSize(CGSize(width: self.view.frame.width - 10, height: 42.0))
//                speakerNameLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: speakerImageView, withOffset: 8)
//                speakerNameLabel.autoPinEdge(.Left, toEdge: .Left, ofView: view, withOffset: 8)
//                speakerNameLabel.autoPinEdge(.Right, toEdge: .Right, ofView: view, withOffset: 8)
//            }
//            if organizationLabel != nil {
//                organizationLabel.autoSetDimensionsToSize(CGSize(width: self.view.frame.width - 10, height: 42.0))
//                organizationLabel.autoPinEdge(<#T##edge: ALEdge##ALEdge#>, toEdge: <#T##ALEdge#>, ofView: <#T##UIView#>, withOffset: <#T##CGFloat#>)
//            }
//            if biographyTextView != nil {
//                biographyTextView.autoSetDimension(.Width, toSize: self.view.frame.width)
//            }

            scrollView.autoPinEdgesToSuperviewEdges()
            
            speakerImageView.autoSetDimension(.Width, toSize: 200)
            speakerImageView.autoSetDimension(.Height, toSize: 200)
            
            speakerImageView.autoPinEdgeToSuperviewEdge(.Top, withInset: 10.0)
            speakerImageView.autoPinEdgeToSuperviewEdge(.Left, withInset: 10.0)
            
            var previousView: UIView!
            previousView = speakerImageView
            
            if speakerNameLabel != nil {
                speakerNameLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: previousView, withOffset: 8)
                speakerNameLabel.autoPinEdge(.Left, toEdge: .Left, ofView: view, withOffset: 8)
                speakerNameLabel.autoPinEdge(.Right, toEdge: .Right, ofView: view, withOffset: 8)
                previousView = speakerNameLabel
            }

            if organizationLabel != nil {
                organizationLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: previousView, withOffset: 8)
                organizationLabel.autoPinEdge(.Left, toEdge: .Left, ofView: view, withOffset: 8)
                organizationLabel.autoPinEdge(.Right, toEdge: .Right, ofView: view, withOffset: 8)
                previousView = organizationLabel
            }
            
            if biographyTextView != nil {
                biographyTextView.autoPinEdge(.Top, toEdge: .Bottom, ofView: previousView, withOffset: 8)
                biographyTextView.autoPinEdge(.Left, toEdge: .Left, ofView: view)
                biographyTextView.autoPinEdge(.Right, toEdge: .Right, ofView: view)
                biographyTextView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: scrollView)
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














