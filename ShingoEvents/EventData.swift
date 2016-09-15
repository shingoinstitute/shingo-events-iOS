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


class SIObject : AnyObject {
    
    var name : String
    var id : String
    private var image : UIImage?
    var didLoadImage: Bool
    
    init() {
        name = ""
        id = ""
        image = nil
        didLoadImage = false
    }
    
    private func requestImage(url : String, callback: (image : UIImage?) -> Void) {
        Alamofire.request(.GET, url).responseImage { response in
            
            guard let image = response.result.value else {
                print("Warning, image download failed. Requested from \(url), for SIObject \"\(self.name)\".")
                callback(image: nil)
                return
            }
        
            print("Image Downloaded; \(image.fileSizeOfPNG())kb recieved; width: \(Int(image.size.width)), height: \(Int(image.size.height)); Type: \(Mirror(reflecting: self).subjectType).")
            callback(image: image)
        }
    }
}


class SIEvent: SIObject {
    
    var didLoadSpeakers : Bool
    var didLoadEventData : Bool
    var didLoadSessions : Bool
    var didLoadAgendas : Bool
    var didLoadVenues : Bool
    var didLoadRecipients : Bool
    var didLoadAffiliates : Bool
    var didLoadExhibitors : Bool
    var didLoadSponsors : Bool
    
    // related objects
    var speakers : [String:SISpeaker] // Speakers are stored in a dictionary to prevent duplicate speakers from appearing that may be recieved from the API response
    var agendaItems : [SIAgenda]
    var venues : [SIVenue]
    var recipients : [SIRecipient]
    var affiliates : [SIAffiliate]
    var exhibitors : [SIExhibitor]
    var sponsors : [SISponsor]
    
    // event specific properties
    var startDate : NSDate
    var endDate : NSDate
    var eventType : String
    var salesText : String
    var bannerURL : String {
        didSet {
            requestBannerImage() {}
        }
    }
    
    override init() {
        didLoadSpeakers = false
        didLoadEventData = false
        didLoadSessions = false
        didLoadAgendas = false
        didLoadVenues = false
        didLoadRecipients = false
        didLoadAffiliates = false
        didLoadExhibitors = false
        didLoadSponsors = false
        speakers = [String:SISpeaker]() // key = speaker's name, value = SISpeaker object
        agendaItems = [SIAgenda]()
        venues = [SIVenue]()
        recipients = [SIRecipient]()
        affiliates = [SIAffiliate]()
        exhibitors = [SIExhibitor]()
        sponsors = [SISponsor]()
        startDate = NSDate.notionallyEmptyDate()
        endDate = NSDate.notionallyEmptyDate()
        salesText = ""
        eventType = ""
        bannerURL = ""
        super.init()
    }
    
    // Requests for information on event objects.
    func requestEvent(callback: (() -> Void)?) {
        didLoadEventData = false
        SIRequest().requestEvent(eventId: id) { (event) in
            if let event = event {
                self.didLoadEventData = true
                self.speakers = event.speakers
                self.agendaItems = event.agendaItems
                self.venues = event.venues
                self.recipients = event.recipients
                self.affiliates = event.affiliates
                self.exhibitors = event.exhibitors
                self.sponsors = event.sponsors
                self.startDate = event.startDate
                self.endDate = event.endDate
                self.salesText = event.salesText
                self.eventType = event.eventType
                self.bannerURL = event.bannerURL
            }
            
            if let cb = callback {
                cb()
            }
        }
    }
    
    func requestSpeakers(callback:() -> ()) {
        SIRequest().requestSpeakers(eventId: id) { (speakers) in
            if let speakers = speakers {
                for speaker in speakers {
                    self.speakers[speaker.name] = speaker //Adds speakers to dictionary object
                }
                self.didLoadSpeakers = true
            }
            callback()
        }
    }
    
    func requestAgendas(callback: () -> ()) {
        SIRequest().requestAgendaDays(eventId: self.id, callback: { agendas in
            
            guard let agendas = agendas else {
                callback()
                return
            }
            
            self.agendaItems = agendas
            self.didLoadAgendas = true
            
            callback()
        });
    }
    
    func requestVenues(callback: () -> ()) {
        SIRequest().requestVenues(eventId: self.id, callback: { (venues) in
            guard let venues = venues else {
                callback()
                return
            }
            
            self.venues = venues
            self.didLoadVenues = true
            
            for venue in self.venues {
                venue.requestVenueInformation()
            }
            
            callback()
        });
    }
    
    func requestRecipients(callback: () -> ()) {
        SIRequest().requestRecipients(eventId: self.id) { (recipients) in
            guard let recipients = recipients else {
                callback()
                return
            }
            
            self.recipients = recipients
            self.didLoadRecipients = true
            
            callback()
        }
    }
    
    func requestAffiliates(callback: () -> ()) {
        SIRequest().requestAffiliates { (affiliates) in
            guard let affiliates = affiliates else {
                callback()
                return
            }
            
            self.affiliates = affiliates
            self.didLoadAffiliates = true
            
            callback()
        }
    }
    
    func requestExhibitors(callback: () -> ()) {
        SIRequest().requestExhibitors(eventId: self.id) { (exhibitors) in
            guard let exhibitors = exhibitors else {
                callback()
                return
            }
            
            self.exhibitors = exhibitors
            self.didLoadExhibitors = true
            
            callback()
        }
    }
    
    func requestSponsors(callback: () -> ()) {
        SIRequest().requestSponsors(eventId: self.id) { (sponsors) in
            guard let sponsors = sponsors else {
                callback()
                return
            }
            
            self.sponsors = sponsors
            self.didLoadSponsors = true
            
            callback()
        }
    }
    
    private func requestBannerImage(callback: (() -> Void)?) {
        
        if self.image != nil {
            if let cb = callback {
                cb()
            }
            return
        }
        
        if bannerURL.isEmpty {
            if let cb = callback {
                cb()
            }
            return
        }
        
        requestImage(bannerURL) { image in
            if let image = image as UIImage? {
                self.image = image
                self.didLoadImage = true
            }
            if let cb = callback {
                cb()
            }
        }
    }
    
    func getBannerImage(callback: (image: UIImage?) -> Void) {
        if let image = self.image {
            callback(image: image)
            return
        }
        
        requestBannerImage() {
            if let image = self.image {
                callback(image: image)
            } else {
                callback(image: nil)
            }
        }
    }
    
}


// An Event Day
class SIAgenda: SIObject {
    
    var didLoadSessions : Bool
    
    // related objects
    var sessions : [SISession]
    
    // agenda specific properties
    var displayName : String
    var date : NSDate
    
    override init() {
        didLoadSessions = false
        sessions = [SISession]()
        displayName = ""
        date = NSDate.notionallyEmptyDate()
        super.init()
    }
    
    /// Gets session information for SIAgenda object using an agenda ID.
    func requestAgendaSessions(callback: () -> ()) {
        
        switch id.isEmpty {
        case true:
            callback()
        case false:
            SIRequest().requestSessions(agendaId: id, callback: { sessions in
                
                if let sessions = sessions {
                    self.sessions = sessions
                    self.didLoadSessions = true
                }
                
                callback()
            });
        }
    }

}


class SISession: SIObject {
    
    enum SessionType: String {
        case Break = "Break",
        Concurrent = "Concurrent",
        Gemba = "Gemba",
        Keynote = "Keynote",
        Meal = "Meal",
        Social = "Social",
        Tour = "Tour",
        FullDayWorkshop = "Full Day Workshop",
        HalfDayWorkshop = "Half Day Workshop",
        MultiDayWorkshop = "Multi Day Workshop",
        None = "Session"
    }
    
    var didLoadSpeakers : Bool
    var didLoadSessionInformation : Bool
    var speakers : [SISpeaker]
    
    // Used for a displaying property in a UITableViewCell
    var isSelected: Bool
    
    var displayName : String
    var sessionType : SessionType
    var sessionTrack : String
    var summary : String
    var room : SIRoom?
    var startDate : NSDate
    var endDate : NSDate
    
    override init() {
        didLoadSpeakers = false
        didLoadSessionInformation = false
        speakers = [SISpeaker]()
        displayName = ""
        startDate = NSDate.notionallyEmptyDate()
        endDate = NSDate.notionallyEmptyDate()
        sessionType = .None
        sessionTrack = ""
        summary = ""
        isSelected = false
        room = nil
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
                
                self.requestSpeakers() {
                    self.didLoadSessionInformation = true
                    callback()
                }
            }
        });
    }
    
    /// Gets all speakers associated with the session object.
    private func requestSpeakers(callback: () -> ()) {
        SIRequest().requestSpeakers(sessionId: id, callback: { speakers in
            if let speakers = speakers {
                self.speakers = speakers
                self.didLoadSpeakers = true
            }
            callback()
        });
    }
    
    func parseSessionType(type: String) -> SessionType {
        switch type {
            case "Break":
                return .Break
            case "Concurrent":
                return .Concurrent
            case "Gemba":
                return .Gemba
            case "Keynote":
                return .Keynote
            case "Meal":
                return .Meal
            case "Social":
                return .Social
            case "Tour":
                return .Tour
            case "Full Day Workshop":
                return .FullDayWorkshop
            case "Half Day Workshop":
                return .HalfDayWorkshop
            case "Multi Day Workshop":
                return .MultiDayWorkshop
            default:
                return .None
        }
    }
    
}


class SISpeaker: SIObject {
    
    enum SpeakerType: String {
        case Keynote = "Keynote",
        Concurrent = "Concurrent",
        None = ""
    }
    
    // related object id's
    var associatedSessionIds : [String]
    
    // speaker specific properties
    var title : String
    var pictureURL : String /*{
        didSet {
            if !pictureURL.isEmpty {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                    self.requestSpeakerImage(nil)
                })
            }
        }
    }*/
    var biography : String
    var organizationName : String
    var contactEmail : String
    var speakerType: SpeakerType
    
    override init() {
        title = ""
        pictureURL = ""
        biography = ""
        organizationName = ""
        contactEmail = ""
        speakerType = .None
        associatedSessionIds = [String]()
        super.init()
    }
    
    /// Gets additional information about the speaker object.
    private func requestSpeakerInformation(callback: () -> ()) {
        SIRequest().requestSpeaker(speakerId: id) { (speaker) in
            if let speaker = speaker {
                
                self.name = speaker.name
                self.id = speaker.id
                
                self.title = speaker.title
                if self.pictureURL.isEmpty {
                    self.pictureURL = speaker.pictureURL
                }
                self.biography = speaker.biography
                self.organizationName = speaker.organizationName
                self.contactEmail = speaker.contactEmail
//                self.isKeynoteSpeaker = speaker.isKeynoteSpeaker
                self.associatedSessionIds = speaker.associatedSessionIds
            }
        }
    }
    
    private func requestSpeakerImage(callback: (() -> Void)?) {
        
        if image != nil || pictureURL.isEmpty{
            if let cb = callback { cb() }
            return
        }
        
        requestImage(pictureURL, callback: { image in
            if let image = image as UIImage? {
                self.image = image
                self.didLoadImage = true
            }
            
            if let cb = callback { cb() }
        });
    }
    
    func getSpeakerImage(callback: (UIImage) -> Void) {
        
        guard let image = self.image else {
            requestSpeakerImage() {
                if let image = self.image {
                    callback(image)
                } else if let image = UIImage(named: "silhouette") {
                    callback(image)
                } else {
                    callback(UIImage())
                }
            }
            return
        }
        
        callback(image)
        
    }
    
    private func getMiddleInitial() -> [String] {
        if let fullname = name.split(" ") {
            
            var middle = [String]()
            
                for n in fullname {
                    if n != name.first! || n != name.last! {
                        middle.append(String(n.characters.first!).uppercaseString)
                    }
                }
            
            return middle
        } else {
            return [""]
        }
    }
    
    /// Returns name in format of: "lastname, firstname M.I."
    func getFormattedName() -> String {
        
        var formattedName = name.first! + ", " + name.last!
        for mi in getMiddleInitial() {
            formattedName += " \(mi) "
        }
        
        return formattedName
    }
    
}


class SIExhibitor: SIObject {
    
    var summary : String
    var contactEmail : String
    var website : String
    var logoURL : String {
        didSet {
            requestExhibitorLogoImage(nil)
        }
    }
    var bannerURL : String {
        didSet {
            requestExhibitorBannerImage(nil)
        }
    }
    var didLoadBannerImage: Bool
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
        didLoadBannerImage = false
        super.init()
    }
    
    private func requestExhibitorLogoImage(callback: (() -> Void)?) {
        
        if image != nil || logoURL.isEmpty{
            if let cb = callback { cb() }
            return
        }
        
        requestImage(logoURL, callback: { image in
            if let image = image as UIImage? {
                self.image = image
                self.didLoadImage = true
            }
            
            if let cb = callback { cb() }
        });
    }
    
    private func requestExhibitorBannerImage(callback: (() -> Void)?) {
        
        if bannerImage != nil || bannerURL.isEmpty {
            if let cb = callback {
                cb()
            }
            return
        }
        
        requestImage(bannerURL, callback: { image in
            if let image = image {
                self.bannerImage = image
                self.didLoadBannerImage = true
            }
            
            if let cb = callback {
                cb()
            }
        });
    }
    
    func getLogoImage(callback: (image: UIImage) -> ()) {
        
        guard let image = self.image else {
            requestExhibitorLogoImage() {
                if let image = self.image {
                    callback(image: image)
                } else if let image = UIImage(named: "logoComingSoon") {
                    callback(image: image)
                } else {
                    callback(image: UIImage())
                }
            }
            return
        }
        
        callback(image: image)
    }
    
    func getBannerImage(callback: (image: UIImage) -> ()) {
        
        guard let image = self.bannerImage else {
            requestExhibitorBannerImage() {
                if let image = self.image {
                    callback(image: image)
                } else if let image = UIImage(named: "logoComingSoon") {
                    callback(image: image)
                } else {
                    callback(image: UIImage())
                }
            }
            return
        }
        
        callback(image: image)
        
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
    
    enum AwardType: String {
        case ShingoPrize = "Shingo Prize",
        Silver = "Silver Medallion",
        Bronze = "Bronze Medallion",
        Research = "Research Award",
        Publication = "Publication Award",
        None = "N/A"
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
            requestRecipientImage(nil)
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

    convenience init(name: String, type: AwardType) {
        self.init()
        self.name = name
    }
    
    private func requestRecipientImage(callback: (() -> Void)?) {
        
        if image != nil || logoURL.isEmpty {
            if let cb = callback { cb() }
            return
        }
        
        requestImage(logoURL) { image in
            if let image = image {
                self.image = image
                self.didLoadImage = true
            }
            if let cb = callback { cb() }
        }
        
    }
    
    func getRecipientImage(callback: (UIImage) -> Void) {
        
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

class SIRoom: SIObject {
    
    var mapCoordinate : (Double, Double)
    var floor: String
    var associatedVenueID: String
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
    override init() {
        mapCoordinate = (Double(), Double())
        floor = ""
        associatedVenueID = ""
        super.init()
    }
    
}


class SISponsor: SIObject {
    
    enum SponsorType : Int {
        case None = 0,
        Friend = 1,
        Supporter = 2,
        Benefactor = 3,
        Champion = 4,
        President = 5
    }
    
    var summary : String
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
    
    convenience init(name: String, id: String, sponsorType: SponsorType, summary: String, logoURL: String, bannerURL: String) {
        self.init()
        self.name = name
        self.id = id
        self.sponsorType = sponsorType
        self.summary = summary
        self.logoURL = logoURL
        self.bannerURL = bannerURL
    }
    
    override init() {
        sponsorType = .None
        summary = ""
        logoURL = ""
        bannerURL = ""
        splashScreenURL = ""
        bannerImage = nil
        splashScreenImage = nil
        didLoadBannerImage = false
        didLoadSplashScreen = false
        super.init()
    }
    
    convenience init(name: String, type: SponsorType) {
        self.init()
        self.name = name
        self.sponsorType = type
    }
    
    private func requestLogoImage(callback: (() -> Void)?) {
        
        if image != nil || logoURL.isEmpty {
            if let cb = callback { cb() }
            return
        }
        
        self.requestImage(logoURL) { image in
            if let image = image {
                self.image = image
                self.didLoadImage = true
            }
            if let cb = callback { cb() }
        }
    }
    
    private func requestBannerImage(callback: (() -> Void)?) {
        
        if bannerImage != nil || bannerURL.isEmpty {
            if let cb = callback { cb() }
            return
        }
        
        requestImage(bannerURL) { image in
            if let image = image as UIImage? {
                self.bannerImage = image
                self.didLoadBannerImage = true
            }
            if let cb = callback {
                cb()
            }
        }
    }
    
    private func requestSplashScreenImage(callback: (() -> Void)?) {
        
        if splashScreenImage != nil || splashScreenURL.isEmpty {
            if let cb = callback { cb() }
            return
        }
        
        requestImage(splashScreenURL, callback: { image in
            if let image = image {
                self.splashScreenImage = image
                self.didLoadSplashScreen = true
            }
            if let cb = callback {
                cb()
            }
        });
    }
    
    func getBannerImage(callback: (image: UIImage) -> ()) {
        
        if let image = self.bannerImage {
            callback(image: image)
            return
        }
        
        requestBannerImage() {
            if let image = self.image {
                callback(image: image)
            } else if let image = UIImage(named: "Shingo Icon Small") {
                callback(image: image)
            } else {
                callback(image: UIImage())
            }
        }
    }
    
    func getLogoImage(callback: (image: UIImage) -> ()) {
        
        if let image = self.image {
            callback(image: image)
            return
        }
        
        requestLogoImage {
            if let image = self.image {
                callback(image: image)
            } else if let image = UIImage(named: "sponsor_banner_pl") {
                callback(image: image)
            } else {
                callback(image: UIImage())
            }
        }
    }
    
    func getSplashScreenImage(callback: (image: UIImage) -> ()) {
        
        if let image = self.splashScreenImage {
            callback(image: image)
            return
        }
        
        requestSplashScreenImage { 
            if let image = self.image {
                callback(image: image)
            } else if let image = UIImage(named: "Sponsor_Splash_Screen_pl") {
                callback(image: image)
            } else {
                callback(image: UIImage())
            }
        }
    }
}

class SIVenue: SIObject {
    enum VenueType : Int {
        case None = 0,
        ConventionCenter = 1,
        Hotel = 2,
        Museum = 3,
        Restaurant = 4,
        Other = 5
    }
    
    var didLoadVenue : Bool
    var address : String
    var location : CLLocationCoordinate2D?
    var venueType : VenueType
    var venueMaps : [SIVenueMap]
    
    override init() {
        didLoadVenue = false
        address = ""
        venueMaps = [SIVenueMap]()
        location = nil
        venueType = .None
        super.init()
    }
    
    func requestVenueInformation() {
        SIRequest().requestVenue(venueId: self.id) { (venue) in
            if let venue = venue {
                self.id = venue.id
                self.name = venue.name
                self.address = venue.address
                self.location = venue.location
                self.venueType = venue.venueType
                self.venueMaps = venue.venueMaps
            }
            self.didLoadVenue = true
        }
    }
    
//    func getVenueMapImages() -> [UIImage] {
//        var maps = [UIImage]()
//        for map in self.venueMaps {
//            map.getVenueMapImage() { image in
//                maps.append(image)
//            }
//        }
//        return maps
//    }
    
}

class SIVenueMap: SIObject {
    
    var mapURL : String {
        didSet {
            requestVenueMapImage(nil)
        }
    }
    var floor : Int
    
    override init() {
        mapURL = ""
        floor = -1
        super.init()
    }
    
    func getVenueMapImage(callback: (UIImage) -> Void) {
        
        guard let image = self.image else {
            requestVenueMapImage() {
                if let image = self.image {
                    callback(image)
                } else if let image = UIImage(named: "mapNotAvailable") {
                    callback(image)
                } else {
                    callback(UIImage())
                }
            }
            return
        }
        
        callback(image)
    }
    
    private func requestVenueMapImage(callback: (() -> Void)?) {
        
        if image != nil || mapURL.isEmpty {
            if let cb = callback { cb() }
        } else {
            self.requestImage(mapURL) { (image) in
                if let image = image {
                    self.image = image
                    self.didLoadImage = true
                }
                if let cb = callback { cb() }
            }
        }
    }
    
}

class SIAffiliate: SIObject {
    
    var abstract : String
    var summary : String
    var logoURL : String {
        didSet {
            requestAffiliateLogoImage(nil)
        }
    }
    var websiteURL : String
    var pagePath : String
    
    override init() {
        abstract = ""
        summary = ""
        logoURL = ""
        websiteURL = ""
        pagePath = ""
        super.init()
    }
    
    private func requestAffiliateLogoImage(callback: (() -> Void)?) {
        
        if logoURL.isEmpty || image != nil {
            if let cb = callback { cb() }
        }
        
        requestImage(logoURL) { (image) in
            if let image = image {
                self.image = image
                self.didLoadImage = true
            }
            
            if let cb = callback { cb() }
        }
    }
    
    func getLogoImage(callback: (UIImage) -> ()) {
        
        guard let image = self.image else {
            requestAffiliateLogoImage() {
                if let image = self.image {
                    callback(image)
                } else if let image = UIImage(named: "Shingo Icon Small") {
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



