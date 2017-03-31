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
        self.imageView = UIImageView()
        self.imageView.contentMode = UIViewContentMode.scaleAspectFit
        self.imageView.backgroundColor = .black
        self.identifier = identifier
        self.event = event
    }
    
    fileprivate override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // default modal transition style should be `crossDissolve`.
        modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        // default modal presentation style should be `overCurrentContext`.
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        updateViewConstraints()
    }
    
    func setSponsorAd(for event: SIEvent) {
        
        guard let splashAd = event.getSplashAd() else {
            imageView.image = #imageLiteral(resourceName: "Shingo Icon Fullscreen")
            return
        }
        
        if let image = splashAd.image {
            splashAd.presentedAt = Date()
            imageView.image = image
        } else {
            splashAd.makeImageRequest()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSponsorAd(for: event)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: SplashScreenView.defaultPresentationLength!, repeats: false) { (_) in
                self.onMinPresentationTimerComplete()
            }
        } else {
            Timer.scheduledTimer(timeInterval: SplashScreenView.defaultPresentationLength!,
                                 target: self,
                                 selector: #selector(self.onMinPresentationTimerComplete),
                                 userInfo: nil,
                                 repeats: false)
        }
        
    }
    
    override func updateViewConstraints() {
        if !didUpdateViewConstrains {
            imageView.autoPinEdgesToSuperviewEdges()
            didUpdateViewConstrains = true
        }
        super.updateViewConstraints()
    }
    
    func onMinPresentationTimerComplete() {
        event.didDisplaySponsorAd = true
        if let delegate = self.delegate {
            delegate.onPresentSplashScreenComplete(identifier: identifier, event: event)
        }
    }
    
}



























