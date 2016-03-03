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
    
    func updateProgress(progress: Float) {
        activityView.progressIndicator.progress += progress
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
        backgroundImage.image = ShingoIconImages().getShingoIconForDevice()
        contentView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        contentView.layer.cornerRadius = 12.0
        
        activityIndicatorView.startAnimating()
        
        messageLabel.font = UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
        messageLabel.textColor = UIColor.whiteColor()
        messageLabel.textAlignment = .Center
        messageLabel.shadowColor = UIColor.blackColor()
        messageLabel.shadowOffset = CGSizeMake(0.0, 1.0)
        messageLabel.numberOfLines = 0
        
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
        
        let messageLabelSize:CGSize = messageLabel.sizeThatFits(CGSizeMake(160.0 - 20.0 * 2.0, CGFloat.max))
        messageLabel.autoSetDimensionsToSize(CGSize(width: messageLabelSize.width, height: messageLabelSize.height))
        messageLabel.autoAlignAxis(.Vertical, toSameAxisOfView: contentView)
        messageLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: contentView)
        
//        progressIndicator.sizeThatFits(CGSizeMake(160.0 - 10.0 * 2.0, CGFloat.max))
        progressIndicator.autoSetDimensionsToSize(CGSizeMake(140.0, 3.0))
        progressIndicator.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: contentView, withOffset: -10.0)
        progressIndicator.autoAlignAxis(.Vertical, toSameAxisOfView: contentView)
//
//        boundingBoxView.frame.size.width = 160.0
//        boundingBoxView.frame.size.height = 160.0
//        boundingBoxView.frame.origin.x = ceil((bounds.width / 2.0) - (boundingBoxView.frame.width / 2.0))
//        boundingBoxView.frame.origin.y = ceil((bounds.height / 2.0) - (boundingBoxView.frame.height / 2.0))
//        
//        activityIndicatorView.frame.origin.x = ceil((bounds.width / 2.0) - (activityIndicatorView.frame.width / 2.0))
//        activityIndicatorView.frame.origin.y = ceil((bounds.height / 2.0) - (activityIndicatorView.frame.height / 2.0))
//        
//        let messageLabelSize = messageLabel.sizeThatFits(CGSizeMake(160.0 - 20.0 * 2.0, CGFloat.max))
//        messageLabel.frame.size.width = messageLabelSize.width
//        messageLabel.frame.size.height = messageLabelSize.height
//        messageLabel.frame.origin.x = ceil((bounds.width / 2.0) - (messageLabel.frame.width / 2.0))
//        messageLabel.frame.origin.y = ceil(activityIndicatorView.frame.origin.y + activityIndicatorView.frame.size.height + ((boundingBoxView.frame.height - activityIndicatorView.frame.height) / 4.0) - (messageLabel.frame.height / 2.0))
    }
    

    
    
}