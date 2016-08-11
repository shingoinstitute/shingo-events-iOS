//
//  ActivityView.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/15/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ActivityViewController: UIViewController {
    
    var activityView = ActivityView()
    var background = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        
//        background.image = ShingoIconImages().shingoIconForDevice()
        
//        view.addSubview(background)
//        background.autoPinEdgesToSuperviewEdges()
//        background.contentMode = .ScaleAspectFill
        
        view.addSubview(activityView)
        activityView.autoAlignAxis(.Horizontal, toSameAxisOfView: view)
        activityView.autoAlignAxis(.Vertical, toSameAxisOfView: view)
        activityView.displayActivityView(message: "Loading...", forView: view)
        
        
    }
    
}

class ActivityView: UIView {
    
    let activityView:UIView = UIView.newAutoLayoutView()
    let cancelButton:UIButton = UIButton.newAutoLayoutView()
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    let messageLabel = UILabel.newAutoLayoutView()
//    let progressIndicator:UIProgressView = UIProgressView.newAutoLayoutView()
    
    var request:Alamofire.Request!
    
    func displayActivityView(message message:String, forView view: UIView) {
        if let request = request {
            self.request = request
        }
        view.addSubview(activityView)
//        view.addSubview(cancelButton)
        activityView.addSubview(activityIndicatorView)
        activityView.addSubview(messageLabel)
//        activityView.addSubview(progressIndicator)
        
        messageLabel.text = message
        messageLabel.font = UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
        messageLabel.textColor = UIColor.whiteColor()
        messageLabel.textAlignment = .Center
        messageLabel.shadowColor = UIColor.blackColor()
        messageLabel.shadowOffset = CGSizeMake(0.0, 1.0)
        messageLabel.numberOfLines = 3
        messageLabel.sizeToFit()
        
        activityIndicatorView.startAnimating()
        
        activityView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        activityView.layer.cornerRadius = 12.0
        
        activityView.autoSetDimensionsToSize(CGSize(width: 160.0, height: 160.0))
        activityView.autoAlignAxis(.Horizontal, toSameAxisOfView: view)
        activityView.autoAlignAxis(.Vertical, toSameAxisOfView: view)
        
        messageLabel.autoPinEdge(.Left, toEdge: .Left, ofView: activityView, withOffset: 5)
        messageLabel.autoPinEdge(.Right, toEdge: .Right, ofView: activityView, withOffset: -5)
//        messageLabel.autoAlignAxis(.Vertical, toSameAxisOfView: activityView)
        messageLabel.autoPinEdge(.Top, toEdge: .Top, ofView: activityView, withOffset: 24)
//        messageLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: activityView)
        
        activityIndicatorView.autoAlignAxis(.Vertical, toSameAxisOfView: activityView)
        activityIndicatorView.autoPinEdge(.Top, toEdge: .Bottom, ofView: messageLabel, withOffset: 8.0)
        
//        progressIndicator.autoSetDimensionsToSize(CGSizeMake(140.0, 3.0))
//        progressIndicator.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: activityView, withOffset: -10.0)
//        progressIndicator.autoAlignAxis(.Vertical, toSameAxisOfView: activityView)
        
        
    }

    
    func removeActivityViewFromDisplay() {
        activityView.removeFromSuperview()
        cancelButton.removeFromSuperview()
    }
    
}