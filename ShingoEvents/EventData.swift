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
        
            print("Image Downloaded, \(image.fileSizeOfPNG())kb, \(Int(image.size.width))x\(Int(image.size.height)), \(Mirror(reflecting: self).subjectType)")
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
            requestBannerImage() { image in
                if let image = image {
                    self.image = image
                }
            }
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
        startDate = NSDate().notionallyEmptyDate()
        endDate = NSDate().notionallyEmptyDate()
        salesText = ""
        eventType = ""
        bannerURL = ""
        super.init()
    }
    
    // Requests for information on event objects.
    func requestEvent(callback: (event: SIEvent?) -> ()) {
        SIRequest().requestEvent(eventId: id) { (event) in
            guard let event = event else {
                self.didLoadEventData = true
                callback(event: nil)
                return
            }
            
            callback(event: event)
        }
    }
    
    func requestSpeakers(callback:() -> ()) {
        SIRequest().requestSpeakers { (speakers) in
            if let speakers = speakers {
                for speaker in speakers {
                    guard let _ = self.speakers[speaker.name] else {
                        self.speakers[speaker.name] = speaker
                        continue
                    }
                }
            }
            self.didLoadSpeakers = true
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
    
    func requestBannerImage(callback: (image: UIImage?) -> ()) {
        
        if let image = image {
            callback(image: image)
            return
        }
        
        if bannerURL.isEmpty {
            callback(image: nil)
            return
        }
        
        requestImage(bannerURL) { image in
            if let image = image as UIImage? {
                self.image = image
                callback(image: image)
            } else {
                callback(image: nil)
            }
        }
    }
    
    func getBannerImage() -> UIImage? {
        if let image = self.image {
            return image
        }
        
        return nil
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
        date = NSDate().notionallyEmptyDate()
        super.init()
    }
    
    /// Gets session information for SIAgenda object using an agenda ID.
    func requestAgendaSessions(callback: () -> ()) {
        
        if id.isEmpty {
            callback()
            return
        }
        
        SIRequest().requestSessions(agendaId: id, callback: { sessions in
            
            if let sessions = sessions {
                self.sessions = sessions
                self.didLoadSessions = true
            }
            
            callback()
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
        displayName = "No Display Name"
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
    var organizationName : String
    var contactEmail : String
    
    override init() {
        title = ""
        pictureURL = ""
        biography = ""
        organizationName = ""
        contactEmail = ""
        associatedSessionIds = [String]()
        super.init()
    }
    
    /// Gets additional information about the speaker object.
    private func requestSpeakerInformation(callback: () -> ()) {
        SIRequest().requestSpeaker(speakerId: id) { (speaker) in
            if let speaker = speaker {
                self.title = speaker.title
                
                if self.pictureURL.isEmpty {
                    self.pictureURL = speaker.pictureURL
                }
                
                self.biography = speaker.biography
                self.organizationName = speaker.organizationName
                self.associatedSessionIds = speaker.associatedSessionIds
                self.name = speaker.name
                self.id = speaker.id
            }
        }
    }
    
    private func requestSpeakerImage() {
        if !pictureURL.isEmpty {
            requestImage(pictureURL) { image in
                if let image = image as UIImage? {
                    self.image = image
                }
            }
        }
    }
    
    func getSpeakerImage() -> UIImage {
        
        if let image = self.image {
            return image
        }
        
        if let image = UIImage(named: "silhouette") {
            return image
        }
        
        return UIImage()
    }
    
    func getLastName() -> String {
        let fullName = name.split(" ")
        return fullName[fullName.count - 1]!
    }
    
    private func getFirstName() -> String {
        let fullName = name.split(" ")
        
        if let firstName = fullName.first {
            return firstName!
        }
        
        return ""
    }
    
    private func getMiddleInitial() -> [String] {
        let fullName = name.split(" ")
        
        var middleInitial = [String]()
        
        if fullName.count > 2 {
            for name in fullName {
                if name != fullName[0] && name != fullName[fullName.count - 1] {
                    let char = name!.characters.first!
                    let initial = String(char).uppercaseString
                    middleInitial.append("\(initial).")
                }
            }
        }
        
        return middleInitial
    }
    
    /// Returns name in format of: Lastname, Firstname M.I.
    func getFormattedName() -> String {
        
        var fullName = getLastName() + ", " + getFirstName()
        for mi in getMiddleInitial() {
            fullName += " \(mi) "
        }
        
        return fullName
    }
    
}


class SIExhibitor: SIObject {
    
    var summary : String
    var contactEmail : String
    var website : String
    var logoURL : String {
        didSet {
            requestExhibitorLogoImage()
        }
    }
    var bannerURL : String {
        didSet {
            requestExhibitorLogoImage()
        }
    }
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
    
    private func requestExhibitorLogoImage() {
        
        if image != nil { return }
        
        if logoURL.isEmpty { return }
        
        requestImage(logoURL) { image in
            if let image = image as UIImage? {
                self.image = image
            }
        }
    }
    
    func requestExhibitorBannerImage() {
        
        if bannerImage != nil { return }
        
        if bannerURL.isEmpty { return }
        
        requestImage(bannerURL, callback: { image in
            if let image = image as UIImage? {
                self.bannerImage = image
            }
        });
    }
    
    func getLogoImage() -> UIImage {
        if let image = self.image {
            return image
        }
        
        if let image = UIImage(named: "logoComingSoon") {
            return image
        }
        
        return UIImage()
    }
    
    func getBannerImage() -> UIImage {
        if let image = self.bannerImage {
            return image
        }
        
        if let image = UIImage(named: "logoComingSoon") {
            return image
        }
        
        return UIImage()
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

    convenience init(name: String, type: AwardType) {
        self.init()
        self.name = name
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
    
    func getRecipientImage() -> UIImage? {
        
        if awardType == AwardType.None {
            return nil
        }
        
        if let image = image {
            return image
        }
        
        if let image = UIImage(named: "logoComingSoon500x500") {
            return image
        }
        
        return nil
    }
    
    //TODO: Needs to be implemented
    func parsePhotoList() -> [UIImage]? {
        return nil
    }
    
    //TODO: Needs to be implemented
    func parseVideoList() -> [String]? {
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
            requestLogoImage()
        }
    }
    var bannerURL : String {
        didSet {
            requestBannerImage()
        }
    }
    var splashScreenURL : String {
        didSet {
            requestSplashScreenImage()
        }
    }
    private var bannerImage : UIImage?
    private var splashScreenImage : UIImage?
    
    override init() {
        sponsorType = .None
        summary = ""
        logoURL = ""
        bannerURL = ""
        splashScreenURL = ""
        bannerImage = nil
        splashScreenImage = nil
        super.init()
    }
    
    convenience init(name: String, type: SponsorType) {
        self.init()
        self.name = name
        self.sponsorType = type
    }
    
    private func requestLogoImage() {
        
        if image != nil { return }
        
        if logoURL.isEmpty { return }
        
        self.requestImage(logoURL) { image in
            if let image = image {
                self.image = image
            }
        }
    }
    
    private func requestBannerImage() {
        
        if bannerImage != nil { return }
        
        if bannerURL.isEmpty { return }
        
        requestImage(bannerURL) { image in
            if let image = image as UIImage? {
                self.bannerImage = image
            }
        }
    }
    
    private func requestSplashScreenImage() {
        
        if splashScreenImage != nil { return }
        
        if splashScreenURL.isEmpty { return }
        
        requestImage(splashScreenURL, callback: { image in
            if let image = image {
                self.splashScreenImage = image
            }
        });
    }
    
    func getLogoImage() -> UIImage {
        
        if let image = self.image {
            return image
        }
        
        if let image = UIImage(named: "sponsor_banner_pl") {
            return image
        }
        
        return UIImage()
    }
    
    func getBannerImage() -> UIImage {
        
        if let image = self.bannerImage {
            return image
        }
        
        if let image = UIImage(named: "sponsor_banner_pl") {
            return image
        }
        
        return UIImage()
    }
    
    func getSplashScreenImage() -> UIImage? {
        
        if let image = self.splashScreenImage {
            return image
        }
        
        return nil
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
    
    func getVenueMapImages() -> [UIImage] {
        var maps = [UIImage]()
        for map in self.venueMaps {
            maps.append(map.getVenueMapImage())
        }
        return maps
    }
    
}

class SIVenueMap: SIObject {
    
    var mapURL : String {
        didSet {
            requestMapImage()
        }
    }
    var floor : Int
    
    override init() {
        mapURL = ""
        floor = -1
        super.init()
    }
    
    func getVenueMapImage() -> UIImage {
        
        if let image = self.image {
            return image
        }
        
        if let image = UIImage(named: "mapNotAvailable") {
            return image
        }
        
        requestMapImage()
        
        return UIImage()
    }
    
    private func requestMapImage() {
        
        if image != nil { return }
        
        if mapURL.isEmpty { return }
        
        self.requestImage(mapURL) { (image) in
            if let image = image {
                self.image = image
            }
        }
    }
    
}

class SIAffiliate: SIObject {
    
    var abstract : String
    var summary : String
    var logoURL : String {
        didSet {
            requestLogoImage()
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
    
    private func requestLogoImage() {
        
        if logoURL.isEmpty {
            return
        }
        
        requestImage(logoURL) { (image) in
            if let image = image {
                self.image = image
            }
        }
    }
    
    func getLogoImage() -> UIImage {
        if let image = self.image {
            return image
        }
        
        if let image = UIImage(named: "shingo_icon") {
            return image
        }
        
        requestLogoImage()
        
        return UIImage()
    }
    
}









