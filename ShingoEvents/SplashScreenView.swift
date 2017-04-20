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
        imageView.backgroundColor = .black
        
        updateViewConstraints()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSponsorAd(for: event)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Timer.scheduledTimer(withTimeInterval: SplashScreenView.defaultPresentationLength!, repeats: false) { (_) in
            self.onMinPresentationTimerComplete()
        }
    }
}

extension SplashScreenView {
    
    func setSponsorAd(for event: SIEvent) {
        
        guard let splashAd = event.getSplashAd() else {
            imageView.image = #imageLiteral(resourceName: "FlameOnly-HiRes")
            return
        }
        
        if let image = splashAd.image {
            splashAd.presentedAt = Date()
            imageView.image = image
        } else {
            splashAd.makeImageRequest() { image in
                if let image = image {
                    self.imageView.image = image
                }
            }
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
        imageView.autoPinEdgesToSuperviewEdges()
        super.updateViewConstraints()
    }
    
}


























