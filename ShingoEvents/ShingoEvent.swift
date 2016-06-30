////
////  Event.swift
////  Shingo Events
////
////  Created by Craig Blackburn on 1/7/16.
////  Copyright © 2016 Shingo Institute. All rights reserved.
////
//
//import Foundation
//import Alamofire
//import AlamofireImage
//import MapKit
//
//
//class SIObject {
//
//    var name : String!
//    var id : String!
//    var image : UIImage?
//
//    init() {
//        name = ""
//        id = ""
//        image = nil
//    }
//    
//    func getImage(url : String, callback: (image : UIImage?) -> Void) {
//        Alamofire.request(.GET, url).responseImage { response in
//            if let image = response.result.value {
//                print("Success! Image downloaded, size: \(image.size.width)x\(image.size.height)")
//                callback(image: image)
//            } else {
//                print("WARNING Image download failed\nRequest from \(url), for SIObject \"\(self.name)\".")
//                callback(image: nil)
//            }
//        }
//    }
//}
//
//class SIEvent: SIObject {
//    
//    var didLoadSessions : Bool!
//    
//    // related objects
//    var agendaItems : [SIAgenda]!
//    
//    
//    // event specific properties
//    var startDate : NSDate!
//    var endDate : NSDate!
//    var eventType : String!
//    var salesText : String!
//    var bannerImageURL : String! {
//        didSet {
//            if !bannerImageURL.isEmpty {
//                requestBannerImage()
//            }
//        }
//    }
//    
//    override init() {
//        super.init()
//        didLoadSessions = false
//        startDate = NSDate().notionallyEmptyDate()
//        endDate = NSDate().notionallyEmptyDate()
//        salesText = ""
//        eventType = ""
//        bannerImageURL = ""
//    }
//    
//    func requestBannerImage() {
//        getImage(bannerImageURL) { image in
//            if let image = image as UIImage? {
//                self.image = image
//            }
//        }
//    }
//    
//}
//
//// An Event "day"
//class SIAgenda: SIObject {
//    
//    // related objects
//    var sessions : [SISession]!
//    
//    // agenda specific properties
//    var displayName : String!
//    var date : NSDate!
//    
//    override init() {
//        super.init()
//        sessions = [SISession]()
//        displayName = ""
//        date = NSDate().notionallyEmptyDate()
//    }
//    
//    func isOnLaterDay(eventDay: SIAgenda) -> Bool {
//        // Needs implementation
//        return false
//    }
//    
//}
//
//class SISession: SIObject {
//    
//    var sessionSpeakers : [SISpeaker]!
//    
//    var displayName : String!
//    var startDate : NSDate!
//    var endDate : NSDate!
//    var sessionType : String!
//    var sessionTrack : String!
//    var summary : String!
//    var room : String!
//    
//    override init() {
//        super.init()
//        displayName = ""
//        startDate = NSDate().notionallyEmptyDate()
//        endDate = NSDate().notionallyEmptyDate()
//        sessionType = ""
//        sessionTrack = ""
//        summary = ""
//        room = ""
//    }
//    
//}
//
//class SISpeaker: SIObject {
//    
//    // related object id's
//    var associatedSessionIds : [String]!
//    
//    // speaker specific properties
//    var title : String!
//    var pictureURL : String! {
//        didSet {
//            if !pictureURL.isEmpty {
//                requestSpeakerImage()
//            }
//        }
//    }
//    var biography : String!
//    var organization : String!
//    
//    
//    override init() {
//        super.init()
//        title = ""
//        pictureURL = ""
//        biography = ""
//        organization = ""
//        associatedSessionIds = [String]()
//    }
//    
//    func requestSpeakerImage() {
//        getImage(pictureURL) { image in
//            if let image = image as UIImage? {
//                self.image = image
//            }
//        }
//    }
//    
//}
//
//
//////////////////////////////
//// got to here
//////////////////////////////
//
//
//class SIRecipient: SIObject {
//    
//    enum RecipientType {
//        case ShingoAward,
//        Silver,
//        Bronze,
//        Research,
//        NonType
//    }
//    
//    var awardType : RecipientType!
//    var abstract : String!
//    var richAbstract : String?
//    var eventId : String!
//    var award : String!
//    var authors : String!
//    var logoBookCoverUrl : String!
//    var logoBookCoverImage : UIImage!
//    
//    override init() {
//        super.init()
//        awardType = RecipientType.NonType
//        abstract = ""
//        richAbstract = nil
//        eventId = ""
//        award = ""
//        authors = ""
//        logoBookCoverUrl = ""
//        logoBookCoverImage = UIImage(named: "shingo_icon_skinny")
//    }
//    
//    func getRecipientImage(url:String) {
//        getImage(url) { image in
//            if let image = image as UIImage? {
//                self.logoBookCoverImage = image
//            }
//        }
//    }
//    
//}
//
//class SIExhibitor: SIObject {
//    
//    var description:String!
//    var richDescription: String?
//    var phone:String!
//    var email:String!
//    var website:String!
//    var logoUrl:String!
//    var logoImage:UIImage!
//    var eventId:String!
//    
//    override init() {
//        super.init()
//        description = ""
//        richDescription = nil
//        phone = ""
//        email = ""
//        website = ""
//        logoUrl = ""
//        logoImage = UIImage(named: "sponsor_banner_pl")
//        eventId = ""
//    }
//    
//    func getExhibitorImage(url:String) {
//        getImage(url) { image in
//            if let image = image as UIImage? {
//                self.logoImage = image
//            }
//        }
//    }
//    
//}
//
//
//class SIAffiliate: SIObject {
//    
//    var abstract:String!
//    var richAbstract: String?
//    var logoUrl:String!
//    var logoImage:UIImage!
//    var websiteUrl:String!
//    var phone:String!
//    var email:String!
//    
//    override init() {
//        super.init()
//        abstract = ""
//        richAbstract = nil
//        logoUrl = ""
//        logoImage = UIImage()
//        websiteUrl = ""
//        phone = ""
//        email = ""
//    }
//    
//    func getAffiliateImage(url:String) {
//        getImage(url) { image in
//            if let image = image as UIImage? {
//                self.logoImage = image
//            }
//        }
//    }
//    
//}
//
//class SISponsor: SIObject {
//    
//    enum SPONSOR_TYPE {
//        case Friend,
//        Supporter,
//        Benefactor,
//        Champion,
//        President,
//        NonType
//    }
//    
//    var sponsorType:SPONSOR_TYPE!
//    var mdfAmount:Double!
//    var logoUrl:String!
//    var logoImage:UIImage!
//    var bannerUrl:String!
//    var bannerImage:UIImage!
//    var level:String!
//    var eventId:String!
//    
//    override init() {
//        super.init()
//        sponsorType = .NonType
//        mdfAmount = 0.0
//        logoUrl = ""
//        logoImage = UIImage(named: "sponsor_banner_pl")
//        bannerUrl = ""
//        bannerImage = UIImage(named: "sponsor_banner_pl")
//        level = ""
//        eventId = ""
//    }
//    
//    func getSponsorImage(url:String) {
//        self.getImage(url) { image in
//            if let image = image as UIImage? {
//                self.logoImage = image
//            }
//        }
//    }
//    
//    func getBannerImage(url:String) {
//        getImage(url) { image in
//            if let image = image as UIImage? {
//                self.bannerImage = image
//            }
//        }
//    }
//}
//
//class SIVenue: SIObject {
//    var url:String!
//    
//    override init() {
//        super.init()
//        self.url = ""
//        self.image = UIImage()
//    }
//    
//    convenience init(name: String, url:String) {
//        self.init()
//        self.name = name
//        self.url = url
//    }
//    
//    func getVenueMapImage(url:String) {
//        getImage(url) { image in
//            if let image = image as UIImage? {
//                self.image = image
//            }
//        }
//    }
//}
//
//
//
//
//
