//
//  SIExhibitor.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/21/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit

class SIExhibitor: SIObject {
    
    var contactEmail: String
    var website: String
    var logoURL: String {
        didSet {
            requestExhibitorLogoImage(nil)
        }
    }
    var bannerURL: String {
        didSet {
            requestExhibitorBannerImage(nil)
        }
    }
    var didLoadBannerImage: Bool
    var mapCoordinate: (Double, Double)
    fileprivate var bannerImage: UIImage?
    
    override init() {
        contactEmail = ""
        website = ""
        logoURL = ""
        bannerURL = ""
        mapCoordinate = (0, 0)
        bannerImage = nil
        didLoadBannerImage = false
        super.init()
    }
    
    fileprivate func requestExhibitorLogoImage(_ callback: (() -> Void)?) {
        
        if image != nil || logoURL.isEmpty{
            if let cb = callback { cb() }
            return
        }
        
        requestImage(URLString: logoURL, callback: { image in
            if let image = image as UIImage? {
                self.image = image
                self.didLoadImage = true
            }
            
            if let cb = callback { cb() }
        });
    }
    
    fileprivate func requestExhibitorBannerImage(_ callback: (() -> Void)?) {
        
        if bannerImage != nil || bannerURL.isEmpty {
            if let cb = callback {
                cb()
            }
            return
        }
        
        requestImage(URLString: bannerURL, callback: { image in
            if let image = image {
                self.bannerImage = image
                self.didLoadBannerImage = true
            }
            
            if let cb = callback {
                cb()
            }
        });
    }
    
    func getLogoImage(_ callback: @escaping (_ image: UIImage) -> ()) {
        
        guard let image = self.image else {
            requestExhibitorLogoImage() {
                if let image = self.image {
                    callback(image)
                } else if let image = UIImage(named: "logoComingSoon") {
                    callback(image)
                } else {
                    callback(UIImage())
                }
            }
            return
        }
        
        callback(image)
    }
    
    func getBannerImage(_ callback: @escaping (_ image: UIImage) -> ()) {
        
        guard let image = self.bannerImage else {
            requestExhibitorBannerImage() {
                if let image = self.image {
                    callback(image)
                } else if let image = UIImage(named: "logoComingSoon") {
                    callback(image)
                } else {
                    callback(UIImage())
                }
            }
            return
        }
        
        callback(image)
        
    }
}
