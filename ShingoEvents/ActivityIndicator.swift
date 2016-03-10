//
//  ActivityIndicator.swift
//  Pods
//
//  Created by Craig Blackburn on 1/6/16.
//
//

import Foundation
import UIKit
import PureLayout

class ActivityViewController: UIViewController {
    
    private let activityView = ActivityView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .CrossDissolve
        modalPresentationStyle = .OverFullScreen
        activityView.messageLabel.text = " "
        view = activityView
    }
    
    init(message: String) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .CrossDissolve
        modalPresentationStyle = .OverFullScreen
        activityView.messageLabel.text = message
        view = activityView
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMessage(message:String) {
        self.activityView.messageLabel.text = message
    }
    
    func updateProgress(progress: Float) {
        activityView.progressIndicator.progress += progress
    }
    
    func setProgress(progress: Float) {
        activityView.progressIndicator.progress = progress
    }
}

private class ActivityView: UIView {
    
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    let contentView = UIView.newAutoLayoutView()
    let messageLabel = UILabel.newAutoLayoutView()
    let backgroundImage = UIImageView.newAutoLayoutView()
    let progressIndicator:UIProgressView = UIProgressView.newAutoLayoutView()
    
    init() {
        super.init(frame: CGRectZero)
        backgroundColor = UIColor.blackColor()
        backgroundImage.image = ShingoIconImages().shingoIconForDevice()
        contentView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        contentView.layer.cornerRadius = 12.0
        
        activityIndicatorView.startAnimating()
        
        messageLabel.font = UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
        messageLabel.textColor = UIColor.whiteColor()
        messageLabel.textAlignment = .Center
        messageLabel.shadowColor = UIColor.blackColor()
        messageLabel.shadowOffset = CGSizeMake(0.0, 1.0)
        messageLabel.numberOfLines = 3
        
        progressIndicator.progress = 0
        
        addSubview(backgroundImage)
        addSubview(contentView)
        addSubview(activityIndicatorView)
        addSubview(messageLabel)
        addSubview(progressIndicator)
        bringSubviewToFront(contentView)
        bringSubviewToFront(activityIndicatorView)
        bringSubviewToFront(messageLabel)
        bringSubviewToFront(progressIndicator)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundImage.autoSetDimensionsToSize(CGSize(width: self.frame.width, height: self.frame.height))
        backgroundImage.autoPinEdgesToSuperviewEdges()
        
        contentView.autoSetDimensionsToSize(CGSize(width: 160.0, height: 160.0))
        contentView.autoAlignAxis(.Horizontal, toSameAxisOfView: self)
        contentView.autoAlignAxis(.Vertical, toSameAxisOfView: self)
        
        activityIndicatorView.autoAlignAxis(.Vertical, toSameAxisOfView: contentView)
        activityIndicatorView.autoPinEdge(.Top, toEdge: .Top, ofView: contentView, withOffset: 8.0)
        
//        let messageLabelSize:CGSize = messageLabel.sizeThatFits(CGSizeMake(160.0 - 20.0 * 2.0, CGFloat.max))
//        messageLabel.autoSetDimensionsToSize(CGSize(width: messageLabelSize.width, height: messageLabelSize.height))
        messageLabel.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 5)
        messageLabel.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -5)
        messageLabel.autoAlignAxis(.Vertical, toSameAxisOfView: contentView)
        messageLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: contentView)
        
        progressIndicator.autoSetDimensionsToSize(CGSizeMake(140.0, 3.0))
        progressIndicator.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: contentView, withOffset: -10.0)
        progressIndicator.autoAlignAxis(.Vertical, toSameAxisOfView: contentView)

    }
    

    
    
}