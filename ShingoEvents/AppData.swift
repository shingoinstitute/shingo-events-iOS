//
//  Classes.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 12/30/15.
//  Copyright © 2015 Shingo Institute. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import MapKit

enum URLTYPE {
    case GetUpcomingEvents,
    GetSession,
    GetSpeakers,
    GetEventSessions,
    GetAgenda,
    GetDay,
    GetSalesforceEvents,
    GetRecipients,
    GetExhibitors,
    GetAffiliates,
    GetSponsors,
    NonType
}

class AppData {

    var upcomingEvents:[SIEvent]!
    var event:SIEvent!
    var exhibitors:[SIExhibitor]!
    var affiliates:[SIAffiliate]!
    
    var friendSponsors:[SISponsor]!
    var supportersSponsors:[SISponsor]!
    var benefactorsSponsors:[SISponsor]!
    var championsSponsors:[SISponsor]!
    var presidentsSponsors:[SISponsor]!
    
    var researchRecipients : [SIRecipient]!
    var shingoPrizeRecipients : [SIRecipient]!
    var silverRecipients : [SIRecipient]!
    var bronzeRecipients : [SIRecipient]!
    
    
    init() {
        upcomingEvents = [SIEvent]()
        event = SIEvent()
        exhibitors = [SIExhibitor]()
        affiliates = [SIAffiliate]()
        
        friendSponsors = [SISponsor]()
        supportersSponsors = [SISponsor]()
        benefactorsSponsors = [SISponsor]()
        championsSponsors = [SISponsor]()
        presidentsSponsors = [SISponsor]()
        
        researchRecipients = [SIRecipient]()
        shingoPrizeRecipients = [SIRecipient]()
        silverRecipients = [SIRecipient]()
        bronzeRecipients = [SIRecipient]()
    }
    
    func getUpcomingEvents(callback: () -> Void) {

        self.upcomingEvents = [SIEvent]()
        
        GET(.GetUpcomingEvents) {
            json in
            
            if json["events"]["records"] != nil {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                for item in json["events"]["records"].array! {
                    let upcomingEvent = SIEvent()
                    if item["Id"] != nil {
                        upcomingEvent.id = item["Id"].string! as String
                    }
                    if item["Name"] != nil {
                        upcomingEvent.name = item["Name"].string! as String
                    }
                    if item["Event_Start_Date__c"] != nil {
                        upcomingEvent.eventStartDate = dateFormatter.dateFromString(item["Event_Start_Date__c"].string! as String)!
                    }
                    if item["Event_End_Date__c"] != nil {
                        upcomingEvent.eventEndDate = dateFormatter.dateFromString(item["Event_End_Date__c"].string! as String)!
                    }
                    if item["Host_Organization__c"] != nil {
                        upcomingEvent.hostOrganization = item["Host_Organization__c"].string! as String
                    }
                    if item["Host_City__c"] != nil {
                        upcomingEvent.hostCity = item["Host_City__c"].string! as String
                    }
                    if item["Event_Type__c"] != nil {
                        upcomingEvent.eventType = item["Event_Type__c"].string! as String
                    }
                    if item["LatLng__c"] != nil {
                        upcomingEvent.location = CLLocationCoordinate2D(latitude: item["LatLng__c"]["latitude"].double! as Double, longitude: item["LatLng__c"]["longitude"].double! as Double)
                    }
                    
                    if item["Venue_Maps"] != nil {
                        upcomingEvent.venueMaps = [SIVenueMap]()
                        for map in item["Venue_Maps"].array! {

                            let venueMap = SIVenueMap(name: map["name"].string! as String, url: map["url"].string! as String)
                            venueMap.getVenueMapImage(venueMap.url)
                            upcomingEvent.venueMaps.append(venueMap)
                        }
                    }
                    self.upcomingEvents.append(upcomingEvent)
                }
            }
            callback()
        }
    }
    
    
    func getAgenda(callback: () -> Void) {
        
        let parameters = [
            "event_id": event.id!
        ]
        
        POST(.GetAgenda, parameters: parameters) {
            json in
            
            if json["agenda"]["Days"]["records"] != nil {
                
                self.event!.eventAgenda.id = json["agenda"]["Id"].string! as String
                let days = json["agenda"]["Days"]["records"].array!
                
                for day in days {
                    let dayId = day["Id"].string! as String
                
                    self.getDay(dayId) {
                        item in
                        self.event.eventAgenda.agendaArray.append(item)
                    }
                }
                callback()
            }
        }
    }

    
    func getEventSessions (callback: () -> Void) {
        
        let parameters = [
            "event_id": event.id!
        ]
        
        POST(.GetEventSessions, parameters: parameters) {
            json in
            
            for item in json["sessions"]["records"].array! {
                let session = SIEventSession()
                
                if item["Id"].isExists() {
                    session.id = item["Id"].string! as String
                }
                if item["Name"] != nil {
                    session.name = item["Name"].string! as String
                }
                if item["Session_Abstract__c"] != nil {
                    session.abstract = item["Session_Abstract__c"].string! as String
                }
                if item["Rich_Session_Abstract"] != nil {
                    session.richAbstract = item["Rich_Session_Abstract"].string! as String
                }
                if item["Session_Notes__c"] != nil {
                    session.notes = item["Session_Notes__c"].string! as String
                }
                if item["Room"] != nil {
                    session.room = item["Room"].string! as String
                }
                if item["Speakers"]["records"] != nil {
                    let event_speakers = item["Speakers"]["records"].array!
                    for event_speaker in event_speakers {
                        if event_speaker["Id"] != nil {
                            let id = event_speaker["Id"].string! as String
                            session.speakerIds.append(id)
                        }
                    }
                }
                if item["Session_Date__c"] != nil && item["Session_Time__c"] != nil {
                    let start_end_date = self.sessionDateParser(String(item["Session_Date__c"].string!), time: String(item["Session_Time__c"].string!))
                    session.startEndDate = SIDateTuple(firstAndLast: start_end_date)
                }
                if item["Session_Format__c"] != nil {
                    session.format = item["Session_Format__c"].string! as String
                }
                
                self.event.eventSessions.append(session)
            }
            callback()
        }
    }
    
    
    
    func sessionDateParser(date:String, time:String) -> (NSDate, NSDate) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm a"
        formatter.timeZone = NSTimeZone.localTimeZone()
        formatter.locale = NSLocale(localeIdentifier: "en-US")
        
        let timeSplit = time.characters.split("-")
        let startTime = String(timeSplit[0]).trim()
        let endTime = String(timeSplit[1]).trim()
        
        let raw_startDateTime = "\(date) \(startTime)"
        let raw_endDateTime   = "\(date) \(endTime)"
        
        var dates = (NSDate(), NSDate())
        
        if let startDateTime : NSDate = formatter.dateFromString(raw_startDateTime) {
            dates.0 = startDateTime
        }
        
        if let endDateTime : NSDate = formatter.dateFromString(raw_endDateTime) {
            dates.1 = endDateTime
        }
        
        return dates
    }
    
    
    
    func getDay(dayId:String, callback: (day:SIEventDay) -> Void) {
        
        let parameters = [
            "day_id": dayId
        ]
        
        POST(.GetDay, parameters: parameters) {
            json in
            
            let day = SIEventDay()
            if json["day"]["Id"] != nil {
                day.id = json["day"]["Id"].string! as String
            }
            if json["day"]["Name"] != nil {
                day.dayOfWeek = json["day"]["Name"].string! as String
            }
            if json["day"]["Sessions"]["records"] != nil {
                for session in json["day"]["Sessions"]["records"].array!
                {
                    for item in self.event!.eventSessions!
                    {
                        if item.id == session["Id"].string! as String
                        {
                            day.sessions.append(item)
                        }
                        
                    }
                }
            }
            callback(day: day)
        }
    }

    
    func getSpeakers(callback: () -> Void) {
        
        if !event.eventSpeakers.isEmpty {
            callback()
            return
        }
        
        let parameters = [
            "event_id": event.id!
        ]
        
        POST(.GetSpeakers, parameters: parameters) {
            json in
            
            if json["speakers"]["records"] != nil {
                for item in json["speakers"]["records"].array! {
                    let speaker = SISpeaker()
                    
                    if item["Id"] != nil {
                        speaker.id = item["Id"].string! as String
                    }
                    if item["Biography__c"] != nil {
                        speaker.biography = item["Biography__c"].string! as String
                    }
                    if item["Rich_Biography"] != nil {
                        speaker.richBiography = item["Rich_Biography"].string! as String
                    }
                    if item["Speaker_Image__c"] != nil {
                        speaker.imageUrl = item["Speaker_Image__c"].string! as String
                        speaker.getSpeakerImage(speaker.imageUrl)
                    }
                    if item["Speaker_Display_Name__c"] != nil {
                        speaker.displayName = item["Speaker_Display_Name__c"].string! as String
                    }
                    if item["Name"] != nil {
                        speaker.name = item["Name"].string! as String
                    }
                    if item["Title"] != nil {
                        speaker.title = item["Title"].string! as String
                    }
                    if item["Organization"] != nil {
                        speaker.organization = item["Organization"].string! as String
                    }
                    self.event.eventSpeakers.append(speaker)
                    print("Speaker Name: \(speaker.displayName) | ID: \(speaker.id)")
                }
            }
            self.populateSessionSpeakers()
            callback()
        }
    }
    
    func populateSessionSpeakers() {
        for session in event.eventSessions {
            for id in session.speakerIds {
                for speaker in event.eventSpeakers {
                    if id == speaker.id {
                        session.sessionSpeakers.append(speaker)
                    }
                }
            }
        }
    }
    
    func getRecipients(callback: () -> Void) {
        
        let parameters = [
            "event_id": event.id!
        ]
        
        POST(.GetRecipients, parameters: parameters) {
            json in
            
            if json["award_recipients"]["records"] != nil {
                self.parseRecipientData(json["award_recipients"]["records"])
            }
            if json["research_recipients"]["records"] != nil {
                self.parseRecipientData(json["research_recipients"]["records"])
            }
            callback()
        }
    }

    
    func parseRecipientData(json: JSON) {
        if json.array != nil {
            for item in json.array! {
                let recipient = SIRecipient()
                if item["Id"] != nil {
                    recipient.id = item["Id"].string! as String
                }
                if item["Name"] != nil {
                    recipient.name = item["Name"].string! as String
                }
                if item["Abstract__c"] != nil {
                    recipient.abstract = item["Abstract__c"].string! as String
                }
                if item["Rich_Abstract"] != nil {
                    recipient.richAbstract = item["Rich_Abstract"].string! as String
                }
                if item["Event__c"] != nil {
                    recipient.eventId = item["Event__c"].string! as String
                }
                if item["Award__c"] != nil {
                    recipient.award = item["Award__c"].string! as String
                } else {
                    recipient.award = ""
                }
                if item["Author_s__c"] != nil {
                    recipient.authors = item["Author_s__c"].string! as String
                }
                if item["Logo_Book_Cover__c"] != nil {
                    let imageUrl = item["Logo_Book_Cover__c"].string! as String
                    recipient.logoBookCoverUrl = imageUrl
                    recipient.getRecipientImage(imageUrl)
                }
                
                switch recipient.award {
                case "Research Award":
                    recipient.awardType = .Research
                    self.researchRecipients.append(recipient)
                case "Shingo Prize":
                    recipient.awardType = .ShingoAward
                    self.shingoPrizeRecipients.append(recipient)
                case "Silver Medallion":
                    recipient.awardType = .Silver
                    self.silverRecipients.append(recipient)
                case "Bronze Medallion":
                    recipient.awardType = .Bronze
                    self.bronzeRecipients.append(recipient)
                default:
                    recipient.awardType = .NonType
                    print("WARNING AppData::parseRecipientData, Recipient type not found")
                }
                
            }
            
        }
    }
    
    
    func getExhibitors(callback: () -> Void) {
        
        if !exhibitors.isEmpty {
            callback()
            return
        }
        
        let parameters = [
            "event_id": event.id!
        ]
        
        POST(.GetExhibitors, parameters: parameters) {
            json in
            
            if json["exhibitors"]["records"] != nil {
                let exhibitors = json["exhibitors"]["records"].array
                
                for item in exhibitors! {
                    let exhibitor = SIExhibitor()
                    
                    if item["id"] != nil {
                        exhibitor.id = item["Id"].string! as String
                    }
                    if item["Name"] != nil {
                        exhibitor.name = item["Name"].string! as String
                    }
                    if item["Description__c"] != nil {
                        exhibitor.description = item["Description__c"].string! as String
                    }
                    if item["Rich_Description"] != nil {
                        exhibitor.richDescription = item["Rich_Description"].string! as String
                    }
                    if item["Phone__c"] != nil {
                        exhibitor.phone = item["Phone__c"].string! as String
                    }
                    if item["Email__c"] != nil {
                        exhibitor.email = item["Email__c"].string! as String
                    }
                    if item["Website__c"] != nil {
                        exhibitor.website = item["Website__c"].string! as String
                    }
                    if item["Logo__c"] != nil {
                        exhibitor.logoUrl = item["Logo__c"].string! as String
                        exhibitor.getExhibitorImage(exhibitor.logoUrl)
                    }
                    if item["Event__c"] != nil {
                        exhibitor.eventId = item["Event__c"].string! as String
                    }
                    self.exhibitors.append(exhibitor)
                }
            }
            callback()
        }
        
    }
    
    
    func getAffiliates(callback: () -> Void) {
        
        if !affiliates.isEmpty {
            callback()
            return
        }
        
        self.GET(.GetAffiliates) {
            json in
            
            if json["affiliates"]["records"] != nil {
                let affiliates = json["affiliates"]["records"].array
                
                
                for item in affiliates! {
                    let affiliate = SIAffiliate()
                    
                    if !(item["Id"].object is NSNull) {
                        affiliate.id = item["Id"].string! as String
                    }
                    if !(item["Name"].object is NSNull) {
                        affiliate.name = item["Name"].string! as String
                    }
                    if !(item["App_Abstract__c"].object is NSNull) {
                        affiliate.abstract = item["App_Abstract__c"].string! as String
                    }
                    if item["Rich_App_Abstract"] != nil {
                        affiliate.richAbstract = item["Rich_App_Abstract"].string! as String
                    }
                    if !(item["Logo__c"].object is NSNull) {
                        affiliate.logoUrl = item["Logo__c"].string! as String
                        affiliate.getAffiliateImage(affiliate.logoUrl)
                    }
                    if !(item["Website"].object is NSNull) {
                        affiliate.websiteUrl = item["Website"].string! as String
                    }
                    if !(item["Phone"].object is NSNull) {
                        affiliate.phone = item["Phone"].string! as String
                    }
                    if !(item["Public_Contact_Email__c"].object is NSNull) {
                        affiliate.email = item["Public_Contact_Email__c"].string! as String
                    }
                    self.affiliates.append(affiliate)
                }
            }
            callback()
        }
    }
    
    
    func getSponsors(callback: () -> Void) {
        
        let parameters = [
            "event_id": event.id!
        ]
        
        POST(.GetSponsors, parameters: parameters) {
            json in
            
            if json["sponsors"] != nil {
                let sponsors = json["sponsors"]
                var sponsorsNew = [SISponsor]()
                
                if sponsors["friends"] != nil {
                    sponsorsNew = self.parseSponsorData(sponsors["friends"]["records"])
                    for item in sponsorsNew {
                        item.sponsorType = .Friend
                    }
                    self.friendSponsors = sponsorsNew
                }
                if sponsors["supporters"] != nil {
                    sponsorsNew = self.parseSponsorData(sponsors["supporters"]["records"])
                    for item in sponsorsNew {
                        item.sponsorType = .Supporter
                    }
                    self.supportersSponsors = sponsorsNew
                }
                if sponsors["benefactors"] != nil {
                    sponsorsNew = self.parseSponsorData(sponsors["benefactors"]["records"])
                    for item in sponsorsNew {
                        item.sponsorType = .Benefactor
                    }
                    self.benefactorsSponsors = sponsorsNew
                }
                if sponsors["champions"] != nil {
                    sponsorsNew = self.parseSponsorData(sponsors["champions"]["records"])
                    for item in sponsorsNew {
                        item.sponsorType = .Champion
                    }
                    self.championsSponsors = sponsorsNew
                }
                if sponsors["presidents"] != nil {
                    sponsorsNew = self.parseSponsorData(sponsors["presidents"]["records"])
                    for item in sponsorsNew {
                        item.sponsorType = .President
                    }
                    self.presidentsSponsors = sponsorsNew
                }
            }
            callback()
        }
    }
    
    
    func parseSponsorData(json:JSON) -> [SISponsor] {
        var sponsors = [SISponsor]()
        
        for item in json.array! {
            let sponsor = SISponsor()
            if item["Id"] != nil {
                sponsor.id = item["Id"].string! as String
            }
            if item["MDF_Amount__c"] != nil {
                sponsor.mdfAmount = Double(item["MDF_Amount__c"].double!)
            }
            if item["Banner__c"] != nil {
                let banner_url = String(item["Banner__c"].string!)
                sponsor.bannerUrl = banner_url
                sponsor.getBannerImage(sponsor.bannerUrl)
            }
            if item["Logo__c"] != nil {
                sponsor.logoUrl = item["Logo__c"].string! as String
                sponsor.getSponsorImage(sponsor.logoUrl)
            }
            if item["Level__c"] != nil {
                sponsor.level = item["Level__c"].string! as String
            }
            if item["Event__c"] != nil {
                sponsor.eventId = item["Event__c"].string! as String
            }
            if item["Name"] != nil {
                print(item["Name"].string! as String)
                sponsor.name = item["Name"].string! as String
            }
            sponsors.append(sponsor)
        }
        
        return sponsors
    }
    
    
    func GET(url: URLTYPE, callback: (json: JSON) -> Void) {
        
        Alamofire.request(.GET, getUrl(url)).validate().responseJSON {
            response in
            
            if response.result.isSuccess {
                print("HTTP STATUS CODE: \((response.response?.statusCode)!)")
                print("Validation Successful: \(response.result)")
                if let value = response.result.value {
                    let json = JSON(value)
                    if json["success"].bool == true {
                        print("JSON from request to \(self.getUrl(url))")
                        print("--------- BEGIN ---------")
                        print(          json           )
                        print("------ RESPONSE END ------")
                        callback(json: json)
                    } else {
                        callback(json: nil)
                    }
                }
            } else {
                print("HTTP STATUS CODE: \((response.result.error?.code)!)")
                print("HTTP REQUEST ERROR: @ \(self.getUrl(url)) \(response.result.error)")
                callback(json: nil)
            }
        }
    }
    
    
    func POST(url: URLTYPE, parameters: [String:String]?, callback: (json: JSON) -> Void){
        
        Alamofire.request(.POST, getUrl(url), parameters: parameters).validate().responseJSON {
            response in
            
            if response.result.isSuccess {
                print("HTTP STATUS CODE: \((response.response?.statusCode)!)")
                print("Validation Successful: \(response.result)")
                if let value = response.result.value {
                    let json = JSON(value)
                    if json["success"].bool == true {
                        print("JSON from requst to \(self.getUrl(url))")
                        print("--------- BEGIN ---------")
                        print(          json           )
                        print("------ RESPONSE END ------")
                        callback(json: json)
                    } else {
                        callback(json: nil)
                    }
                }
            } else {
                print("HTTP STATUS CODE: \((response.result.error?.code)!)")
                print("HTTP REQUEST ERROR: @ \(self.getUrl(url)) \(response.result.error)")
                callback(json: nil)
                return
            }
        }
    }
    
    func getUrl(type: URLTYPE) -> String {
        
        let base_url = "https://api.shingo.org"

        var url = ""
        
        switch (type) {
        case .GetUpcomingEvents:
            url = "/events"
        case .GetSession:
            url = "/sfevents/session?"
        case .GetSpeakers:
            url = "/sfevents/speakers?"
        case .GetEventSessions:
            url = "/sfevents/sessions?"
        case .GetAgenda:
            url = "/sfevents/agenda?"
        case .GetDay:
            url = "/sfevents/day?"
        case .GetSalesforceEvents:
            url = "/sfevents/?"
        case .GetRecipients:
            url = "/sfevents/recipients?"
        case .GetExhibitors:
            url = "/sfevents/exhibitors?"
        case .GetAffiliates:
            url = "/sfevents/affiliates?"
        case .GetSponsors:
            url = "/sfevents/sponsors?"
        default:
            break
        }

        return base_url + url
    }
    
    // MARK: - Sorting
    
    func sortSessionsByDate(inout sessions:[SIEventSession]) {
        for i in 0 ..< sessions.count - 1
        {
            for j in 0 ..< sessions.count - i - 1
            {
                
                let date = NSDate(timeIntervalSince1970: sessions[j].startEndDate!.first.timeIntervalSince1970)
                let nextDate = NSDate(timeIntervalSince1970: sessions[j+1].startEndDate!.last.timeIntervalSince1970)
                
                // If date1 is greater than date2, swap the dates
                if date.isGreaterThanDate(nextDate) {
                    let temp = sessions[j].startEndDate!
                    sessions[j].startEndDate! = sessions[j+1].startEndDate!
                    sessions[j+1].startEndDate! = temp
                }
                
                // If date1 and date2 are on the same day and time, compare what time they end, and swap accordingly
                if date.equalToDate(nextDate) {
                    
                    let endTime = NSDate(timeIntervalSince1970: sessions[j].startEndDate!.last.timeIntervalSince1970)
                    let nextEndTime = NSDate(timeIntervalSince1970: sessions[j+1].startEndDate!.last.timeIntervalSince1970)
                    
                    if endTime.isGreaterThanDate(nextEndTime) {
                        let temp = sessions[j].startEndDate!
                        sessions[j].startEndDate! = sessions[j+1].startEndDate!
                        sessions[j+1].startEndDate! = temp
                    }
                }
            }
        }
        event.eventSessions = sessions
    }
    
}


