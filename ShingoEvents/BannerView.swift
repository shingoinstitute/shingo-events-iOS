//
//  BannerAdView.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/27/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit

class BannerView: UIView {
    // default presentation length of banner ads is 4 seconds
    static let defaultPresentationLength = TimeInterval(exactly: 10.0)
    
    var rotateTimer: Timer!
    
    var didUpdateConstraints = false
    
    var bannerAds: [SponsorAd]!
    
    var banner: UIImageView! {
        didSet {
            banner.contentMode = .scaleAspectFit
            banner.backgroundColor = .clear
        }
    }
    
    func start() {
        updateConstraints()
        rotateTimer = Timer.scheduledTimer(withTimeInterval: BannerView.defaultPresentationLength!, repeats: true, block: { (_) in
            self.changeBanner()
        })
        rotateTimer.fire()
    }
    
    override func updateConstraints() {
        if !didUpdateConstraints {
            banner = UIImageView()
            addSubview(banner)
            banner.autoPinEdgesToSuperviewEdges()
            didUpdateConstraints = true
        }
        super.updateConstraints()
    }
    
    func changeBanner() {
        guard let nextBannerImage = getNextBanner() else {
            rotateTimer.invalidate()
            return
        }
        
        banner.image = nextBannerImage
    }
    
    private func getNextBanner() -> UIImage? {
        if bannerAds.isEmpty {
            return nil
        }
        bannerAds.append(bannerAds.removeFirst())
        if let last = bannerAds.last {
            return last.image
        }
        return nil
    }
    
    
}
