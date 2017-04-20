//
//  SponsorAd.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/21/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit

enum AdType: Int {
    case none = 0,
    banner = 1,
    splashScreen = 2
}

class SponsorAd: SIObject {
    
    static let presentationSleepLength: TimeInterval = TimeInterval(exactly: 60.0 * 60.0)! // 1 hour
    
    var imageUrl: String!
    var type: AdType!
    
    var parentEvent: SIEvent?
    var parentEventId: String!
    var parentSponsor: SISponsor?
    var parentSponsorId: String!
    var presentedAt: Date?
    
    convenience init(id: String, name: String, parentEvent event: SIEvent, parentSponsor sponsor: SISponsor, imageUrl url: String, adType type: AdType) {
        self.init(id: id, name: name, parentEventId: event.id, parentSponsorId: sponsor.id, imageURL: url, adType: type)
        self.parentEvent = event
        self.parentSponsor = sponsor
    }
    
    init(id:String, name:String, parentEventId event: String, parentSponsorId sponsor: String, imageURL url: String, adType type: AdType) {
        super.init()
        self.id = id
        self.name = name
        self.parentEventId = event
        self.parentSponsorId = sponsor
        self.imageUrl = url
        self.type = type
        makeImageRequest()
    }
    
    static var parseType: ((String) -> AdType) = { type in
        return type == "Banner Ad" ? AdType.banner : type == "Splash Screen Ad" ? AdType.splashScreen : AdType.none
    }
    
    func makeImageRequest() {
        requestImage(URLString: imageUrl) { image in
            if let image = image {
                self.image = image
            }
        }
    }
    
    func makeImageRequest(callback: @escaping (UIImage?) -> Void) {
        requestImage(URLString: imageUrl) { image in
            if let image = image {
                self.image = image
            }
            return callback(self.image)
        }
    }
    
    /**
     A splash ad is presented no more than once every hour. This function determines whether or not
     the ad should be displayed.
     
     - returns: `true` if the current date and time is passed the date and time the ad was presented - `false` if not.
    */
    func shouldPresent() -> Bool {
        if let presentedAt = presentedAt {
            let expirationDate = Date(timeInterval: SponsorAd.presentationSleepLength, since: presentedAt)
            return Date().isGreaterThanDate(expirationDate)
        }
        return false
    }
    
}
