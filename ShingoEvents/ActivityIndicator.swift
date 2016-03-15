////
////  ActivityIndicator.swift
////  Pods
////
////  Created by Craig Blackburn on 1/6/16.
////
////
//
//import Foundation
//import UIKit
//import PureLayout
//
//class ActivityViewController: UIViewController {
//
//    var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
//    var contentView = UIView.newAutoLayoutView()
//    var messageLabel = UILabel.newAutoLayoutView()
//    var backgroundImage = UIImageView.newAutoLayoutView()
//    var progressIndicator:UIProgressView = UIProgressView.newAutoLayoutView()
////    var cancelView:UIButton = UIButton.newAutoLayoutView()
//    
//    
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        modalTransitionStyle = .CrossDissolve
//        modalPresentationStyle = .OverFullScreen
//        messageLabel.text = " "
//    }
//    
//    init(message: String) {
//        super.init(nibName: nil, bundle: nil)
//        modalTransitionStyle = .CrossDissolve
//        modalPresentationStyle = .OverFullScreen
//        messageLabel.text = message
//    }
//    
//    override func viewDidLoad() {
//        view.backgroundColor = UIColor.clearColor()
//        backgroundImage.image = ShingoIconImages().shingoIconForDevice()
//        contentView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
//        contentView.layer.cornerRadius = 12.0
//        
////        cancelView.setTitle("Cancel", forState: UIControlState.Normal)
////        cancelView.setTitleColor(view.tintColor, forState: UIControlState.Normal)
////        cancelView.titleLabel?.font = UIFont.systemFontOfSize(16.0)
////        cancelView.titleLabel?.textAlignment = .Center
////        cancelView.layer.cornerRadius = 5.0
//        
//        activityIndicatorView.startAnimating()
//        
//        messageLabel.font = UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
//        messageLabel.textColor = UIColor.whiteColor()
//        messageLabel.textAlignment = .Center
//        messageLabel.shadowColor = UIColor.blackColor()
//        messageLabel.shadowOffset = CGSizeMake(0.0, 1.0)
//        messageLabel.numberOfLines = 3
//        
//        progressIndicator.progress = 0
//        
////        addSubview(backgroundImage)
//        view.addSubview(contentView)
////        view.addSubview(cancelView)
//        contentView.addSubview(activityIndicatorView)
//        contentView.addSubview(messageLabel)
//        contentView.addSubview(progressIndicator)
//        view.bringSubviewToFront(contentView)
////        view.bringSubviewToFront(cancelView)
//        
//        
//
////        backgroundImage.autoSetDimensionsToSize(CGSize(width: self.frame.width, height: self.frame.height))
////        backgroundImage.autoPinEdgesToSuperviewEdges()
////        cancelView.addTarget(self, action: "cancel:", forControlEvents: UIControlEvents.TouchUpInside)
//        
//        
//        contentView.autoSetDimensionsToSize(CGSize(width: 160.0, height: 160.0))
//        contentView.autoAlignAxis(.Horizontal, toSameAxisOfView: view)
//        contentView.autoAlignAxis(.Vertical, toSameAxisOfView: view)
//        
//        activityIndicatorView.autoAlignAxis(.Vertical, toSameAxisOfView: contentView)
//        activityIndicatorView.autoPinEdge(.Top, toEdge: .Top, ofView: contentView, withOffset: 8.0)
//        
//        messageLabel.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 5)
//        messageLabel.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -5)
//        messageLabel.autoAlignAxis(.Vertical, toSameAxisOfView: contentView)
//        messageLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: contentView)
//        
//        progressIndicator.autoSetDimensionsToSize(CGSizeMake(140.0, 3.0))
//        progressIndicator.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: contentView, withOffset: -10.0)
//        progressIndicator.autoAlignAxis(.Vertical, toSameAxisOfView: contentView)
//        
//        
////        cancelView.autoSetDimensionsToSize(CGSize(width: 160, height: 42))
////        cancelView.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 0)
////        cancelView.autoPinEdge(.Top, toEdge: .Bottom, ofView: contentView, withOffset: 8.0)
////        cancelView.backgroundColor = UIColor.whiteColor()
////        
//        
//    }
//    
//    func cancel(sender: UIButton!) {
//        view.removeFromSuperview()
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setMessage(message:String) {
//        self.messageLabel.text = message
//    }
//    
//    func updateProgress(progress: Float) {
//        progressIndicator.progress += progress
//    }
//    
//    func setProgress(progress: Float) {
//        progressIndicator.progress = progress
//    }
//}
//
//private class ActivityView: UIView {
//    
//    var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
//    var contentView = UIView.newAutoLayoutView()
//    var messageLabel = UILabel.newAutoLayoutView()
//    var backgroundImage = UIImageView.newAutoLayoutView()
//    var progressIndicator:UIProgressView = UIProgressView.newAutoLayoutView()
//    var cancelView:UIButton = UIButton.newAutoLayoutView()
//    
//    init() {
//        super.init(frame: CGRectZero)
//        backgroundColor = UIColor.clearColor()
//        backgroundImage.image = ShingoIconImages().shingoIconForDevice()
//        contentView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
//        contentView.layer.cornerRadius = 12.0
//        
//        cancelView.setTitle("Cancel", forState: UIControlState.Normal)
//        cancelView.setTitleColor(self.tintColor, forState: UIControlState.Normal)
//        cancelView.titleLabel?.font = UIFont.systemFontOfSize(16.0)
//        cancelView.titleLabel?.textAlignment = .Center
//        cancelView.layer.cornerRadius = 5.0
//        
//        activityIndicatorView.startAnimating()
//        
//        messageLabel.font = UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
//        messageLabel.textColor = UIColor.whiteColor()
//        messageLabel.textAlignment = .Center
//        messageLabel.shadowColor = UIColor.blackColor()
//        messageLabel.shadowOffset = CGSizeMake(0.0, 1.0)
//        messageLabel.numberOfLines = 3
//        
//        progressIndicator.progress = 0
//        
////        addSubview(backgroundImage)
//        addSubview(contentView)
//        addSubview(cancelView)
//        contentView.addSubview(activityIndicatorView)
//        contentView.addSubview(messageLabel)
//        contentView.addSubview(progressIndicator)
//        bringSubviewToFront(contentView)
//        bringSubviewToFront(cancelView)
//
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
////        backgroundImage.autoSetDimensionsToSize(CGSize(width: self.frame.width, height: self.frame.height))
////        backgroundImage.autoPinEdgesToSuperviewEdges()
//        cancelView.addTarget(self, action: "cancel:", forControlEvents: UIControlEvents.TouchUpInside)
//        
//        
//        contentView.autoSetDimensionsToSize(CGSize(width: 160.0, height: 160.0))
//        contentView.autoAlignAxis(.Horizontal, toSameAxisOfView: self)
//        contentView.autoAlignAxis(.Vertical, toSameAxisOfView: self)
//        
//        activityIndicatorView.autoAlignAxis(.Vertical, toSameAxisOfView: contentView)
//        activityIndicatorView.autoPinEdge(.Top, toEdge: .Top, ofView: contentView, withOffset: 8.0)
//
//        messageLabel.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 5)
//        messageLabel.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -5)
//        messageLabel.autoAlignAxis(.Vertical, toSameAxisOfView: contentView)
//        messageLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: contentView)
//        
//        progressIndicator.autoSetDimensionsToSize(CGSizeMake(140.0, 3.0))
//        progressIndicator.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: contentView, withOffset: -10.0)
//        progressIndicator.autoAlignAxis(.Vertical, toSameAxisOfView: contentView)
//        
//
//        cancelView.autoSetDimensionsToSize(CGSize(width: 160, height: 42))
//        cancelView.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 0)
//        cancelView.autoPinEdge(.Top, toEdge: .Bottom, ofView: contentView, withOffset: 8.0)
//        cancelView.backgroundColor = UIColor.whiteColor()
//
//    }
//    
//    
//
//    
//    
//}