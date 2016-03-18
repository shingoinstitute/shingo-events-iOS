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
    ERROR
}

public class AppData {

    var upcomingEvents:[Event]!
    var event:Event!
    var exhibitors:[Exhibitor]!
    var affiliates:[Affiliate]!
    
    var friendSponsors:[Sponsor]!
    var supportersSponsors:[Sponsor]!
    var benefactorsSponsors:[Sponsor]!
    var championsSponsors:[Sponsor]!
    var presidentsSponsors:[Sponsor]!
    
    var researchRecipients = [Recipient]()
    var shingoPrizeRecipients = [Recipient]()
    var silverRecipients = [Recipient]()
    var bronzeRecipients = [Recipient]()
    
    
    public func getUpcomingEvents(callback: () -> Void) {
        self.upcomingEvents = nil
        self.upcomingEvents = [Event]()
        
        GET(.GetUpcomingEvents) {
            json in
            
            if json["events"]["records"] != nil {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                for item in json["events"]["records"].array! {
                    let upcoming_event = Event()
                    if item["Id"] != nil {
                        upcoming_event.event_id = item["Id"].string! as String
                    }
                    if item["Name"] != nil {
                        upcoming_event.name = item["Name"].string! as String
                    }
                    if item["Event_Start_Date__c"] != nil {
                        upcoming_event.event_start_date = dateFormatter.dateFromString(item["Event_Start_Date__c"].string! as String)!
                    }
                    if item["Event_End_Date__c"] != nil {
                        upcoming_event.event_end_date = dateFormatter.dateFromString(item["Event_End_Date__c"].string! as String)!
                    }
                    if item["Host_Organization__c"] != nil {
                        upcoming_event.host_organization = item["Host_Organization__c"].string! as String
                    }
                    if item["Host_City__c"] != nil {
                        upcoming_event.host_city = item["Host_City__c"].string! as String
                    }
                    if item["Event_Type__c"] != nil {
                        upcoming_event.event_type = item["Event_Type__c"].string! as String
                    }
                    if item["LatLng__c"] != nil {
                        upcoming_event.location = CLLocationCoordinate2D(latitude: item["LatLng__c"]["latitude"].double! as Double, longitude: item["LatLng__c"]["longitude"].double! as Double)
                    }
                    
                    if item["Venue_Maps"] != nil {
                        upcoming_event.venueMaps = [VenueMap]()
                        for map in item["Venue_Maps"].array! {
                            
                            // an FYI; This class constructor makes an http request to get the venue picture when initialized
                            let venueMap = VenueMap(
                                name: map["name"].string! as String,
                                url: map["url"].string! as String
                            )
                            upcoming_event.venueMaps.append(venueMap)
                        }
                    }
                    self.upcomingEvents.append(upcoming_event)

                    
                }
            }
            callback()
        }
    }
    
    
    public func getAgenda(callback: () -> Void) {
        let parameters = [
            "event_id": self.event!.event_id
        ]
        
        POST(.GetAgenda, parameters: parameters) {
            json in
            
            // Checks if json["agenda"]["records"] is empty or not
            if json["agenda"]["Days"]["records"] != nil {
                self.event!.eventAgenda.agenda_id = json["agenda"]["Id"].string! as String
                let days = json["agenda"]["Days"]["records"] // Pass in entire ["records"] array to completeAsyncTaskOnGetAgenda()
                let count = days.array!.count
                
                // I blame this code on the flurry of async calls being sent out by this task
                for (var i = 0; i < count; i++) {
                    let day_id = days[i]["Id"].string! as String
                    
                    // This is set up so it will only use callback() on the last iteration i
                    // Note to self: Come up with a more graceful solution once we get this app deployed
                    if i == (count - 1) {
                        self.findDayFromDayId(day_id) {
                            day in
                            
                            if day != nil {
                                self.event!.eventAgenda.days_array.append(day!)
                            }
                            callback()
                        }
                    } else {
                        self.findDayFromDayId(day_id) {
                            day in
                            
                            if day != nil {
                                self.event!.eventAgenda.days_array.append(day!)
                            }
                        }
                    }
                }
                
            } else {
                print("WARNING! Empty agenda @func AppData::getAgenda")
                callback()
            }
            
            
        }
    }
    

    func findDayFromDayId(day_id:String, completionHandler:(day: EventDay?) -> Void) {
        self.getDay(day_id) {
            day in
            completionHandler(day: day)
        }
    }

    
    public func getEventSessions (callback: () -> Void) {
        self.event.eventSessions = nil
        self.event.eventSessions = [EventSession]()
        
        let parameters = [
            "event_id": self.event!.event_id
        ]
        
        POST(.GetEventSessions, parameters: parameters) {
            json in
            
            for item in json["sessions"]["records"].array! {
                let session = EventSession()
                
                if item["Id"] != nil {
                    session.session_id = item["Id"].string! as String
                }
                if item["Name"] != nil {
                    session.name = item["Name"].string! as String
                }
                if item["Session_Abstract__c"] != nil {
                    session.abstract = item["Session_Abstract__c"].string! as String
                }
                if item["Session_Notes__c"] != nil {
                    session.notes = item["Session_Notes__c"].string! as String
                }
                if item["Room"] != nil {
                    session.room = item["Room"].string! as String
                }
                if let event_speakers = item["Speakers"]["records"].array {
                    for event_speaker in event_speakers {
                        if event_speaker["Id"] != nil
                        {
                            let id = event_speaker["Id"].string! as String
                            let name = event_speaker["Name"].string! as String
                            if name.rangeOfString("Mark") != nil {
                                print(name)
                            }
                            session.speaker_ids.append(id)
                        }
                    }
                }
                if item["Session_Date__c"] != nil && item["Session_Time__c"] != nil {
                    session.start_end_date = self.sessionDateParser(item["Session_Date__c"].string! as String, time: item["Session_Time__c"].string! as String)
                }
                self.event!.eventSessions?.append(session)
            }
            callback()
        }
    }
    
    
    
    func sessionDateParser(date:String, time:String) -> (NSDate, NSDate) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm a"
        let split_date = time.characters.split("-")
        let start_date_time:String = date + " " + String(split_date[0])
        let end_date_time:String = date + String(split_date[1])
        let start_date = formatter.dateFromString(start_date_time)
        let end_date = formatter.dateFromString(end_date_time)
        
        return (start_date!, end_date!)
    }
    
    
    
    public func getDay(day_id:String, callback: (day:EventDay) -> Void) {
        
        let parameters = [
            "day_id": day_id
        ]
        
        POST(.GetDay, parameters: parameters) {
            json in
            
            let day = EventDay()
            if json["day"]["Id"] != nil {
                day.day_id = json["day"]["Id"].string! as String
            }
            if json["day"]["Name"] != nil {
                day.dayOfWeek = json["day"]["Name"].string! as String
            }
            if json["day"]["Sessions"]["records"] != nil {
                for session in json["day"]["Sessions"]["records"].array! {
                    for item in self.event!.eventSessions! {
                        if item.session_id == session["Id"].string! as String {
                            day.sessions.append(item)
                        }
                    }
                }
            }
            callback(day: day)
        }
        
        
    }
    
    

    
    public func getSpeakers(callback: () -> Void) {
        
        if self.event.speakers != nil
        {
            return
        }
        else
        {
            self.event.speakers = [Speaker]()
        }
        
        let parameters = [
            "event_id": self.event!.event_id
        ]
        
        POST(.GetSpeakers, parameters: parameters) {
            json in
            
            if json["speakers"]["records"] != nil {
                for item in json["speakers"]["records"].array! {
                    let speaker = Speaker()
                    
                    if item["Id"] != nil {
                        speaker.speaker_id = item["Id"].string! as String
                    }
                    if item["Biography__c"] != nil {
                        speaker.biography = item["Biography__c"].string! as String
                    }
                    if item["Speaker_Image__c"] != nil {
                        speaker.image_url = item["Speaker_Image__c"].string! as String
                        speaker.getImage(speaker.image_url)
                    }
                    if item["Speaker_Display_Name__c"] != nil {
                        speaker.display_name = item["Speaker_Display_Name__c"].string! as String
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
                    self.event.speakers.append(speaker)
                    print("Speaker Name: \(speaker.display_name) | ID: \(speaker.speaker_id)")
                }
            }
            callback()
        }
    }
    
    
    public func getRecipients(callback: () -> Void) {
        
        let parameters = [
            "event_id": self.event!.event_id
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
                let recipient = Recipient()
                if item["Id"] != nil {
                    recipient.recipient_id = item["Id"].string! as String
                }
                if item["Name"] != nil {
                    recipient.name = item["Name"].string! as String
                }
                if item["Abstract__c"] != nil {
                    recipient.abstract = item["Abstract__c"].string! as String
                }
                if item["Event__c"] != nil {
                    recipient.event_id = item["Event__c"].string! as String
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
                    let image_url = item["Logo_Book_Cover__c"].string! as String
                    recipient.logo_book_cover_url = image_url
                    recipient.getRecipientImage(image_url) {
                        image in
                        recipient.logo_book_cover_image = image
                    }
                }
                switch recipient.award {
                case "Research Award":
                    recipient.award_type = .Research
                    self.researchRecipients.append(recipient)
                case "Shingo Prize":
                    recipient.award_type = .ShingoAward
                    self.shingoPrizeRecipients.append(recipient)
                case "Silver Medallion":
                    recipient.award_type = .Silver
                    self.silverRecipients.append(recipient)
                case "Bronze Medallion":
                    recipient.award_type = .Bronze
                    self.bronzeRecipients.append(recipient)
                default: print("ERROR: Recipient type not found @func AppData::getRecipient !")
                }
                
            }
            
        }
    }
    
    
    public func getExhibitors(callback: () -> Void) {
        
        let parameters = [
            "event_id": self.event!.event_id
        ]
        
        POST(.GetExhibitors, parameters: parameters) {
            json in
            
            if self.exhibitors == nil {
                self.exhibitors = [Exhibitor]()
            } else {
                callback()
                return
            }
            
            if json["exhibitors"]["records"] != nil {
                let exhibitors = json["exhibitors"]["records"].array
                
                for item in exhibitors! {
                    let exhibitor = Exhibitor()
                    
                    if item["id"] != nil {
                        exhibitor.SF_id = item["Id"].string! as String
                    }
                    if item["Name"] != nil {
                        exhibitor.name = item["Name"].string! as String
                    }
                    if item["Description__c"] != nil {
                        exhibitor.description = item["Description__c"].string! as String
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
                        exhibitor.logo_url = item["Logo__c"].string! as String
                        exhibitor.getImage(item["Logo__c"].string! as String) {
                            image in
                            exhibitor.logo_image = image
                        }
                    }
                    if item["Event__c"] != nil {
                        exhibitor.event_id = item["Event__c"].string! as String
                    }
                    self.exhibitors?.append(exhibitor)
                }
            }
            callback()
        }
        
    }
    
    
    public func getAffiliates(callback: () -> Void) {
        
        if self.affiliates != nil
        {
            callback()
            return
        }
        
        self.affiliates = [Affiliate]()
        
        self.GET(.GetAffiliates) {
            json in
            
            if json["affiliates"]["records"] != nil {
                let affiliates = json["affiliates"]["records"].array
                
                
                for item in affiliates! {
                    let affiliate = Affiliate()
                    
                    if !(item["Id"].object is NSNull) {
                        affiliate.id = item["Id"].string! as String
                    }
                    if !(item["Name"].object is NSNull) {
                        affiliate.name = item["Name"].string! as String
                    }
                    if !(item["App_Abstract__c"].object is NSNull) {
                        affiliate.abstract = item["App_Abstract__c"].string! as String
                    }
                    if !(item["Logo__c"].object is NSNull) {
                        affiliate.logo_url = item["Logo__c"].string! as String
                        affiliate.getImage(item["Logo__c"].string! as String) {
                            image in
                            affiliate.logo_image = image
                        }
                    }
                    if !(item["Website"].object is NSNull) {
                        affiliate.website_url = item["Website"].string! as String
                    }
                    if !(item["Phone"].object is NSNull) {
                        affiliate.phone = item["Phone"].string! as String
                    }
                    if !(item["Public_Contact_Email__c"].object is NSNull) {
                        affiliate.email = item["Public_Contact_Email__c"].string! as String
                    }
                    self.affiliates?.append(affiliate)
                }
            }
            callback()
        }
    }
    
    
    public func getSponsors(callback: () -> Void) {
        
        let parameters = [
            "event_id": self.event.event_id
        ]
        
        POST(.GetSponsors, parameters: parameters) {
            json in
            
            if json["sponsors"] != nil {
                let sponsors = json["sponsors"]
                var sponsors_new = [Sponsor]()
                
                if sponsors["friends"] != nil {
                    sponsors_new = self.parseSponsorData(sponsors["friends"]["records"])
                    for item in sponsors_new {
                        item.sponsor_type = .Friend
                    }
                    self.friendSponsors = sponsors_new
                }
                if sponsors["supporters"] != nil {
                    sponsors_new = self.parseSponsorData(sponsors["supporters"]["records"])
                    for item in sponsors_new {
                        item.sponsor_type = .Supporter
                    }
                    self.supportersSponsors = sponsors_new
                }
                if sponsors["benefactors"] != nil {
                    sponsors_new = self.parseSponsorData(sponsors["benefactors"]["records"])
                    for item in sponsors_new {
                        item.sponsor_type = .Benefactor
                    }
                    self.benefactorsSponsors = sponsors_new
                }
                if sponsors["champions"] != nil {
                    sponsors_new = self.parseSponsorData(sponsors["champions"]["records"])
                    for item in sponsors_new {
                        item.sponsor_type = .Champion
                    }
                    self.championsSponsors = sponsors_new
                }
                if sponsors["presidents"] != nil {
                    sponsors_new = self.parseSponsorData(sponsors["presidents"]["records"])
                    for item in sponsors_new {
                        item.sponsor_type = .President
                    }
                    self.presidentsSponsors = sponsors_new
                }
            }
            callback()
        }
    }
    
    
    func parseSponsorData(json:JSON) -> [Sponsor] {
        var sponsors = [Sponsor]()
        
        for item in json.array! {
            let sponsor = Sponsor()
            if item["Id"] != nil {
                sponsor.id = item["Id"].string! as String
            }
            if item["MDF_Amount__c"] != nil {
                sponsor.mdf_amount = item["MDF_Amount__c"].int! as Int
            }
            if item["Banner__c"] != nil {
                let banner_url = item["Banner__c"].string! as String
                sponsor.banner_url = banner_url
                sponsor.getSponsorImage(banner_url) {
                    image in
                    sponsor.banner_image = image
                }
            }
            if item["Logo__c"] != nil {
                sponsor.logo_url = item["Logo__c"].string! as String
                sponsor.getSponsorImage(item["Logo__c"].string! as String) {
                    image in
                    sponsor.logo_image = image
                }
            }
            if item["Level__c"] != nil {
                sponsor.level = item["Level__c"].string! as String
            }
            if item["Event__c"] != nil {
                sponsor.event_id = item["Event__c"].string! as String
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
    
    
    
    func getUrl(var type: URLTYPE) -> String {
//        let base_url = "https://shingo-events.herokuapp.com/api"
        let CLIENT_ID_SECRET = "client_id=6cd61ca33e7f2f94d460b1e9f2cb73&client_secret=bb313eea59bd309a4443c38b29"
        let base_url = "http://104.131.77.136:5000/api"
        
        
        var url = ""
        
        switch (type) {
        case .GetUpcomingEvents:
            url = "/sfevents/?"
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
            type = .ERROR
            break
        }
        
        if type != .ERROR {
            print("Making request to: \(url) | Request Type: .\(String(type))")
             return base_url + url + CLIENT_ID_SECRET
        } else {
            print("ERROR: Invalid HTTP request | URL: \(url)")
            return ""
        }
        
    }
    
    // MARK: - Custom Functions
    
    public func sortSessionsByDate(inout sessions:[EventSession]) {
        for(var i = 0; i < sessions.count - 1; i++) {
            for(var j = 0; j < sessions.count - i - 1; j++) {
                
                if sessions[j].start_end_date!.0.timeIntervalSince1970 > sessions[j+1].start_end_date!.0.timeIntervalSince1970 {
                    let temp = sessions[j].start_end_date!
                    sessions[j].start_end_date! = sessions[j+1].start_end_date!
                    sessions[j+1].start_end_date! = temp
                }
                
                if sessions[j].start_end_date!.0.timeIntervalSince1970 == sessions[j+1].start_end_date!.0.timeIntervalSince1970 {
                    if sessions[j].start_end_date!.1.timeIntervalSince1970 > sessions[j+1].start_end_date!.1.timeIntervalSince1970 {
                        let temp = sessions[j].start_end_date!
                        sessions[j].start_end_date! = sessions[j+1].start_end_date!
                        sessions[j+1].start_end_date! = temp
                    }
                }
            }
        }
        self.event!.eventSessions = sessions
    }
    
}


