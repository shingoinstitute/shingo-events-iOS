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
    
    var name : String
    var id : String
    var image : UIImage?
    
    init() {
        name = ""
        id = ""
        image = nil
    }
    
    func requestImage(url : String, callback: (image : UIImage?) -> Void) {
        Alamofire.request(.GET, url).responseImage { response in
            
            guard let image = response.result.value else {
                print("Warning, image download failed. Requested from \(url), for SIObject \"\(self.name)\".")
                callback(image: nil)
                return
            }
        
            print("Success! Image downloaded, size: \(image.size.width)x\(image.size.height)")
            callback(image: image)
        }
    }
}

class SIEvent: SIObject {
    
    var didLoadEventData : Bool
    var didLoadSessions : Bool
    var didLoadAgendaSessions : Bool
    
    // related objects
    var agendaItems : [SIAgenda]
    
    
    // event specific properties
    var startDate : NSDate
    var endDate : NSDate
    var eventType : String
    var salesText : String
    var bannerImageURL : String {
        didSet {
            if !bannerImageURL.isEmpty {
                requestBannerImage()
            }
        }
    }
    
    override init() {
        didLoadEventData = false
        didLoadSessions = false
        didLoadAgendaSessions = false
        agendaItems = [SIAgenda]()
        startDate = NSDate().notionallyEmptyDate()
        endDate = NSDate().notionallyEmptyDate()
        salesText = ""
        eventType = ""
        bannerImageURL = ""
        super.init()
    }
    
    /// Gets basic information about an events agenda objects.
    func requestAgendas(callback: () -> ()) {
        SIRequest().requestAgendaDays(eventId: id, callback: { agendas in
            
            if let agendas = agendas {
                self.didLoadAgendaSessions = true
                self.agendaItems = agendas
                
                for agenda in agendas {
                    agenda.requestAgendaInformation() {
                        
                    }
                }
                callback()
            }
            
        });
    }
    
    func requestBannerImage() {
        requestImage(bannerImageURL) { image in
            if let image = image as UIImage? {
                self.image = image
            }
        }
    }
    
}

// An Event Day
class SIAgenda: SIObject {
    
    // related objects
    var sessions : [SISession]
    
    // agenda specific properties
    var displayName : String
    var date : NSDate
    
    override init() {
        sessions = [SISession]()
        displayName = ""
        date = NSDate().notionallyEmptyDate()
        super.init()
    }
    
    /// Gets additional information about agenda object.
    func requestAgendaInformation(callback: () -> ()) {
        SIRequest().requestAgendaDay(agendaId: id) { (agenda) in
            if let agenda = agenda {
                self.displayName = agenda.displayName
                self.date = agenda.date
                self.name = agenda.name
                self.id = agenda.id
            }
            callback()
        }
        requestSessionsForDay()
    }
    
    private func requestSessionsForDay() {
        SIRequest().requestSessions(agendaId: id, callback: { sessions in
            
            if let sessions = sessions {
                self.sessions = sessions
            }
            
        });
    }
    
    func isOnLaterDay(eventDay: SIAgenda) -> Bool {
        // Needs implementation
        return false
    }
    
}

class SISession: SIObject {
    
    var didLoadSpeakers : Bool
    var speakers : [SISpeaker]
    
    var displayName : String
    var sessionType : String
    var sessionTrack : String
    var summary : String
    var room : String
    var startDate : NSDate
    var endDate : NSDate
    
    override init() {
        didLoadSpeakers = false
        speakers = [SISpeaker]()
        displayName = ""
        startDate = NSDate().notionallyEmptyDate()
        endDate = NSDate().notionallyEmptyDate()
        sessionType = ""
        sessionTrack = ""
        summary = ""
        room = ""
        super.init()
    }
    
    /// Gets additional information about the session object.
    func requestSessionInformation(callback:() -> ()) {
        SIRequest().requestSession(id, callback: { session in
            if let session = session {
                self.displayName = session.displayName
                self.startDate = session.startDate
                self.endDate = session.endDate
                self.sessionType = session.sessionType
                self.sessionTrack = session.sessionTrack
                self.summary = session.summary
                self.room = session.room
                self.name = session.name
                self.id = session.id
            }
        });
    }
    
    /// Gets all speakers associated with the session object.
    func requestSpeakers(callback: () -> ()) {
        SIRequest().requestSpeakers(sessionId: id) { (speakers) in
            if let speakers = speakers {
                self.speakers = speakers
            }
        }
    }
    
}

class SISpeaker: SIObject {
    
    // related object id's
    var associatedSessionIds : [String]
    
    // speaker specific properties
    var title : String
    var pictureURL : String {
        didSet {
            if !pictureURL.isEmpty {
                requestSpeakerImage()
            }
        }
    }
    var biography : String
    var organization : String
    
    override init() {
        title = ""
        pictureURL = ""
        biography = ""
        organization = ""
        associatedSessionIds = [String]()
        super.init()
    }
    
    /// Gets additional information about the speaker object.
    func requestSpeakerInformation(callback: () -> ()) {
        SIRequest().requestSpeaker(speakerId: id) { (speaker) in
            if let speaker = speaker {
                self.title = speaker.title
                
                if self.pictureURL.isEmpty {
                    self.pictureURL = speaker.pictureURL
                }
                
                self.biography = speaker.biography
                self.organization = speaker.organization
                self.associatedSessionIds = speaker.associatedSessionIds
                self.name = speaker.name
                self.id = speaker.id
            }
        }
    }
    
    func requestSpeakerImage() {
        requestImage(pictureURL) { image in
            if let image = image as UIImage? {
                self.image = image
            }
        }
    }
    
    func getSpeakerImage() -> UIImage {
        if let image = self.image {
            return image
        } else {
            return UIImage(named: "silhouette")!
        }
    }
    
}

class SIExhibitor: SIObject {
    
    var summary : String
    var contactEmail : String
    var website : String
    var logoURL : String
    var bannerURL : String
    var mapCoordinate : (Double, Double)
    var bannerImage : UIImage?
    
    override init() {
        summary = ""
        contactEmail = ""
        website = ""
        logoURL = ""
        bannerURL = ""
        mapCoordinate = (0, 0)
        bannerImage = nil
        super.init()
    }
    
    func requestExhibitorLogoImage(url:String) {
        requestImage(url) { image in
            if let image = image as UIImage? {
                self.image = image
            }
        }
    }
    
    func requestExhibitorBannerImage(url: String) {
        requestImage(url, callback: { image in
            if let image = image as UIImage? {
                self.bannerImage = image
            }
        });
    }
    
    func getLogoImage() -> UIImage {
        guard let image = self.image else {
            return UIImage(named: "logoComingSoon")!
        }
        
        if image.isEmpty() {
            return UIImage(named: "logoComingSoon")!
        }
        
        return image
    }
    
    func getBannerImage() -> UIImage {
        guard let image = self.bannerImage else {
            return UIImage(named: "logoComingSoon")!
        }
        
        if image.isEmpty() {
            return UIImage(named: "logoComingSoon")!
        }
        
        return image
    }
    
}

/////////////////
// got to here //
/////////////////

struct SIRecipients {
    var shingoPrizeRecipients: [SIRecipient]?
    var silverRecipients: [SIRecipient]?
    var bronzeRecipients: [SIRecipient]?
    var researchRecipients: [SIRecipient]?
    
    init() {
        shingoPrizeRecipients = nil
        silverRecipients = nil
        bronzeRecipients = nil
        researchRecipients = nil
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
        requestImage(url) { image in
            if let image = image as UIImage? {
                self.logoBookCoverImage = image
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
    
    func requestAffiliateImage(url:String) {
        requestImage(url) { image in
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
    
    func requestSponsorImage(url:String) {
        self.requestImage(url) { image in
            if let image = image as UIImage? {
                self.logoImage = image
            }
        }
    }
    
    func requestBannerImage(url:String) {
        requestImage(url) { image in
            if let image = image as UIImage? {
                self.bannerImage = image
            }
        }
    }
}


class SIVenue: SIObject {
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
        requestImage(url) { image in
            if let image = image as UIImage? {
                self.image = image
            }
        }
    }
}





