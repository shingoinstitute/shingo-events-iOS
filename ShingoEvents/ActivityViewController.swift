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
    
    var delegate: SIRequestDelegate?
    
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
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowOffset = CGSizeMake(100, 100)
        
        view.numberOfLines = 0
        return view
    }()
    var cancelRequestButton: UIButton = {
        let button = UIButton.newAutoLayoutView()
        button.setTitle("Cancel", forState: .Normal)
        button.setTitleColor(UIView().tintColor, forState: .Normal)
        button.layer.shadowColor = UIColor.blackColor().CGColor
        button.layer.shadowOffset = CGSizeMake(100, 100)
        
        button.layer.cornerRadius = 12
        button.backgroundColor = .whiteColor()
        return button
    }()
    var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    var didAddActivityIndicatorConstraints = false
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        setup()
    }
    
    convenience init(message: String) {
        self.init(nibName: nil, bundle: nil)
        self.message = message
        setup()
    }
    
    private func setup() {
        modalTransitionStyle = .CrossDissolve
        modalPresentationStyle = .OverCurrentContext
        view.backgroundColor = UIColor.clearColor()
        view.addSubviews([activityView, cancelRequestButton])
        activityView.addSubviews([activityIndicatorView, messageLabel])
        cancelRequestButton.addTarget(self, action: #selector(ActivityViewController.didTapCancel(_:)), forControlEvents: .TouchUpInside)
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
            
            if delegate != nil {
                cancelRequestButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: activityView, withOffset: 8)
                cancelRequestButton.autoPinEdge(.Left, toEdge: .Left, ofView: activityView)
                cancelRequestButton.autoPinEdge(.Right, toEdge: .Right, ofView: activityView)
                cancelRequestButton.autoSetDimension(.Height, toSize: 42)
            } else {
                cancelRequestButton.hidden = true
            }
            
            didAddActivityIndicatorConstraints = true
        }
        super.updateViewConstraints()
    }

    func didTapCancel(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.cancelRequest()
        }
    }
    
}



