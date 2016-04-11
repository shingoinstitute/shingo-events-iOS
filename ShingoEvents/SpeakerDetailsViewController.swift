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
    var biographyView: UIWebView!
    var speakerImageView: UIImageView!
    
    var speaker:Speaker!
    var didSetupConstraints = false
    var scrollView: UIScrollView!
    override func loadView()
    {
        view = UIView()
        view.backgroundColor = .whiteColor() 
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
            speakerNameLabel.numberOfLines = 2
            speakerNameLabel.lineBreakMode = .ByWordWrapping
            scrollView.addSubview(speakerNameLabel)

            if speaker.organization != nil
            {
                organizationLabel = UILabel.newAutoLayoutView()
                organizationLabel.text = "From " + speaker.organization
                organizationLabel.numberOfLines = 2
                organizationLabel.lineBreakMode = .ByWordWrapping
                scrollView.addSubview(organizationLabel)
            }

            if speaker.biography != nil
            {
                biographyView = UIWebView.newAutoLayoutView()
                if speaker.richBiography != nil {
                    let htmlString = speaker.richBiography!
                    biographyView.loadHTMLString(htmlString, baseURL: nil)
                } else {
                    biographyView.loadHTMLString(speaker.biography, baseURL: nil)
                }
                
                
//                biographyView = speaker.biography
//                biographyView = .whiteColor()
//                biographyView.backgroundColor = UIColor(red: 0.0/255.0, green: 47.0/255.0, blue: 86.0/255.0, alpha: 1.0)
                biographyView.frame = CGRect(x: 0, y: 0, width: biographyView.frame.width, height: biographyView.frame.height)
                scrollView.addSubview(biographyView)
            }
            
            if speaker.image != nil
            {
                speakerImageView = UIImageView.newAutoLayoutView()
                speakerImageView.image = speaker.image
                speakerImageView.layer.borderColor = UIColor.blackColor().CGColor
                speakerImageView.layer.cornerRadius = 5.0
            }
            else
            {
                speakerImageView.image = UIImage(named: "silhouette")
                speakerImageView.contentMode = UIViewContentMode.ScaleAspectFit
            }
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
                speakerNameLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: previousView)
                speakerNameLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 10.0)
                speakerNameLabel.autoPinEdgeToSuperviewEdge(.Right)
                previousView = speakerNameLabel
            }

            if organizationLabel != nil {
                organizationLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 10.0)
                organizationLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: previousView)
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














