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

//    @IBOutlet weak var speakerNameLabel: UILabel!
//    @IBOutlet weak var speakerTitleLabel: UILabel!
//    @IBOutlet weak var organizationLabel: UILabel!
//    @IBOutlet weak var biographyTextField: UITextView!
//    @IBOutlet weak var speakerImageView: UIImageView!

    var speakerNameLabel: UILabel!
    var speakerTitleLabel: UILabel!
    var organizationLabel: UILabel!
    var biographyTextField: UITextView!
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
            // For testing
            print("Speaker Name: \(speaker.display_name), ID: \(speaker.speaker_id)")
            
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
                biographyTextField = UITextView.newAutoLayoutView()
                biographyTextField.text = speaker.biography
                biographyTextField.textColor = .whiteColor()
                biographyTextField.editable = false
                biographyTextField.selectable = false
                biographyTextField.backgroundColor = UIColor(red: 0.0/255.0, green: 47.0/255.0, blue: 86.0/255.0, alpha: 1.0)
                biographyTextField.frame = CGRect(x: 0, y: 0, width: biographyTextField.frame.width, height: biographyTextField.contentSize.height)
                biographyTextField.scrollEnabled = false
                scrollView.addSubview(biographyTextField)
            }
            
            if speaker.image != nil
            {
                speakerImageView = UIImageView.newAutoLayoutView()
                speakerImageView.image = speaker.image
                speakerImageView.layer.borderColor = UIColor.blackColor().CGColor
                speakerImageView.layer.cornerRadius = 5.0
                scrollView.addSubview(speakerImageView)
            }
            
            setScrollViewContentHeight()
        }
        else
        {
            // TO-DO: - Set up displaying message when speaker information could not be displayed
            print("ERROR: Could not display information for speaker in SpeakerDetailsViewController.")
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
            if biographyTextField != nil {biographyTextField.autoSetDimension(.Width, toSize: self.view.frame.width)}

            
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
            
            if biographyTextField != nil {
                biographyTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: previousView)
                biographyTextField.autoPinEdgeToSuperviewEdge(.Left)
                biographyTextField.autoPinEdgeToSuperviewEdge(.Bottom)
                biographyTextField.contentSize = biographyTextField.sizeThatFits(CGSize(width: view.frame.width, height: CGFloat(MAXFLOAT)))
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
        if biographyTextField != nil {
            height += biographyTextField.frame.height
        }

        height += insets

        scrollView.contentSize = CGSize(width: self.view.frame.width, height: height)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
}














