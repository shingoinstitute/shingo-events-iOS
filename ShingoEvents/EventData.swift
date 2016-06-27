//
//  Event.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/7/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import MapKit


class SIObject {
    
    var name : String!
    var id : String!
    
    init() {
        name = ""
        id = ""
    }
    
    func getImage(url : String, callback: (image : UIImage?) -> Void) {
        Alamofire.request(.GET, url).responseImage { response in
            if let image = response.result.value {
                print("Success! Image downloaded, size: \(image.size.width)x\(image.size.height)")
                callback(image: image)
            } else {
                print("WARNING Image download failed\nRequest from \(url), for SIObject \"\(self.name)\".")
                callback(image: nil)
            }
        }
    }
}

class SIEvent: SIObject {
    
    var eventSessions:[SIEventSession]!
    var eventStartDate : NSDate!
    var eventEndDate : NSDate!
    var hostOrganization : String!
    var hostCity : String!
    var eventType : String!
    var eventAgenda : SIEventAgenda!
    var venueMaps : [SIVenueMap]!
    var location : CLLocationCoordinate2D!
    var eventSpeakers : [SISpeaker]!
    var didLoadSessions : Bool!
    
    override init() {
        super.init()
        eventSessions = [SIEventSession]()
        eventStartDate = NSDate().notionallyEmptyDate()
        eventEndDate = NSDate().notionallyEmptyDate()
        hostOrganization = ""
        hostCity = ""
        eventType = ""
        eventAgenda = SIEventAgenda()
        venueMaps = [SIVenueMap]()
        location = CLLocationCoordinate2D()
        eventSpeakers = [SISpeaker]()
        didLoadSessions = false
    }
    
}

class SIEventAgenda: SIObject {

    var agendaArray : [SIEventDay]!
    
    override init() {
        super.init()
        agendaArray = [SIEventDay]()
    }
    
}

class SIEventDay: SIObject {

    var dayOfWeek : String!
    var sessions : [SIEventSession]!
    
    override init() {
        super.init()
        dayOfWeek = ""
        sessions = [SIEventSession]()
    }
    
    func isOnLaterDay(eventDay: SIEventDay) -> Bool {
        if sessions[0].startEndDate.first != sessions[0].startEndDate.first.earlierDate(eventDay.sessions[0].startEndDate.first) {
            return true
        } else {
            return false
        }
    }

}

class SIEventSession: SIObject {

    var abstract : String!
    var startEndDate : SIDateTuple!
    var room : String!
    var notes : String!
    var status : String!
    var time : NSDate!
    var format : String!
    var richAbstract: String?
    var sessionSpeakers : [SISpeaker]!
    var speakerIds : [String]!
    
    override init() {
        super.init()
        abstract = ""
        startEndDate = SIDateTuple()
        room = ""
        notes = ""
        status = ""
        time = NSDate().notionallyEmptyDate()
        format = ""
        richAbstract = nil
        sessionSpeakers = [SISpeaker]()
        speakerIds = [String]()
    }
    
}

class SISpeaker: SIObject {
    
    var title : String!
    var biography : String!
    var imageUrl : String!
    var image : UIImage!
    var displayName : String!
    var organization : String!
    var richBiography : String?
    
    override init() {
        super.init()
        title = ""
        biography = ""
        imageUrl = ""
        image = UIImage(named: "silhouette")
        displayName = ""
        organization = ""
        richBiography = nil
    }
    
    func getSpeakerImage(url:String) {
        getImage(url) { image in
            if let image = image as UIImage? {
                self.image = image
            }
        }
    }
    
}

class SIRecipient: SIObject {
    
    enum RecipientType {
        case ShingoAward,
        Silver,
        Bronze,
        Research,
        NonType
    }

    var awardType : RecipientType!
    var abstract : String!
    var richAbstract : String?
    var eventId : String!
    var award : String!
    var authors : String!
    var logoBookCoverUrl : String!
    var logoBookCoverImage : UIImage!

    override init() {
        super.init()
        awardType = RecipientType.NonType
        abstract = ""
        richAbstract = nil
        eventId = ""
        award = ""
        authors = ""
        logoBookCoverUrl = ""
        logoBookCoverImage = UIImage(named: "shingo_icon_skinny")
    }
    
    func getRecipientImage(url:String) {
        getImage(url) { image in
            if let image = image as UIImage? {
                self.logoBookCoverImage = image
            }
        }
    }
    
}

class SIExhibitor: SIObject {

    var description:String!
    var richDescription: String?
    var phone:String!
    var email:String!
    var website:String!
    var logoUrl:String!
    var logoImage:UIImage!
    var eventId:String!
    
    override init() {
        super.init()
        description = ""
        richDescription = nil
        phone = ""
        email = ""
        website = ""
        logoUrl = ""
        logoImage = UIImage(named: "sponsor_banner_pl")
        eventId = ""
    }
    
    func getExhibitorImage(url:String) {
        getImage(url) { image in
            if let image = image as UIImage? {
                self.logoImage = image
            }
        }
    }
    
}


class SIAffiliate: SIObject {

    var abstract:String!
    var richAbstract: String?
    var logoUrl:String!
    var logoImage:UIImage!
    var websiteUrl:String!
    var phone:String!
    var email:String!
    
    override init() {
        super.init()
        abstract = ""
        richAbstract = nil
        logoUrl = ""
        logoImage = UIImage()
        websiteUrl = ""
        phone = ""
        email = ""
    }
    
    func getAffiliateImage(url:String) {
        getImage(url) { image in
            if let image = image as UIImage? {
                self.logoImage = image
            }
        }
    }
    
}

class SISponsor: SIObject {
    
    enum SPONSOR_TYPE {
        case Friend,
        Supporter,
        Benefactor,
        Champion,
        President,
        NonType
    }
    
    var sponsorType:SPONSOR_TYPE!
    var mdfAmount:Double!
    var logoUrl:String!
    var logoImage:UIImage!
    var bannerUrl:String!
    var bannerImage:UIImage!
    var level:String!
    var eventId:String!
    
    override init() {
        super.init()
        sponsorType = .NonType
        mdfAmount = 0.0
        logoUrl = ""
        logoImage = UIImage(named: "sponsor_banner_pl")
        bannerUrl = ""
        bannerImage = UIImage(named: "sponsor_banner_pl")
        level = ""
        eventId = ""
    }
    
    func getSponsorImage(url:String) {
        self.getImage(url) { image in
            if let image = image as UIImage? {
                self.logoImage = image
            }
        }
    }
    
    func getBannerImage(url:String) {
        getImage(url) { image in
            if let image = image as UIImage? {
                self.bannerImage = image
            }
        }
    }
}

class SIVenueMap: SIObject {
    var image:UIImage!
    var url:String!
    
    override init() {
        super.init()
        self.url = ""
        self.image = UIImage()
    }
    
    convenience init(name: String, url:String) {
        self.init()
        self.name = name
        self.url = url
    }
    
    func getVenueMapImage(url:String) {
        getImage(url) { image in
            if let image = image as UIImage? {
                self.image = image
            }
        }
    }
}





