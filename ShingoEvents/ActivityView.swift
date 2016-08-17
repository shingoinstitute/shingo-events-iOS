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
    var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    var didAddActivityIndicatorConstraints = false
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .CrossDissolve
        modalPresentationStyle = .OverCurrentContext
        view.backgroundColor = UIColor.clearColor()
        view.addSubview(activityView)
        activityView.addSubviews([activityIndicatorView, messageLabel])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = message
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
            activityIndicatorView.autoAlignAxis(.Horizontal, toSameAxisOfView: activityView, withOffset: 8)
            
            didAddActivityIndicatorConstraints = true
        }
        super.updateViewConstraints()
    }
    
}



