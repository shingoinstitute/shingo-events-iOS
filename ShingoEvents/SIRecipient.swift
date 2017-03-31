//
//  SIRecipient.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/21/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit

class SIRecipient: SIObject {
    
    enum AwardType: String {
        case shingoPrize = "Shingo Prize",
        silver = "Silver Medallion",
        bronze = "Bronze Medallion",
        research = "Research Award",
        publication = "Publication Award",
        none = "N/A"
    }
    
    var awardType : AwardType
    var organization : String
    var photoList : String //Comma separated list of URLs to photos
    var videoList : String //Comma separated list of URLs to videos
    var pressRelease : String
    var profile : String
    var logoURL : String {
        didSet {
            requestRecipientImage(nil)
        }
    }
    
    override init() {
        awardType = AwardType.none
        organization = ""
        logoURL = ""
        photoList = ""
        videoList = ""
        pressRelease = ""
        profile = ""
        super.init()
    }
    
    convenience init(name: String, type: AwardType) {
        self.init()
        self.name = name
    }
    
    fileprivate func requestRecipientImage(_ callback: (() -> Void)?) {
        
        if image != nil || logoURL.isEmpty {
            if let cb = callback { cb() }
            return
        }
        
        requestImage(URLString: logoURL) { image in
            if let image = image {
                self.image = image
                self.didLoadImage = true
            }
            if let cb = callback { cb() }
        }
        
    }
    
    func getRecipientImage(_ callback: @escaping (UIImage) -> Void) {
        
        if let image = self.image {
            callback(image)
        } else {
            requestRecipientImage() {
                if let image = self.image {
                    callback(image)
                } else {
                    callback(UIImage(named: "logoComingSoon")!)
                }
            }
        }
    }
}
