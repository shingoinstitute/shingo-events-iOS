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
    private var image : UIImage?
    
    init() {
        name = ""
        id = ""
        image = nil
    }
    
    private func requestImage(url : String, callback: (image : UIImage?) -> Void) {
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
        SIRequest().requestAgendaDays(eventId: self.id, callback: { agendas in
            
            guard let agendas = agendas else {
                callback()
                return
            }
            
            self.agendaItems = agendas
            self.didLoadAgendaSessions = true
            
            callback()
        });
    }
    
    func requestBannerImage() {
        requestImage(bannerImageURL) { image in
            if let image = image as UIImage? {
                self.image = image
            }
        }
    }
    
    func getBannerImage() -> UIImage {
        guard let image = self.image else {
            requestBannerImage()
            return UIImage()
        }
        
        return image
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
        SIRequest().requestAgendaDay(agendaId: id) { agenda in
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
    
}


class SISession: SIObject {
    
    var didLoadSpeakers : Bool
    var didLoadSessionInformation : Bool
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
        didLoadSessionInformation = false
        speakers = [SISpeaker]()
        self.displayName = "No Display Name"
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
                
                self.didLoadSessionInformation = true
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
        
        guard let image = self.image else {
            requestSpeakerImage()
            return UIImage(named: "silhouette")!
        }
        
        return image
    }
    
}


class SIExhibitor: SIObject {
    
    var summary : String
    var contactEmail : String
    var website : String
    var logoURL : String
    var bannerURL : String
    var mapCoordinate : (Double, Double)
    private var bannerImage : UIImage?
    
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


class SIHotel: SIObject {
    
    var address : String
    var phone : String
    var website : String
    var associatedEventId : String
    var hotelCode : String
    var travelInformation : String
    var prices : [Double]
    
    
    override init() {
        address = ""
        phone = ""
        website = ""
        associatedEventId = ""
        hotelCode = ""
        travelInformation = ""
        prices = [Double]()
        super.init()
    }
    
}


class SIRecipient: SIObject {
    
    enum AwardType {
        case ShingoPrize,
        Silver,
        Bronze,
        Research,
        Publication,
        None
    }

    var awardType : AwardType
    var organization : String
    var photoList : String //Comma separated list of URLs to photos
    var videoList : String //Comma separated list of URLs to videos
    var pressRelease : String
    var profile : String
    var summary : String
    var logoURL : String {
        didSet {
            requestRecipientImage(self.logoURL)
        }
    }

    override init() {
        awardType = AwardType.None
        organization = ""
        logoURL = ""
        photoList = ""
        videoList = ""
        pressRelease = ""
        profile = ""
        summary = ""
        super.init()
    }
    
    func requestRecipientImage(url:String) {
        requestImage(url) { image in
            guard let image = image else {
                self.image = UIImage(named: "logoComingSoon500x500")
                return
            }
            
            self.image = image
        }
    }
    
    func getRecipientImage() -> UIImage {
        guard let image = image else {
            return UIImage(named: "logoComingSoon500x500")!
        }
        
        return image
    }
    
    func parsePhotoList() -> [UIImage]? {
        // Needs to be implemented
        return nil
    }
    
    func parseVideoList() -> [String]? {
        // Needs to be implemented
        return nil
    }
    
}

class SIRoom: SIObject {
    
    var mapCoordinate : (Double, Double)
    
    override init() {
        mapCoordinate = (Double(), Double())
        super.init()
    }
    
}


class SISponsor: SIObject {
    
    enum SPONSOR_TYPE : Int {
        case None = 0,
        Friend = 1,
        Supporter = 2,
        Benefactor = 3,
        Champion = 4,
        President = 5
    }

    
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
//    func requestSponsorImage(url:String) {
//        self.requestImage(url) { image in
//            if let image = image as UIImage? {
//                self.logoImage = image
//            }
//        }
//    }
//    
//    func requestBannerImage(url:String) {
//        requestImage(url) { image in
//            if let image = image as UIImage? {
//                self.bannerImage = image
//            }
//        }
//    }
    
}

////////////////////////////////////
// Depracted code below this line //
////////////////////////////////////

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



class SIVenue: SIObject {
    var url:String!
    var rooms : [SIRoom]!
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
    
    private func requestVenueMapImage(url:String) {
        requestImage(url) { image in
            if let image = image as UIImage? {
                self.image = image
            }
        }
    }
    
    func getVenueMapImage() -> UIImage {
        guard let image = image else {
            return UIImage(named: "shingo_icon_skinny")!
        }
        
        if image.isEmpty() {
            return UIImage(named: "shingo_icon_skinny")!
        }
        
        return image
    }
    
    func getRooms() {
        // Needs to be implemented
    }
}





