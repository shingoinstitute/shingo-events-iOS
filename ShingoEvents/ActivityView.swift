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
    
    var message = "Loading..." {
        didSet {
            messageLabel.text = message
        }
    }
    var activityView:UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        view.layer.cornerRadius = 12.0
        return view
    }()
    var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    var messageLabel : UILabel = {
        let view = UILabel.newAutoLayoutView()
        view.font = UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
        view.textColor = UIColor.whiteColor()
        view.textAlignment = .Center
        view.shadowColor = UIColor.blackColor()
        view.shadowOffset = CGSizeMake(0.0, 1.0)
        view.numberOfLines = 3
        return view
    }()
    
    var didAddActivityIndicatorConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        view.addSubview(activityView)
        
        activityView.addSubview(activityIndicatorView)
        activityView.addSubview(messageLabel)
        
        view.setNeedsUpdateConstraints()
        
    }
    
    override func updateViewConstraints() {
        
        if !didAddActivityIndicatorConstraints {
            activityView.autoAlignAxis(.Horizontal, toSameAxisOfView: view)
            activityView.autoAlignAxis(.Vertical, toSameAxisOfView: view)
            
            messageLabel.sizeToFit()
            
            activityIndicatorView.startAnimating()

            activityView.autoSetDimensionsToSize(CGSize(width: 160.0, height: 160.0))
            activityView.autoAlignAxis(.Horizontal, toSameAxisOfView: view)
            activityView.autoAlignAxis(.Vertical, toSameAxisOfView: view)
            
            messageLabel.autoPinEdge(.Left, toEdge: .Left, ofView: activityView, withOffset: 5)
            messageLabel.autoPinEdge(.Right, toEdge: .Right, ofView: activityView, withOffset: -5)
            messageLabel.autoPinEdge(.Top, toEdge: .Top, ofView: activityView, withOffset: 24)
            
            activityIndicatorView.autoAlignAxis(.Vertical, toSameAxisOfView: activityView)
            activityIndicatorView.autoPinEdge(.Top, toEdge: .Bottom, ofView: messageLabel, withOffset: 8.0)
            
            didAddActivityIndicatorConstraints = true
        }
        super.updateViewConstraints()
    }
    
}

//class ActivityView: UIView {
//    
//    let activityView:UIView = UIView.newAutoLayoutView()
//    let cancelButton:UIButton = UIButton.newAutoLayoutView()
//    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
//    let messageLabel = UILabel.newAutoLayoutView()
//    
//    var request:Alamofire.Request!
//    
//    func displayActivityView(message message:String, forView view: UIView) {
//        if let request = request {
//            self.request = request
//        }
//        view.addSubview(activityView)
//        activityView.addSubview(activityIndicatorView)
//        activityView.addSubview(messageLabel)
//        
//        messageLabel.text = message
//        messageLabel.font = UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
//        messageLabel.textColor = UIColor.whiteColor()
//        messageLabel.textAlignment = .Center
//        messageLabel.shadowColor = UIColor.blackColor()
//        messageLabel.shadowOffset = CGSizeMake(0.0, 1.0)
//        messageLabel.numberOfLines = 3
//        messageLabel.sizeToFit()
//        
//        activityIndicatorView.startAnimating()
//        
//        activityView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
//        activityView.layer.cornerRadius = 12.0
//        
//        activityView.autoSetDimensionsToSize(CGSize(width: 160.0, height: 160.0))
//        activityView.autoAlignAxis(.Horizontal, toSameAxisOfView: view)
//        activityView.autoAlignAxis(.Vertical, toSameAxisOfView: view)
//        
//        messageLabel.autoPinEdge(.Left, toEdge: .Left, ofView: activityView, withOffset: 5)
//        messageLabel.autoPinEdge(.Right, toEdge: .Right, ofView: activityView, withOffset: -5)
//        messageLabel.autoPinEdge(.Top, toEdge: .Top, ofView: activityView, withOffset: 24)
//        
//        activityIndicatorView.autoAlignAxis(.Vertical, toSameAxisOfView: activityView)
//        activityIndicatorView.autoPinEdge(.Top, toEdge: .Bottom, ofView: messageLabel, withOffset: 8.0)
//        
//    }
//    
//}