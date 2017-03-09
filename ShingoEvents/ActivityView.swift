//
//  ActivityView.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/15/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit

/**
 This class provides a view that indicates data is being loaded onto the device from an external source.
 This class is meant to be presented modally.
 */
class ActivityViewController: UIViewController {
    
    var activityView: UIView = {
        let view = UIView.newAutoLayout()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        view.layer.cornerRadius = 12
        return view
    }()
    var messageLabel: UILabel = {
        let view = UILabel.newAutoLayout()
        view.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        view.textColor = UIColor.white
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()

    var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var didSetupConstraints = false
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        view.backgroundColor = UIColor.clear
        
        // add gradient layer for better visual
        let gradientLayer = RadialGradientLayer()
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // default modal transition style should be `crossDissolve`.
        modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        // default modal presentation style should be `overCurrentContext`.
        modalPresentationStyle = .overCurrentContext
        
        // add subviews to parent view
        view.addSubview(activityView)
        activityView.addSubviews([activityIndicatorView, messageLabel])
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.messageLabel.text = "Downloading..."
    }
    
    convenience init(message: String) {
        self.init(nibName: nil, bundle: nil)
        self.messageLabel.text = message
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.startAnimating()
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            activityView.autoAlignAxis(.horizontal, toSameAxisOf: view)
            activityView.autoAlignAxis(.vertical, toSameAxisOf: view)
            
            messageLabel.sizeToFit()

            activityView.autoSetDimensions(to: CGSize(width: 160.0, height: 160.0))
            activityView.autoAlignAxis(.horizontal, toSameAxisOf: view)
            activityView.autoAlignAxis(.vertical, toSameAxisOf: view)
            
            messageLabel.autoPinEdge(.left, to: .left, of: activityView, withOffset: 5)
            messageLabel.autoPinEdge(.right, to: .right, of: activityView, withOffset: -5)
            messageLabel.autoPinEdge(.top, to: .top, of: activityView, withOffset: 24)
            
            activityIndicatorView.autoAlignAxis(.vertical, toSameAxisOf: activityView)
            activityIndicatorView.autoAlignAxis(.horizontal, toSameAxisOf: activityView, withOffset: 8)
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
}



