//
//  BannerAdView.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/27/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit

protocol BannerViewDelegate {
    func onBannerPresentationComplete()
}

class BannerView: UIView {
    // default presentation length of banner ads is 5 seconds
    static let defaultPresentationLength = TimeInterval(exactly: 10.0)
    
    var rotateTimer: Timer!
    
    var didUpdateConstraints = false
    
    var bannerAds: [SponsorAd]!
    var bannerImageView: UIImageView! {
        didSet {
            bannerImageView.contentMode = .scaleAspectFit
        }
    }
    
    func start(banners: [SponsorAd]) {
        updateConstraints()
        
        bannerAds = banners
        
        if #available(iOS 10.0, *) {
            rotateTimer = Timer.scheduledTimer(withTimeInterval: BannerView.defaultPresentationLength!, repeats: true, block: { (timer) in
                self.changeBanner()
            })
        } else {
            rotateTimer = Timer.scheduledTimer(timeInterval: BannerView.defaultPresentationLength!,
                                               target: self,
                                               selector: #selector(self.changeBanner),
                                               userInfo: nil,
                                               repeats: true)
        }
        rotateTimer.fire()
    }
    
    override func updateConstraints() {
        if !didUpdateConstraints {
            bannerImageView = UIImageView()
            self.addSubview(bannerImageView)
            bannerImageView.autoPinEdgesToSuperviewEdges()
            didUpdateConstraints = true
        }
        super.updateConstraints()
    }
    
    func changeBanner() {
        if !bannerAds.isEmpty {
            let ad = bannerAds.removeFirst()
            bannerAds.append(ad)
            bannerImageView.image = ad.image
        }
    }
    
    deinit {
        if rotateTimer != nil {
            rotateTimer.invalidate()
        }
    }
    
    
}
