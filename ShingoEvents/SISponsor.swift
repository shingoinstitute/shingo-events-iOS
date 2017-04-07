//
//  SISponsor.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/21/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit

protocol SISponsorDelegate {
    func onRequestCompletionHandler()
    func onBannerImageRequestCompletionHandler()
}

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
            requestLogoImage(callback: nil)
        }
    }
    var bannerURL : String {
        didSet {
            requestBannerImage(callback: nil)
        }
    }
    var splashScreenURL : String {
        didSet {
            requestSplashScreenImage(callback: nil)
        }
    }
    var bannerImage : UIImage? {
        get {
            return self.image
        }
    }
    var logoImage: UIImage?
    var splashScreenImage : UIImage?
    var didLoadBannerImage: Bool
    var didLoadLogoImage: Bool
    var didLoadSplashScreen: Bool
    var didLoadSponsorDetails: Bool
    
    var tableViewCellDelegate: SISponsorDelegate?
    
    override init() {
        sponsorType = .none
        logoURL = ""
        bannerURL = ""
        splashScreenURL = ""
        didLoadBannerImage = false
        didLoadSplashScreen = false
        didLoadSponsorDetails = false
        didLoadLogoImage = false
        super.init()
    }
    
    convenience init(name: String, type: SponsorType) {
        self.init()
        self.name = name
        self.sponsorType = type
    }
    
    func requestLogoImage(callback: (() -> Void)?) {
        
        if logoURL.isEmpty {
            if let done = callback {
                return done()
            }
        } else {
            self.requestImage(URLString: logoURL) { image in
                if let image = image {
                    self.logoImage = image
                    self.didLoadLogoImage = true
                }
                if let done = callback {
                    return done()
                }
            }
        }
    }
    
    func requestBannerImage(callback: (() -> Void)?) {
        
        if bannerURL.isEmpty {
            if let done = callback {
                return done()
            }
        } else {
            requestImage(URLString: bannerURL) { image in
                if let image = image as UIImage? {
                    self.image = image
                    self.didLoadBannerImage = true
                    self.didLoadImage = true
                }
                
                if let delegate = self.tableViewCellDelegate {
                    delegate.onBannerImageRequestCompletionHandler()
                }
                
                if let done = callback {
                    done()
                }
            }
        }
        
    }
    
    func requestSplashScreenImage(callback: (() -> Void)?) {
        
        if splashScreenURL.isEmpty {
            if let done = callback {
                return done()
            }
        } else {
            requestImage(URLString: splashScreenURL) { image in
                
                if let image = image {
                    self.splashScreenImage = image
                    self.didLoadSplashScreen = true
                }
                
                if let done = callback {
                    done()
                }
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
                
                if let delegate = self.tableViewCellDelegate {
                    delegate.onRequestCompletionHandler()
                }
                
            }
        }
    }
    
}


























