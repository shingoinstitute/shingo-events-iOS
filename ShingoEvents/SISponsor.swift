//
//  SISponsor.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/21/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit

class SISponsor: SIObject {
    
    enum SponsorType: Int {
        case none = 0,
        friend = 1,
        supporter = 2,
        benefactor = 3,
        champion = 4,
        president = 5
    }
    
    var sponsorType : SponsorType
    var logoURL : String {
        didSet {
            requestLogoImage(nil)
        }
    }
    var bannerURL : String {
        didSet {
            requestBannerImage(nil)
        }
    }
    var splashScreenURL : String {
        didSet {
            requestSplashScreenImage(nil)
        }
    }
    private var bannerImage : UIImage?
    private var splashScreenImage : UIImage?
    var didLoadBannerImage: Bool
    var didLoadSplashScreen: Bool
    var didLoadSponsorDetails: Bool
    
    override init() {
        sponsorType = .none
        logoURL = ""
        bannerURL = ""
        splashScreenURL = ""
        bannerImage = nil
        splashScreenImage = nil
        didLoadBannerImage = false
        didLoadSplashScreen = false
        didLoadSponsorDetails = false
        super.init()
    }
    
    convenience init(name: String, type: SponsorType) {
        self.init()
        self.name = name
        self.sponsorType = type
    }
    
    fileprivate func requestLogoImage(_ callback: (() -> Void)?) {
        
        if image != nil || logoURL.isEmpty {
            if let cb = callback { cb() }
            return
        }
        
        self.requestImage(URLString: logoURL) { image in
            if let image = image {
                self.image = image
                self.didLoadImage = true
            }
            if let cb = callback { cb() }
        }
    }
    
    private func requestBannerImage(_ callback: (() -> Void)?) {
        
        if bannerImage != nil || bannerURL.isEmpty {
            if let cb = callback { cb() }
            return
        }
        
        requestImage(URLString: bannerURL) { image in
            if let image = image as UIImage? {
                self.bannerImage = image
                self.didLoadBannerImage = true
            }
            if let cb = callback {
                cb()
            }
        }
    }
    
    private func requestSplashScreenImage(_ callback: (() -> Void)?) {
        
        if splashScreenImage != nil || splashScreenURL.isEmpty {
            if let cb = callback { cb() }
            return
        }
        
        requestImage(URLString: splashScreenURL, callback: { image in
            if let image = image {
                self.splashScreenImage = image
                self.didLoadSplashScreen = true
            }
            if let cb = callback {
                cb()
            }
        });
    }
    
    func getBannerImage(_ callback: @escaping (UIImage) -> ()) {
        
        if let image = self.bannerImage {
            callback(image)
            return
        }
        
        requestBannerImage() {
            if let image = self.image {
                callback(image)
            } else if let image = UIImage(named: "Shingo Icon Small") {
                callback(image)
            } else {
                callback(UIImage())
            }
        }
    }
    
    func getLogoImage(_ callback: @escaping (UIImage) -> ()) {
        
        if let image = self.image {
            callback(image)
            return
        }
        
        requestLogoImage {
            if let image = self.image {
                callback(image)
            } else if let image = UIImage(named: "sponsor_banner_pl") {
                callback(image)
            } else {
                callback(UIImage())
            }
        }
    }
    
    func getSplashScreenImage(_ callback: @escaping (UIImage) -> ()) {
        
        if let image = self.splashScreenImage {
            callback(image)
            return
        }
        
        requestSplashScreenImage {
            if let image = self.image {
                callback(image)
            } else if let image = UIImage(named: "Sponsor_Splash_Screen_pl") {
                callback(image)
            } else {
                callback(UIImage())
            }
        }
    }
    
    func requestSponsorDetails() {
        SIRequest().requestSponsor(sponsorId: self.id) { sponsor in
            if let sponsor = sponsor {
                self.name = sponsor.name
                self.logoURL = sponsor.logoURL
                self.attributedSummary = sponsor.attributedSummary
                self.bannerURL = sponsor.bannerURL
                self.splashScreenImage = sponsor.splashScreenImage
                self.sponsorType = sponsor.sponsorType
                self.didLoadSponsorDetails = true
            }
        }
    }
    
}


























