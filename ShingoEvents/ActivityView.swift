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

class ActivityView: UIView {
    
    let activityView:UIView = UIView.newAutoLayoutView()
    let cancelButton:UIButton = UIButton.newAutoLayoutView()
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    let messageLabel = UILabel.newAutoLayoutView()
    let progressIndicator:UIProgressView = UIProgressView.newAutoLayoutView()
    
    var request:Alamofire.Request!
    
    func displayActivityView(message message:String, forView view: UIView, withRequest request: Alamofire.Request?) {
        if let request = request {
            self.request = request
        }
        view.addSubview(activityView)
//        view.addSubview(cancelButton)
        activityView.addSubview(activityIndicatorView)
        activityView.addSubview(messageLabel)
        activityView.addSubview(progressIndicator)
        
        messageLabel.text = message
        messageLabel.font = UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
        messageLabel.textColor = UIColor.whiteColor()
        messageLabel.textAlignment = .Center
        messageLabel.shadowColor = UIColor.blackColor()
        messageLabel.shadowOffset = CGSizeMake(0.0, 1.0)
        messageLabel.numberOfLines = 3
        
        activityIndicatorView.startAnimating()
        
        activityView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        activityView.layer.cornerRadius = 12.0
        
        activityView.autoSetDimensionsToSize(CGSize(width: 160.0, height: 160.0))
        activityView.autoAlignAxis(.Horizontal, toSameAxisOfView: view)
        activityView.autoAlignAxis(.Vertical, toSameAxisOfView: view)
        
        activityIndicatorView.autoAlignAxis(.Vertical, toSameAxisOfView: activityView)
        activityIndicatorView.autoPinEdge(.Top, toEdge: .Top, ofView: activityView, withOffset: 8.0)
        
        messageLabel.autoPinEdge(.Left, toEdge: .Left, ofView: activityView, withOffset: 5)
        messageLabel.autoPinEdge(.Right, toEdge: .Right, ofView: activityView, withOffset: -5)
        messageLabel.autoAlignAxis(.Vertical, toSameAxisOfView: activityView)
        messageLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: activityView)
        
        progressIndicator.autoSetDimensionsToSize(CGSizeMake(140.0, 3.0))
        progressIndicator.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: activityView, withOffset: -10.0)
        progressIndicator.autoAlignAxis(.Vertical, toSameAxisOfView: activityView)
        
//        cancelButton.setTitle("Cancel", forState: UIControlState.Normal)
//        cancelButton.addTarget(self, action: #selector(ActivityView.cancelRequest), forControlEvents: UIControlEvents.TouchUpInside)
//        cancelButton.setTitleColor(view.tintColor, forState: UIControlState.Normal)
//        cancelButton.titleLabel?.font = UIFont.systemFontOfSize(16.0)
//        cancelButton.titleLabel?.textAlignment = .Center
//        cancelButton.layer.cornerRadius = 5.0
//        cancelButton.backgroundColor = UIColor.whiteColor()
//        
//        cancelButton.autoSetDimensionsToSize(CGSize(width: 160, height: 42))
//        cancelButton.autoPinEdge(.Left, toEdge: .Left, ofView: activityView, withOffset: 0)
//        cancelButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: activityView, withOffset: 8.0)
        
    }
    
    var time: Float = 0
    var timer : NSTimer!
    var progress : Float = 0
    func animateProgress(progress: Float) {
        self.progress = progress
        timer = NSTimer.scheduledTimerWithTimeInterval(0.02, target: self, selector: #selector(ActivityView.updateProgressBarAnimation), userInfo: nil, repeats: true)
    }
    
    @objc private func updateProgressBarAnimation() {
        time += 0.01
        progressIndicator.setProgress(time, animated: false)
        if (time / progress) >= 1 {
            timer.invalidate()
        }
    }
    
    func cancelRequest() {
        print("Canceling http request.")
        if self.request != nil {
            self.request.cancel()
        }
        removeActivityViewFromDisplay()
    }

    
    func removeActivityViewFromDisplay() {
        activityView.removeFromSuperview()
        cancelButton.removeFromSuperview()
    }
    
}