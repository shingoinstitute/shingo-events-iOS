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
import Crashlytics

class SIObject : AnyObject {
    
    var image: UIImage?
    
    var name: String
    var id: String
    var attributedSummary: NSAttributedString
    var didLoadImage: Bool
    var isSelected: Bool
    
    init() {
        image = nil
        name = ""
        id = ""
        attributedSummary = NSAttributedString()
        didLoadImage = false
        isSelected = false
    }
    
    fileprivate func requestImage(URLString: String, callback: @escaping (
        UIImage?) -> Void) {
        
        Alamofire.request(URLString).responseImage { response in
            
            guard let image = response.result.value else {
                print("Warning, image download failed. Requested from \(URLString), for SIObject \"\(self.name)\".")
                callback(nil)
                return
            }
        
            print("Image Downloaded! \(image.fileSizeOfPNG())kb recieved; Dimensions: \(Int(image.size.width))x\(Int(image.size.height)); ObjectType: \(Mirror(reflecting: self).subjectType)")
            callback(image)
        }
    }
    
}

class SIAttendee: SIObject {
    
    var organization: String
    var title: String
    var pictureURL: String
    
    override init() {
        organization = ""
        title = ""
        pictureURL = ""
        super.init()
    }
    
    override func requestImage(URLString: String, callback: @escaping (UIImage?) -> Void) {
        
        if let image = self.image {
            return callback(image)
        }
        
        if pictureURL.isEmpty {
            return callback(nil)
        }
        
        super.requestImage(URLString: URLString) { (image) in
            if let _ = image {
                self.image = image
                self.didLoadImage = true
            }
            return callback(image)
        }
    }
    
    func getImage(callback: @escaping (UIImage) -> Void) {
        requestImage(URLString: pictureURL) { (image) in
            guard let image = image else {
                if let image = UIImage(named: "Name Filled-100") {
                    return callback(image)
                } else {
                    return callback(UIImage())
                }
            }
            
            return callback(image)
            
        }
    }
    
    private func getMiddleInitial() -> [String] {
        if let fullname = name.split(" ") {
            
            var middle = [String]()
            
            for n in fullname {
                if n != name.first! || n != name.last! {
                    middle.append(String(n.characters.first!).uppercased())
                }
            }
            
            return middle
        } else {
            return [""]
        }
    }
    
    /// Returns name in format of: "lastname, firstname M.I."
    func getFormattedName() -> String {
        
        if name.isEmpty {
            return ""
        }
        
        let names: [String] = self.name.lowercased().split(" ")!
        for var name in names {
            name.trim()
            
            var formattedName = [String]()
            for char in name.characters {
                formattedName.append(String(describing: char))
            }
            formattedName[0] = formattedName[0].uppercased()
            name = ""
            for letter in formattedName {
                name += letter
            }
        }
        
        
        
        var formattedName = names.first! + ", " + names.last!
        for mi in getMiddleInitial() {
            formattedName += " \(mi) "
        }
        
        return formattedName
    }
    
    func getLastName() -> String {
        
        if name.isEmpty {
            return ""
        }
        
        guard let names: [String] = self.name.lowercased().split(" ") else {
            return ""
        }
        
        guard let lastname = names.last else {
            return ""
        }
        
        return lastname
    }
    
    func getFirstName() -> String {
        
        if name.isEmpty {
            return ""
        }
        
        guard let names: [String] = self.name.lowercased().split(" ") else {
            return ""
        }
        
        guard let firstname = names.first else {
            return ""
        }
        
        return firstname
        
    }
    
}

class SIEvent: SIObject {
    
    var didLoadSpeakers: Bool
    var didLoadEventData: Bool
    var didLoadSessions: Bool
    var didLoadAgendas: Bool
    var didLoadVenues: Bool
    var didLoadRecipients: Bool
    var didLoadAffiliates: Bool
    var didLoadExhibitors: Bool
    var didLoadSponsors: Bool
    var didLoadAttendees: Bool
    
    // Related objects
    var speakers: [String:SISpeaker] // Speakers are stored in a dictionary to prevent duplicate speakers from appearing that may be recieved from the API response
    var agendaItems: [SIAgenda]
    var venues: [SIVenue]
    var recipients: [SIRecipient]
    var affiliates: [SIAffiliate]
    var exhibitors: [SIExhibitor]
    var sponsors: [SISponsor]
    var attendees: [SIAttendee]
    
    // Event specific properties
    var startDate: Date
    var endDate: Date
    var eventType: String
    var salesText: String
    var bannerURL: String {
        didSet {
            requestBannerImage() {}
        }
    }
    
    override init() {
        didLoadAttendees = false
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
        attendees = [SIAttendee]()
        startDate = Date.notionallyEmptyDate()
        endDate = Date.notionallyEmptyDate()
        salesText = ""
        eventType = ""
        bannerURL = ""
        super.init()
    }
    
    // Requests for information on event objects.
    func requestEvent(_ callback: (() -> Void)?) {
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
    
    func requestAttendees(callback: @escaping () -> Void) {
        SIRequest().requestEvent(eventId: id) { event in
            if let event = event {
                self.attendees = event.attendees
                self.didLoadAttendees = true
            }
            callback()
        }
    }
    
    func requestSpeakers(_ callback:@escaping () -> ()) {
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
    
    func requestAgendas(_ callback: @escaping () -> ()) {
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
    
    func requestVenues(_ callback: @escaping () -> ()) {
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
    
    func requestRecipients(_ callback: @escaping () -> ()) {
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
    
    func requestAffiliates(_ callback: @escaping () -> ()) {
        SIRequest.requestAffiliates { (affiliates) in
            guard let affiliates = affiliates else {
                callback()
                return
            }
            
            self.affiliates = affiliates
            self.didLoadAffiliates = true
            
            callback()
        }
    }
    
    func requestExhibitors(_ callback: @escaping () -> ()) {
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
    
    func requestSponsors(_ callback: @escaping () -> ()) {
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
    
    fileprivate func requestBannerImage(_ callback: (() -> Void)?) {
        
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
        
        self.requestImage(URLString: bannerURL) { image in
            if let image = image as UIImage? {
                self.image = image
                self.didLoadImage = true
            }
            if let cb = callback {
                cb()
            }
        }
    }
    
    func getBannerImage(_ callback: @escaping (_ image: UIImage?) -> Void) {
        if let image = self.image {
            callback(image)
            return
        }
        
        requestBannerImage() {
            if let image = self.image {
                callback(image)
            } else {
                callback(nil)
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
    var date : Date
    
    override init() {
        didLoadSessions = false
        sessions = [SISession]()
        displayName = ""
        date = Date.notionallyEmptyDate()
        super.init()
    }
    
    /// Gets session information for SIAgenda object using an agenda ID.
    func requestAgendaSessions(_ callback: @escaping () -> ()) {
        
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
        case recess = "Break",
        concurrent = "Concurrent",
        gemba = "Gemba",
        keynote = "Keynote",
        meal = "Meal",
        social = "Social",
        tour = "Tour",
        fullDayWorkshop = "Full Day Workshop",
        halfDayWorkshop = "Half Day Workshop",
        multiDayWorkshop = "Multi Day Workshop",
        none = "Session"
    }
    
    var didLoadSpeakers : Bool
    var didLoadSessionInformation : Bool
    var speakers : [SISpeaker]
    
    var displayName : String
    var sessionType : SessionType
    var sessionTrack : String
    var room : SIRoom?
    var startDate : Date
    var endDate : Date
    
    override init() {
        didLoadSpeakers = false
        didLoadSessionInformation = false
        speakers = [SISpeaker]()
        displayName = ""
        startDate = Date.notionallyEmptyDate()
        endDate = Date.notionallyEmptyDate()
        sessionType = .none
        sessionTrack = ""
        room = nil
        super.init()
    }
    
    private var sessionRequest: Alamofire.Request? {
        willSet (newRequest) {
            if let request = self.sessionRequest {
                if let _ = request.response {
                    request.cancel()
                }
            }
            self.sessionRequest = newRequest
        }
    }
    
    private var speakersRequest: Alamofire.Request? {
        willSet (newRequest) {
            
            if let request = self.speakersRequest {
                if let _ = request.response {
                    request.cancel()
                }
            }
            self.speakersRequest = newRequest
        }
    }
    
    /// Gets additional information about the session object.
    func requestSessionInformation(_ callback:@escaping () -> ()) {
        sessionRequest = SIRequest().requestSession(id, callback: { session in
            if let session = session {
                self.displayName = session.displayName
                self.startDate = session.startDate
                self.endDate = session.endDate
                self.sessionType = session.sessionType
                self.sessionTrack = session.sessionTrack
                self.room = session.room
                self.name = session.name
                self.id = session.id
                self.attributedSummary = session.attributedSummary
                self.didLoadSessionInformation = true
                
                callback()
                
                if !self.didLoadSpeakers {
                    self.requestSpeakers() {
                        self.didLoadSpeakers = true
                    }
                }
            }
        });
    }
    
    /// Gets all speakers associated with the session object.
    func requestSpeakers(_ callback: @escaping () -> ()) {
        speakersRequest = SIRequest().requestSpeakers(sessionId: id, callback: { speakers in
            if let speakers = speakers {
                self.speakers = speakers
                self.didLoadSpeakers = true
            }
            callback()
        });
    }
    
    func parseSessionType(_ type: String) -> SessionType {
        switch type {
            case "Break":
                return .recess
            case "Concurrent":
                return .concurrent
            case "Gemba":
                return .gemba
            case "Keynote":
                return .keynote
            case "Meal":
                return .meal
            case "Social":
                return .social
            case "Tour":
                return .tour
            case "Full Day Workshop":
                return .fullDayWorkshop
            case "Half Day Workshop":
                return .halfDayWorkshop
            case "Multi Day Workshop":
                return .multiDayWorkshop
            default:
                return .none
        }
    }
    
}


class SISpeaker: SIObject {
    
    enum SpeakerType: String {
        case keynote = "Keynote",
        concurrent = "Concurrent",
        none = ""
    }
    
    // related object id's
    var associatedSessionIds : [String]
    
    var title : String
    var pictureURL : String
    var organizationName : String
    var contactEmail : String
    var speakerType: SpeakerType {
        didSet {
            /* 
             Since the same speaker can speak in both Keynote and Concurrent sessions,
             if the speaker speaks in any Keynote session, his/her speakerType should
             remain as a Keynote Speaker. This is to maintain integrity of the SIObjects
             speaker types when displaying each section of speakers in SpeakerListTBLVC.
             */
            if oldValue == .keynote { self.speakerType = .keynote }
        }
    }
    
    override init() {
        title = ""
        pictureURL = ""
        organizationName = ""
        contactEmail = ""
        speakerType = .none
        associatedSessionIds = [String]()
        super.init()
    }
    
    /// Gets additional information about the speaker object.
    private func requestSpeakerInformation(_ callback: () -> ()) {
        SIRequest().requestSpeaker(speakerId: id) { (speaker) in
            if let speaker = speaker {
                
                self.name = speaker.name
                self.id = speaker.id
                
                self.title = speaker.title
                if self.pictureURL.isEmpty {
                    self.pictureURL = speaker.pictureURL
                }
                self.attributedSummary = speaker.attributedSummary
                self.organizationName = speaker.organizationName
                self.contactEmail = speaker.contactEmail
                self.associatedSessionIds = speaker.associatedSessionIds
            }
        }
    }
    
    private func requestSpeakerImage(_ callback: (() -> Void)?) {
        
        if image != nil || pictureURL.isEmpty {
            if let cb = callback { cb() }
            return
        }
        
        requestImage(URLString: pictureURL, callback: { image in
            if let image = image as UIImage? {
                self.image = image
                self.didLoadImage = true
            }
            
            if let cb = callback { cb() }
        });
    }
    
    func getSpeakerImage(callback: ((UIImage) -> Void)?) {
        
        guard let image = self.image else {
            requestSpeakerImage() {
                if let image = self.image {
                    if let cb = callback { cb(image) }
                } else if let image = UIImage(named: "Name Filled-100") {
                    if let cb = callback { cb(image) }
                } else {
                    if let cb = callback { cb(UIImage()) }
                }
            }
            return
        }
        
        if let cb = callback { cb(image) }
        
    }
    
    private func getMiddleInitial() -> [String] {
        if let fullname = name.split(" ") {
            
            var middle = [String]()
            
                for n in fullname {
                    if n != name.first! || n != name.last! {
                        middle.append(String(n.characters.first!).uppercased())
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
    fileprivate var bannerImage : UIImage?
    fileprivate var splashScreenImage : UIImage?
    var didLoadBannerImage: Bool
    var didLoadSplashScreen: Bool
    
    override init() {
        sponsorType = .none
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
    
    fileprivate func requestLogoImage(_ callback: (() -> Void)?) {
        
        if image != nil || logoURL.isEmpty {
            if let cb = callback { cb() }
            return
        }
        
        self.requestImage(URLString: logoURL) { image in
            if let image = image {
                self.image = image
                self.didLoadImage = true
            }
            if let cb = callback { cb() }
        }
    }
    
    fileprivate func requestBannerImage(_ callback: (() -> Void)?) {
        
        if bannerImage != nil || bannerURL.isEmpty {
            if let cb = callback { cb() }
            return
        }
        
        requestImage(URLString: bannerURL) { image in
            if let image = image as UIImage? {
                self.bannerImage = image
                self.didLoadBannerImage = true
            }
            if let cb = callback {
                cb()
            }
        }
    }
    
    fileprivate func requestSplashScreenImage(_ callback: (() -> Void)?) {
        
        if splashScreenImage != nil || splashScreenURL.isEmpty {
            if let cb = callback { cb() }
            return
        }
        
        requestImage(URLString: splashScreenURL, callback: { image in
            if let image = image {
                self.splashScreenImage = image
                self.didLoadSplashScreen = true
            }
            if let cb = callback {
                cb()
            }
        });
    }
    
    func getBannerImage(_ callback: @escaping (_ image: UIImage) -> ()) {
        
        if let image = self.bannerImage {
            callback(image)
            return
        }
        
        requestBannerImage() {
            if let image = self.image {
                callback(image)
            } else if let image = UIImage(named: "Shingo Icon Small") {
                callback(image)
            } else {
                callback(UIImage())
            }
        }
    }
    
    func getLogoImage(_ callback: @escaping (_ image: UIImage) -> ()) {
        
        if let image = self.image {
            callback(image)
            return
        }
        
        requestLogoImage {
            if let image = self.image {
                callback(image)
            } else if let image = UIImage(named: "sponsor_banner_pl") {
                callback(image)
            } else {
                callback(UIImage())
            }
        }
    }
    
    func getSplashScreenImage(_ callback: @escaping (_ image: UIImage) -> ()) {
        
        if let image = self.splashScreenImage {
            callback(image)
            return
        }
        
        requestSplashScreenImage { 
            if let image = self.image {
                callback(image)
            } else if let image = UIImage(named: "Sponsor_Splash_Screen_pl") {
                callback(image)
            } else {
                callback(UIImage())
            }
        }
    }
}

class SIVenue: SIObject {
    enum VenueType : Int {
        case none = 0,
        conventionCenter = 1,
        hotel = 2,
        museum = 3,
        restaurant = 4,
        other = 5
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
        venueType = .none
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
    
    func getVenueMapImage(_ callback: @escaping (UIImage) -> Void) {
        
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
    
    fileprivate func requestVenueMapImage(_ callback: (() -> Void)?) {
        
        if image != nil || mapURL.isEmpty {
            if let cb = callback { cb() }
        } else {
            self.requestImage(URLString: mapURL) { (image) in
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
    var logoURL : String {
        didSet {
            requestAffiliateLogoImage(nil)
        }
    }
    var websiteURL : String
    var pagePath : String
    
    override init() {
        logoURL = ""
        websiteURL = ""
        pagePath = ""
        super.init()
    }
    
    fileprivate func requestAffiliateLogoImage(_ callback: (() -> Void)?) {
        
        if logoURL.isEmpty || image != nil {
            if let cb = callback { cb() }
        }
        
        requestImage(URLString: logoURL) { (image) in
            if let image = image {
                self.image = image
                self.didLoadImage = true
            }
            
            if let cb = callback { cb() }
        }
    }
    
    func getLogoImage(_ callback: @escaping (UIImage) -> ()) {
        
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



