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
    var speakerTitleLabel: UILabel!
    var organizationLabel: UILabel!
    var biographyView: UITextView!
    var speakerImageView: UIImageView!
    
    var speaker:Speaker!
    var didSetupConstraints = false
    var scrollView: UIScrollView!
    override func loadView()
    {
        view = UIView()
//        view.backgroundColor = .whiteColor()
        view.backgroundColor = UIColor(netHex: 0x002f56)
        scrollView = UIScrollView.newAutoLayoutView()
        view.addSubview(scrollView)
        if speaker != nil {
            speakerNameLabel = UILabel.newAutoLayoutView()
            if speaker.display_name != nil && speaker.title != nil {
                speakerNameLabel.text = speaker.display_name + ", " + speaker.title
            }
            else if speaker.display_name != nil
            {
                speakerNameLabel.text = speaker.display_name
            }
            else
            {
                speakerNameLabel.text = "Name not available"
            }
            speakerNameLabel.textColor = .whiteColor()
            speakerNameLabel.numberOfLines = 2
            speakerNameLabel.lineBreakMode = .ByWordWrapping
            scrollView.addSubview(speakerNameLabel)

            if speaker.organization != nil
            {
                organizationLabel = UILabel.newAutoLayoutView()
                organizationLabel.text = "From " + speaker.organization
                organizationLabel.numberOfLines = 2
                organizationLabel.textColor = .whiteColor()
                organizationLabel.lineBreakMode = .ByWordWrapping
                scrollView.addSubview(organizationLabel)
            }

            if speaker.biography != nil
            {
                biographyView = UITextView.newAutoLayoutView()
                if speaker.richBiography != nil {
                    var htmlString = speaker.richBiography!
                    do {
                        htmlString = "<font size=\"5\">" + htmlString + "</font>"
                        let attributedText = try NSMutableAttributedString(data: htmlString.dataUsingEncoding(NSUTF8StringEncoding)!,
                                                                options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                                                    NSCharacterEncodingDocumentAttribute : NSUTF8StringEncoding],
                                                                documentAttributes: nil)
                        biographyView.attributedText = attributedText
                        
                    } catch {
                        print("Error in SpeakerDetailsViewController")
                    }
                    
                } else {
                    
                    biographyView.text = speaker.biography
                    biographyView.editable = true // Keep this here or the font size will not change while the view is not editable
                    biographyView.font = UIFont.systemFontOfSize(15.0)
                }
//                biographyView.textColor = .whiteColor()
                biographyView.editable = false
                biographyView.backgroundColor = .whiteColor()
                biographyView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
                biographyView.frame = CGRect(x: 0, y: 0, width: biographyView.frame.width, height: biographyView.contentSize.height)
                biographyView.scrollEnabled = false
                scrollView.addSubview(biographyView)
            }
            
            if speaker.image != nil
            {
                speakerImageView = UIImageView.newAutoLayoutView()
                speakerImageView.image = speaker.image
            }
            else
            {
                speakerImageView.image = UIImage(named: "silhouette")
                speakerImageView.contentMode = UIViewContentMode.ScaleAspectFit
            }
            speakerImageView.layer.borderColor = UIColor.blackColor().CGColor
            speakerImageView.layer.cornerRadius = 5.0
            speakerImageView.backgroundColor = .whiteColor()
            scrollView.addSubview(speakerImageView)
            
            setScrollViewContentHeight()
        }

        view.setNeedsUpdateConstraints()
    }

    override func updateViewConstraints() {
        if !didSetupConstraints
        {
            scrollView.autoPinEdgesToSuperviewEdges()
            
            speakerImageView.autoSetDimensionsToSize(CGSize(width: 200.0, height: 200.0))
            if speakerNameLabel != nil {speakerNameLabel.autoSetDimensionsToSize(CGSize(width: self.view.frame.width - 10, height: 42.0))}
            if organizationLabel != nil {organizationLabel.autoSetDimensionsToSize(CGSize(width: self.view.frame.width - 10, height: 42.0))}
            if biographyView != nil {biographyView.autoSetDimension(.Width, toSize: self.view.frame.width)}

            
            speakerImageView.autoPinEdgeToSuperviewEdge(.Top, withInset: 10.0)
            speakerImageView.autoPinEdgeToSuperviewEdge(.Left, withInset: 10.0)
            
            var previousView = speakerImageView as UIView
            
            if speakerNameLabel != nil {
                speakerNameLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: previousView, withOffset: 8)
                speakerNameLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 10.0)
                speakerNameLabel.autoPinEdgeToSuperviewEdge(.Right)
                previousView = speakerNameLabel
            }

            if organizationLabel != nil {
                organizationLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 10.0)
                organizationLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: previousView, withOffset: 8)
                organizationLabel.autoPinEdgeToSuperviewEdge(.Right)
                previousView = organizationLabel
            }
            
            if biographyView != nil {
                biographyView.autoPinEdge(.Top, toEdge: .Bottom, ofView: previousView)
                biographyView.autoPinEdgeToSuperviewEdge(.Left)
                biographyView.autoPinEdgeToSuperviewEdge(.Bottom)
//                biographyView.contentSize = biographyView.sizeThatFits(CGSize(width: view.frame.width, height: CGFloat(MAXFLOAT)))
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
        if biographyView != nil {
            height += biographyView.frame.height
        }

        height += insets

        scrollView.contentSize = CGSize(width: self.view.frame.width, height: height)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
}














