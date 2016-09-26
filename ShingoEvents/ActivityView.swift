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



