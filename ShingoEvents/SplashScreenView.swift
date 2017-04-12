//
//  SplashScreenView.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/7/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit

protocol SplashScreenViewDelegate {
    func onPresentSplashScreenComplete(identifier: String, event: SIEvent)
}

class SplashScreenView: UIViewController {
    
    static let defaultPresentationLength = TimeInterval(exactly: 2.0)
    
    var presentedAt: Date?
    
    var timer: Timer!
    
    var imageView: UIImageView!
    
    var delegate: SplashScreenViewDelegate?
    
    var identifier: String!
    
    var event: SIEvent!
    
    var didUpdateViewConstrains = false
    
    var msgLabel: UILabel = UILabel(text: "Loading")
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var msgContainer: UIView = UIView()
    
    /**
     - parameter splashScreenImage: The advertisement image to be displayed on the screen
     - parameter delegate: The view controller currently presenting the splash screen.
     */
    convenience init(viewController parent: SplashScreenViewDelegate, identifier: String, event: SIEvent) {
        self.init(nibName: nil, bundle: nil)
        self.delegate = parent
        self.identifier = identifier
        self.event = event
        
        self.imageView = UIImageView(image: #imageLiteral(resourceName: "FlameOnly-HiRes"))
        self.imageView.contentMode = UIViewContentMode.scaleAspectFit
        
        imageView.contentMode = .scaleAspectFit
    }
    
    fileprivate override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        view.addSubview(msgContainer)
        msgContainer.addSubview(msgLabel)
        msgContainer.addSubview(activityIndicator)
        
        msgContainer.backgroundColor = .white
        msgContainer.layer.cornerRadius = 2.0
        msgLabel.backgroundColor = .white
        activityIndicator.backgroundColor = .white
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        
        updateViewConstraints()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSponsorAd(for: event)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        msgContainer.sizeToFit()
        Timer.scheduledTimer(withTimeInterval: SplashScreenView.defaultPresentationLength!, repeats: false) { (_) in
            self.onMinPresentationTimerComplete()
        }
    }
}

extension SplashScreenView {
    
    func setSponsorAd(for event: SIEvent) {
        
        let didHaveDefaultImage = imageView.image == #imageLiteral(resourceName: "FlameOnly-HiRes")
        
        guard let splashAd = event.getSplashAd() else {
            imageView.image = #imageLiteral(resourceName: "FlameOnly-HiRes")
            return
        }
        
        if didHaveDefaultImage {
            updateViewConstraints()
        }
        
        imageView.backgroundColor = .black
        
        if let image = splashAd.image {
            splashAd.presentedAt = Date()
            imageView.image = image
        } else {
            splashAd.makeImageRequest()
        }
        
    }
    
    func onMinPresentationTimerComplete() {
        event.didDisplaySponsorAd = true
        if let delegate = self.delegate {
            delegate.onPresentSplashScreenComplete(identifier: identifier, event: event)
        }
    }
    
}

extension SplashScreenView {
    
    override func updateViewConstraints() {
        if !didUpdateViewConstrains {
            
            msgContainer.autoPinEdge(.top, to: .top, of: view, withOffset: 20.0)
            msgContainer.autoAlignAxis(.vertical, toSameAxisOf: view)
            
            msgLabel.autoPinEdge(.top, to: .top, of: msgContainer, withOffset: 4.0)
            msgLabel.autoPinEdge(.bottom, to: .bottom, of: msgContainer, withOffset: -4.0)
            msgLabel.autoPinEdge(.right, to: .right, of: msgContainer, withOffset: -4.0)
            msgLabel.autoAlignAxis(.vertical, toSameAxisOf: msgContainer)
            
            activityIndicator.autoPinEdge(.top, to: .top, of: msgContainer, withOffset: 4.0)
            activityIndicator.autoPinEdge(.right, to: .left, of: msgLabel, withOffset: -4.0)
            activityIndicator.autoPinEdge(.left, to: .left, of: msgContainer, withOffset: 4.0)
            activityIndicator.autoPinEdge(.bottom, to: .bottom, of: msgContainer, withOffset: -4.0)
            activityIndicator.autoSetDimension(.width, toSize: 20.0)
            
            if imageView.image == #imageLiteral(resourceName: "FlameOnly-HiRes") {
                imageView.autoPinEdge(.top, to: .bottom, of: msgContainer, withOffset: 8)
                imageView.autoPinEdge(.left, to: .left, of: view, withOffset: 0)
                imageView.autoPinEdge(.right, to: .right, of: view, withOffset: 0)
                imageView.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: -8)
            } else {
                imageView.autoPinEdgesToSuperviewEdges()
            }
            
            view.bringSubview(toFront: msgContainer)
            
            didUpdateViewConstrains = true
        }
        super.updateViewConstraints()
    }
    
}


























