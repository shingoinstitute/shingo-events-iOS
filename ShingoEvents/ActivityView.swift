//
//  ActivityView.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/15/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit
//import Alamofire

class ActivityViewController: UIViewController {
    
    var delegate: SIRequestDelegate?
    
    var message = "Loading..." {
        didSet {
            messageLabel.text = message
        }
    }
    var activityView:UIView = {
        let view = UIView.newAutoLayout()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        view.layer.cornerRadius = 12
        return view
    }()
    var messageLabel : UILabel = {
        let view = UILabel.newAutoLayout()
        view.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        view.textColor = UIColor.white
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    var cancelRequestButton: UIButton = {
        let button = UIButton.newAutoLayout()
        button.setTitle("Cancel", for: UIControlState())
        button.setTitleColor(UIView().tintColor, for: UIControlState())
        
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 2
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 5
        
        button.backgroundColor = .white
        return button
    }()
    var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
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
    
    fileprivate func setup() {
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
        view.backgroundColor = UIColor.clear
        view.addSubviews([activityView, cancelRequestButton])
        activityView.addSubviews([activityIndicatorView, messageLabel])
        cancelRequestButton.addTarget(self, action: #selector(ActivityViewController.didTapCancel(_:)), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = message
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        
        if !didAddActivityIndicatorConstraints {
            activityView.autoAlignAxis(.horizontal, toSameAxisOf: view)
            activityView.autoAlignAxis(.vertical, toSameAxisOf: view)
            
            messageLabel.sizeToFit()
            
            activityIndicatorView.startAnimating()

            activityView.autoSetDimensions(to: CGSize(width: 160.0, height: 160.0))
            activityView.autoAlignAxis(.horizontal, toSameAxisOf: view)
            activityView.autoAlignAxis(.vertical, toSameAxisOf: view)
            
            messageLabel.autoPinEdge(.left, to: .left, of: activityView, withOffset: 5)
            messageLabel.autoPinEdge(.right, to: .right, of: activityView, withOffset: -5)
            messageLabel.autoPinEdge(.top, to: .top, of: activityView, withOffset: 24)
            
            activityIndicatorView.autoAlignAxis(.vertical, toSameAxisOf: activityView)
            activityIndicatorView.autoAlignAxis(.horizontal, toSameAxisOf: activityView, withOffset: 8)
            
            if delegate != nil {
                cancelRequestButton.autoPinEdge(.top, to: .bottom, of: activityView, withOffset: 8)
                cancelRequestButton.autoPinEdge(.left, to: .left, of: activityView)
                cancelRequestButton.autoPinEdge(.right, to: .right, of: activityView)
                cancelRequestButton.autoSetDimension(.height, toSize: 42)
            } else {
                cancelRequestButton.isHidden = true
            }
            
            didAddActivityIndicatorConstraints = true
        }
        super.updateViewConstraints()
    }

    func didTapCancel(_ sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.cancelRequest()
        }
    }
    
}



