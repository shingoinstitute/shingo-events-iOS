//
//  SplashScreenView.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/7/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit

class SplashScreenView: UIViewController {
    
    let minPresentationLength: TimeInterval = 3 * 1000
    
    var canDismissSplashScreen = false
    
    var imageView: UIImageView! {
        didSet {
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            imageView.backgroundColor = .black
        }
    }
    
    var didUpdateViewConstrains = false
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // default modal transition style should be `crossDissolve`.
        modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        // default modal presentation style should be `overCurrentContext`.
        modalPresentationStyle = .overCurrentContext
    }
    
    convenience init(splashScreenImage: UIImage) {
        self.init(nibName: nil, bundle: nil)
        self.imageView = UIImageView(image: splashScreenImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        if !didUpdateViewConstrains {
            
            imageView.autoPinEdgesToSuperviewEdges()
            
            didUpdateViewConstrains = true
        }
        super.updateViewConstraints()
    }
    
    func presentSplashScreen(parentViewController parent: UIViewController, completion: @escaping ((Void) -> Void)) {
        parent.present(self, animated: true) {
            self.presentationTimer = Timer.scheduledTimer(
                timeInterval: 3.0,
                target: self,
                selector: #selector(self.onMinPresentationLength),
                userInfo: nil,
                repeats: true
            )
            
            self.presentationTimer.fire()
            
            completion()
            
        }
    }
    
    var parentVC: UIViewController!
    var onCompletion: ((Void) -> Void)!
    var waitTimer: Timer!
    var presentationTimer: Timer!
    var timerFireCount = 0
    
    
    func dismissSplashScreen(parentViewController parent: UIViewController, completion: @escaping ((Void) -> Void)) {
        
        if parentVC == nil {
            parentVC = parent
        }
        
        if onCompletion == nil {
            onCompletion = completion
        }
        
        if canDismissSplashScreen {
           parentVC.dismiss(animated: true, completion: onCompletion)
        } else {
            waitTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.waitForMinPresentationTime), userInfo: nil, repeats: true)
        }
    }
    
    func waitForMinPresentationTime() {
        if canDismissSplashScreen {
            waitTimer.invalidate()
            parentVC.dismiss(animated: false, completion: onCompletion)
        }
    }
    
    func onMinPresentationLength() {
        
        if timerFireCount > 0 {
            print("\(3 * timerFireCount) Seconds have passed!")
            canDismissSplashScreen = true
            presentationTimer.invalidate()
        } else {
            timerFireCount += 1
        }
        
    }
    
}



























