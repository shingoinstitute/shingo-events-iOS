//
//  SIEvent.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/21/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit

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
    
    // Related objects
    var speakers: [String:SISpeaker] // Speakers are stored in a dictionary to prevent duplicate speakers from appearing that may be recieved from the API response
    var agendaItems: [SIAgenda]
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
        didDisplaySponsorAd = false
        speakers = [String:SISpeaker]() // key = speaker's name, value = SISpeaker object
        agendaItems = []
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
                self.set(splashAds: event.getSplashAds())
                self.set(bannerAds: event.getBannerAds())
                
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
