//
//  SIEvent.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/21/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

protocol SIEventDelegate {
    func onEventDetailCompletion()
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
    var didDisplaySponsorAd: Bool
    
    lazy var hasSplashAds: Bool = {
        return self.sponsorSplashAds.count > 0 || self.recycledSplashAds.count > 0
    }()
    
    lazy var hasBannerAds: Bool = {
        return self.sponsorBannerAds.count > 0 || self.recycledBannerAds.count > 0
    }()
    
    // Related objects
    var speakers: [String:SISpeaker] // Speakers are stored in a dictionary to prevent duplicate speakers from appearing that may be recieved from the API response
    var agendas: [SIAgenda]
    var venues: [SIVenue]
    var recipients: [SIRecipient]
    var affiliates: [SIAffiliate]
    var exhibitors: [SIExhibitor]
    var sponsors: [SISponsor]
    var attendees: [SIAttendee]
    private var sponsorBannerAds: [SponsorAd]
    private var sponsorSplashAds: [SponsorAd]
    private var recycledBannerAds: [SponsorAd]
    private var recycledSplashAds: [SponsorAd]
    
    // Event specific properties
    var startDate: SIDate
    var endDate: SIDate
    var eventType: String
    var salesText: String
    var bannerURL: String {
        didSet {
            getImage(nil)
        }
    }
    
    var tableViewCellDelegate: SIEventDelegate?
    
    var requester: Alamofire.Request? {
        get {
            return _requester
        }
    }
    
    private var _requester: Alamofire.Request? {
        willSet (newRequest) {
            if let request = self._requester {
                request.cancel()
            }
            self._requester = newRequest
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
        didDisplaySponsorAd = false
        speakers = [String:SISpeaker]() // key = speaker's name, value = SISpeaker object
        agendas = []
        venues = []
        recipients = []
        affiliates = []
        exhibitors = []
        sponsors = []
        attendees = []
        sponsorBannerAds = []
        sponsorSplashAds = []
        recycledBannerAds = []
        recycledSplashAds = []
        startDate = SIDate()
        endDate = SIDate()
        salesText = ""
        eventType = ""
        bannerURL = ""
        super.init()
    }
    
    // Requests for information on event objects.
    func requestEvent(_ callback: (() -> Void)?) {
        didLoadEventData = false
        _requester = SIRequest().requestEvent(eventId: id) { (event) in
            if let event = event {
                self.didLoadEventData = true
                self.speakers = event.speakers
                self.agendas = event.agendas
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
                self.set(splashAds: event.getSplashAds())
                self.set(bannerAds: event.getBannerAds())
                
            }
            self._requester = nil
            
            if let delegate = self.tableViewCellDelegate {
                delegate.onEventDetailCompletion()
            }
            
            if let cb = callback {
                cb()
            }
        }
    }
    
    func set(splashAds ads: [SponsorAd]) {
        sponsorSplashAds = ads
    }
    
    func set(bannerAds ads: [SponsorAd]) {
        sponsorBannerAds = ads
    }
    
    func getBannerAds() -> [SponsorAd] {
        return sponsorBannerAds
    }
    
    func getSplashAds() -> [SponsorAd] {
        return sponsorSplashAds
    }
    
    func append(advertisement ad: SponsorAd) {
        switch ad.type! {
        case .banner:
            self.sponsorBannerAds.append(ad)
        case .splashScreen:
            self.sponsorSplashAds.append(ad)
        default:
            break
        }
    }
    
    func getSplashAd() -> SponsorAd? {
        if sponsorSplashAds.count == 0 {
            sponsorSplashAds = recycledSplashAds
            recycledSplashAds = []
        }
        
        if sponsorSplashAds.count > 0 {
            let randIndex = Int(arc4random_uniform(UInt32(sponsorSplashAds.count)))
            let splashAd = sponsorSplashAds.remove(at: randIndex)
            recycledSplashAds.append(splashAd)
            return splashAd
        }
        
        return nil
    }
    
    func requestAttendees(callback: @escaping () -> Void) -> Alamofire.Request? {
        return SIRequest().requestEvent(eventId: id) { event in
            if let event = event {
                self.attendees = event.attendees
                self.didLoadAttendees = true
            }
            callback()
        }
    }
    
    func requestSpeakers(_ callback:@escaping () -> ()) -> Alamofire.Request? {
        return SIRequest().requestSpeakers(eventId: id) { (speakers) in
            if let speakers = speakers {
                for speaker in speakers {
                    self.speakers[speaker.name] = speaker //Adds speakers to dictionary object
                }
                self.didLoadSpeakers = true
            }
            callback()
        }
    }
    
    func requestAgendas(_ callback: @escaping () -> ()) -> Alamofire.Request? {
        return SIRequest().requestAgendaDays(eventId: self.id, callback: { agendas in
            
            guard let agendas = agendas else {
                callback()
                return
            }
            
            self.agendas = agendas
            self.didLoadAgendas = true
            
            callback()
        });
    }
    
    func requestSessions(callback: (() -> ())?) {
        
        for agenda in agendas {
            agenda.requestAgendaSessions({
                for session in agenda.sessions {
                    session.requestSessionInformation(nil)
                }
            })
        }
        
        if let callback = callback {
            callback()
        }
    }
    
    func requestVenues(_ callback: @escaping () -> ()) -> Alamofire.Request? {
        return SIRequest().requestVenues(eventId: self.id, callback: { (venues) in
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
    
    func requestRecipients(_ callback: @escaping () -> ()) -> Alamofire.Request? {
        return SIRequest().requestRecipients(eventId: self.id) { (recipients) in
            guard let recipients = recipients else {
                callback()
                return
            }
            
            self.recipients = recipients
            self.didLoadRecipients = true
            
            callback()
        }
    }
    
    func requestAffiliates(_ callback: @escaping () -> ()) -> Alamofire.Request? {
        return SIRequest.requestAffiliates { (affiliates) in
            guard let affiliates = affiliates else {
                return callback()
            }
            
            self.affiliates = affiliates
            self.didLoadAffiliates = true
            
            return callback()
        }
    }
    
    func requestExhibitors(_ callback: @escaping () -> ()) -> Alamofire.Request? {
        return SIRequest().requestExhibitors(eventId: self.id) { (exhibitors) in
            guard let exhibitors = exhibitors else {
                return callback()
            }
            
            self.exhibitors = exhibitors
            self.didLoadExhibitors = true
            
            return callback()
        }
    }
    
    func requestSponsors(_ callback: @escaping () -> ()) -> Alamofire.Request? {
        return SIRequest().requestSponsors(eventId: self.id) { (sponsors) in
            guard let sponsors = sponsors else { return callback() }
            
            self.sponsors = sponsors
            self.didLoadSponsors = true
            
            for sponsor in self.sponsors {
                // each sponsor object requests additional information not provided by the previous api request.
                sponsor.requestSponsorDetails()
            }
            
            return callback()
        }
    }
    
    /// getImage() provides a callback that makes an http request to get the event's bannerImage
    /// If the event has already loaded the image or does not have a url to fetch from, it will immediately invoke the callback.
    func getImage(_ callback: ((_ image: UIImage?) -> Void)?) {
        
        if self.image != nil || bannerURL.isEmpty{
            if let done = callback {
                done(self.image)
            }
            return
        }
        
        if bannerURL.isEmpty {
            if let done = callback {
                done(self.image)
            }
            return
        }
        
        self.requestImage(URLString: bannerURL) { image in
            if let image = image as UIImage? {
                self.image = image
                self.didLoadImage = true
            }
            
            if let done = callback {
                done(self.image)
            }
        }
    }

}





