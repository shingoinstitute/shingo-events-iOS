//
//  APIRequests.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 6/28/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

let BASE_URL = "https://api.shingo.org"
let EVENTS_URL = BASE_URL + "/salesforce/events"

class SIRequest {
    
    // MARK: - Properties
    var dateFormatter = NSDateFormatter(locale: "en_US_POSIX",
                                        dateFormat: "yyyy-MM-dd",
                                        timeZone: "UTC")
    var sessionDateFormatter = NSDateFormatter(locale: "en_US_POSIX",
                                               dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS",
                                               timeZone: "UTC")
    
    // MARK: - API Calls
    ///////////////
    // API Calls //
    ///////////////
    
    /// Gets all events from Salesforce
    func requestEvents(callback: (events: [SIEvent]) -> Void) {
        
        getRequest(url: EVENTS_URL) { json in
            
            var events = [SIEvent]()
            
            if let json = json {
                
                if json["events"].isExists() {
                    
                    for record in json["events"].array! {
                        let event = SIEvent()
                        
                        if let id = record["Id"].string {
                            event.id = id
                        }
                        
                        if let name = record["Name"].string {
                            event.name = name
                        }
                        
                        if let startDate = record["Start_Date__c"].string {
                            if let startDate = self.dateFormatter.dateFromString(startDate) {
                                event.startDate = startDate
                            }
                            
                        }
                        
                        if let endDate = record["End_Date__c"].string {
                            if let endDate = self.dateFormatter.dateFromString(endDate) {
                                event.endDate = endDate
                            }
                        }
                        
                        if let eventType = record["Event_Type__c"].string {
                            event.eventType = eventType
                        }
                        
                        events.append(event)
                    }
                }
            }
            callback(events: events)
        }
    }
    
    /// Gets an event from Salesforce using an event ID.
    func requestEvent(eventId id: String, callback: (event: SIEvent?) -> Void) {
        
        getRequest(url: EVENTS_URL + "/\(id)") { json in
            
            let event = SIEvent()
            
            guard let json = json else {
                callback(event: nil)
                return
            }
            
            if json["event"].isExists() {
                
                let eventJSON = json["event"]
                
                if let id = eventJSON["Id"].string {
                    event.id = id
                }
                
                if let name = eventJSON["Name"].string {
                    event.name = name
                }
                
                if let startDate = eventJSON["Start_Date__c"].string {
                    if let startDate = self.dateFormatter.dateFromString(startDate) {
                        event.startDate = startDate
                    }
                }
                
                if let endDate = eventJSON["End_Date__c"].string {
                    if let endDate = self.dateFormatter.dateFromString(endDate) {
                        event.endDate = endDate
                    }
                }
                
                if let type = eventJSON["Event_Type__c"].string {
                    event.eventType = type
                }
                
                if let bannerURL = eventJSON["Banner_URL__c"].string {
                    event.bannerImageURL = bannerURL
                }
                
                if let salesText = eventJSON["Sales_Text__c"].string {
                    event.salesText = salesText
                }
                
            }
            callback(event: event)
        }
        
    }
    
    /// Gets all days for a single event using an event ID.
    func requestAgendaDays(eventId eventId: String, callback: (agendas: [SIAgenda]?) -> Void) {

        getRequest(url: EVENTS_URL + "/days?event_id=\(eventId)") { json in
            
            guard let json = json else {
                callback(agendas: nil)
                return
            }
            
            callback(agendas: self.parseDaysRequest(json))
        }
    }
    
    /// Gets all days from Salesforce.
    func requestAgendaDays(callback: (agendas: [SIAgenda]?) -> ()) {
        
        getRequest(url: EVENTS_URL + "/days") { json in
            
            guard let json = json else {
                callback(agendas: nil)
                return
            }
            
            callback(agendas: self.parseDaysRequest(json))
        }
        
    }

    private func parseDaysRequest(json: JSON) -> [SIAgenda] {
        
        var agendas = [SIAgenda]()
        
        if json["days"].isExists() {
            for record in json["days"].array! {
                
                let agenda = SIAgenda()
                
                if let id = record["Id"].string {
                    agenda.id = id
                }
                
                if let name = record["Name"].string {
                    agenda.name = name
                }
                
                if let displayName = record["Display_Name__c"].string {
                    agenda.displayName = displayName
                }
                
                if let date = record["Agenda_Date__c"].string {
                    if let date = self.dateFormatter.dateFromString(date) {
                        agenda.date = date
                    }
                }
                
                agendas.append(agenda)
            }
        }
        return agendas
    }
    
    /// Gets a single day using an agenda ID.
    func requestAgendaDay(agendaId id: String, callback: (agenda: SIAgenda?) -> Void) {
        
        getRequest(url: EVENTS_URL + "/days/\(id)") { json in
            
            guard let json = json else {
                callback(agenda: nil)
                return
            }
            
            let agenda = SIAgenda()
            
            if json["day"].isExists() {
                
                let day = json["day"]
                
                if let id = day["Id"].string {
                    agenda.id = id
                }
                
                if let name = day["Name"].string {
                    agenda.name = name
                }
                
                if let displayName = day["Display_Name_c"].string {
                    agenda.displayName = displayName
                }
                
                // Sessions for the recieved day
                if day["Shingo_Sessions__r"]["records"].isExists() {
                    for record in day["Shingo_Sessions__r"]["records"].array! {
                        let session = SISession()
                        
                        if let id = record["Id"].string {
                            session.id = id
                        }
                        
                        if let name = record["Name"].string {
                            session.name = name
                        }
                        
                        if let displayName = record["Session_Display_Name__c"].string {
                            session.displayName = displayName
                        }
                        
                        if let startDate = record["Start_Date_Time__c"].string {
                            if let startDate = self.sessionDateFormatter.dateFromString(startDate) {
                                session.startDate = startDate
                            }
                        }
                        
                        if let endDate = record["End_Date_Time__c"].string {
                            if let endDate = self.sessionDateFormatter.dateFromString(endDate) {
                                session.endDate = endDate
                            }
                        }
                        
                        if let type = record["Session_Type__c"].string {
                            session.sessionType = type
                        }
                        
                        agenda.sessions.append(session)
                    }
                }
            }
            
            
            callback(agenda: agenda)
        }
    }
    
    /// Gets all sessions for a single event using an agenda ID.
    func requestSessions(agendaId id: String, callback: (sessions: [SISession]?) -> ()) {
        getRequest(url: EVENTS_URL + "/sessions?agenda_id=\(id)") { json in
            
            guard let json = json else {
                callback(sessions: nil)
                return
            }
            
            callback(sessions: self.parseSessionResponse(json))
        }
    }
    
    /// Gets all sessions from Salesforce.
    func requestSessions(callback: (sessions: [SISession]?) -> ()) {
        
        getRequest(url: EVENTS_URL + "/sessions") { json in
            
            guard let json = json else {
                callback(sessions: nil)
                return
            }
            
            callback(sessions: self.parseSessionResponse(json))
            
        }
        
    }
    
    private func parseSessionResponse(json: JSON) -> [SISession] {
        
        var sessions = [SISession]()
        
        
        
        if json["sessions"].isExists() {
            
            for record in json["sessions"].array! {
                let session = SISession()
                
                if let id = record["Id"].string {
                    session.id = id
                }
                
                if let name = record["Name"].string {
                    session.name = name
                }
                
                if let displayName = record["Session_Display_Name__c"].string {
                    session.displayName = displayName
                }
                
                
                if let startDate = record["Start_Date_Time__c"].string {
                    if let startDate = self.sessionDateFormatter.dateFromString(sessionDateTimeStringParser(rawDate: startDate)) {
                        session.startDate = startDate
                    }
                }
            
                if let endDate = record["End_Date_Time__c"].string {
                    if let endDate = self.sessionDateFormatter.dateFromString(sessionDateTimeStringParser(rawDate: endDate)) {
                        session.endDate = endDate
                    }
                }
                
                if let type = record["Session_Type__c"].string {
                    session.sessionType = type
                }
                
                sessions.append(session)
            }
        }
        return sessions
    }
    
    /// Gets a single session using a session ID.
    func requestSession(id: String, callback: (session: SISession?) -> ()) {
        
        getRequest(url: EVENTS_URL + "/sessions/\(id)") { json in
            
            guard let json = json else {
                callback(session: nil)
                return
            }
            
            let session = SISession()
            
            if json["session"].isExists() {
                let record = json["session"]
                
                if let id = record["Id"].string {
                    session.id = id
                }
                
                if let name = record["Name"].string {
                    session.name = name
                }
                
                if let displayName = record["Session_Display_Name__c"].string {
                    session.displayName = displayName
                }
                
                if let startDate = record["Start_Date_Time__c"].string {
                    if let startDate = self.sessionDateFormatter.dateFromString(self.sessionDateTimeStringParser(rawDate: startDate)) {
                        session.startDate = startDate
                    }
                }
                
                if let endDate = record["End_Date_Time__c"].string {
                    if let endDate = self.sessionDateFormatter.dateFromString(self.sessionDateTimeStringParser(rawDate: endDate)) {
                        session.endDate = endDate
                    }
                }
                
                if let type = record["Session_Type__c"].string {
                    session.sessionType = type
                }
                
                if let track = record["Track__c"].string {
                    session.sessionTrack = track
                }
                
                if let summary = record["Summary__c"].string {
                    session.summary = summary
                }
                
                if let room = record["Room__r"].string {
                    session.room = room
                }
                
            }
            
            callback(session: session)
        }
        
    }
    
    /// Gets all speakers from Salesforce, or use session ID to get all speakers for a session
    func requestSpeakers(sessionId id: String, callback: (speakers: [SISpeaker]?) -> ()) {
        
        getRequest(url: EVENTS_URL + "/speakers?session_id=\(id)") { json in
            
            guard let json = json else {
                callback(speakers: nil)
                return
            }
            
            callback(speakers: self.parseSpeakerResponse(json))
            
        }
        
    }
    
    /// Gets all speakers for a single session
    func requestSpeakers(callback: (speakers: [SISpeaker]?) -> ()) {
        
        getRequest(url: EVENTS_URL + "/speakers") { json in
            
            guard let json = json else {
                callback(speakers: nil)
                return
            }
            
            callback(speakers: self.parseSpeakerResponse(json))
            
        }
        
    }
    
    private func parseSpeakerResponse(json: JSON) -> [SISpeaker] {
        
        var speakers = [SISpeaker]()
        
        if json["speakers"].isExists() {
            
            for record in json["speakers"].array! {
                let speaker = SISpeaker()
                
                if let id = record["Id"].string {
                    speaker.id = id
                }
                
                if let name = record["Name"].string {
                    speaker.name = name
                }
                
                if let title = record["Speaker_Title__c"].string {
                    speaker.title = title
                }
                
                if record["Session_Speaker_Associations__r"]["records"].isExists() {
                    for assoc in record["Session_Speaker_Associations__r"]["records"].array! {
                        if let id = assoc["Session__r"]["Id"].string {
                            speaker.associatedSessionIds.append(id)
                        }
                    }
                }
                
                speakers.append(speaker)
            }
        }
        
        return speakers
    }
    
    /// Gets a single speaker using a speaker ID.
    func requestSpeaker(speakerId id: String, callback: (speaker: SISpeaker?) -> ()) {
        
        getRequest(url: EVENTS_URL + "/speakers/\(id)", callback: { json in
            
            guard let json = json else {
                callback(speaker: nil)
                return
            }
            
            let speaker = SISpeaker()
            
            if json["speaker"].isExists() {
                
                let record = json["speaker"]
                
                if let id = record["Id"].string {
                    speaker.id = id
                }
                
                if let name = record["Name"].string {
                    speaker.name = name
                }
                
                if let title = record["Speaker_Title__c"].string {
                    speaker.title = title
                }
                
                if let pictureURL = record["Picture_URL__c"].string {
                    speaker.pictureURL = pictureURL
                }
                
                if let biography = record["Speaker_Biography__c"].string {
                    speaker.biography = biography
                }
                
                if let organization = record["Organization__r"].string {
                    speaker.organization = organization
                }
            
                if record["Session_Speaker_Associations__r"]["records"].isExists() {
                    for assoc in record["Session_Speaker_Associations__r"]["records"].array! {
                        
                        if let id = assoc["Session__r"]["Id"].string {
                            speaker.associatedSessionIds.append(id)
                        }
                    }
                    
                }
                
            }
            
            callback(speaker: speaker)
        });
        
    }
    
    func requestExhibitors(eventId id: String, callback: (exhibitors: [SIExhibitor]?) -> ()) {
        
        getRequest(url: EVENTS_URL + "/exhibitors?event_id=\(id)", callback: { json in
        
            guard let json = json else {
                callback(exhibitors: nil)
                return
            }
            
            var exhibitors = [SIExhibitor]()
            
            if json["exhibitors"].isExists() {
                
                for record in json["exhibitors"].array! {
                    
                    let exhibitor = SIExhibitor()
                    
                    if let id = record["Id"].string {
                        exhibitor.id = id
                    }
                    
                    if let name = record["Organization__r"]["Name"].string {
                        exhibitor.name = name
                    }
                    
                    if let logoURL = record["Organization__r"]["Logo__c"].string {
                        exhibitor.logoURL = logoURL
                    }
                    
                    exhibitors.append(exhibitor)
                }
                
            }
          
            callback(exhibitors: exhibitors)
            
        });
        
    }
    
    
    func requestExhibitor(exhibitorId id: String, callback: (exhibitor: SIExhibitor?) -> ()) {
        
        getRequest(url: EVENTS_URL + "/exhibitors/\(id)", callback: { json in
            
            guard let json = json else {
                callback(exhibitor: nil)
                return
            }
            
            if json["exhibitor"].isExists() {
                
                let record = json["exhibitor"]
                let exhibitor = SIExhibitor()
                
                if let id = record["Id"].string {
                    exhibitor.id = id
                }
                
                if let bannerURL = record["Banner_URL__c"].string {
                    exhibitor.bannerURL = bannerURL
                }
                
                if let x = record["Map_Coordinate__c"]["latitude"].double {
                    exhibitor.mapCoordinate.0 = x
                }
                
                if let y = record["Map_Coordinate__c"]["longitude"].double {
                    exhibitor.mapCoordinate.1 = y
                }
                
                let organization = record["Organization__r"]
                
                if let name = organization["Name"].string {
                    exhibitor.name = name
                }
                
                if let logoURL = organization["Logo__c"].string {
                    exhibitor.logoURL = logoURL
                }
                
                if let summary = organization["App_Abstract__c"].string {
                    exhibitor.summary = summary
                }
                
                if let email = organization["Public_Contact_Email__c"].string {
                    exhibitor.contactEmail = email
                }
                
                if let website = organization["Website"].string {
                    exhibitor.website = website
                }
                
                
            }
            
        })
        
    }
    
    func requestHotels(eventId id: String, callback: (hotels: [SIHotel]?) -> ()) {
        
        getRequest(url: EVENTS_URL + "/hotels?event_id=\(id)", callback: { json in
        
            guard let json = json else {
                callback(hotels: nil)
                return
            }
            
            var hotels = [SIHotel]()
            
            if json["hotels"].isExists() {
                
                for record in json["hotels"].array! {
                    
                    let hotel = SIHotel()
                    
                    if let id = record["Id"].string {
                        hotel.id = id
                    }
                    
                    if let name = record["Name"].string {
                        hotel.name = name
                    }
                    
                    if let address = record["Address__c"].string {
                        hotel.address = address
                    }
                    
                    if let phone = record["Hotel_Phone__c"].string {
                        hotel.phone = phone
                    }
                    
                    if let website = record["Hotel_Website__c"].string {
                        hotel.website = website
                    }
                    
//                     Need to ask Dustin about the API response for this  field.
//                    if let eventId = record["Event_Hotel_Associations__r"] {
//                        
//                    }
                    
                    hotels.append(hotel)
                }
            }
            
            callback(hotels: hotels)
            
        });
        
    }
    
    func requestHotel(hotelId id: String, callback: (hotel: SIHotel?) -> Void) {
        
        getRequest(url: EVENTS_URL + "/hotels/\(id)", callback: { json in
        
            guard let json = json else {
                callback(hotel: nil)
                return
            }
            
            let hotel = SIHotel()
            
            if json["hotel"].isExists() {
                
                let record = json["hotel"]
                
                if let id = record["Id"].string {
                    hotel.id = id
                }
                
                if let name = record["Name"].string {
                    hotel.name = name
                }
                
                if let address = record["Address__c"].string {
                    hotel.address = address
                }
                
                if record["Shingo_Prices__r"]["totalSize"].int! > 0 {
                    for record in record["Shingo_Prices__r"]["records"].array! {
                        if let price = record["Price__c"].double {
                            hotel.prices.append(price)
                        }
                    }
                }
            }
            
            callback(hotel: hotel)
            
        });
        
    }
    
    func requestRecipients(eventId id: String, callback: (recipients: [SIRecipient]?) -> Void) {
        
        getRequest(url: EVENTS_URL + "/recipients?event_id=\(id)", callback: { json in
        
            guard let json = json else {
                callback(recipients: nil)
                return
            }
            
            var recipients = [SIRecipient]()
            
            if json["recipient"].isExists() {
                
                let record = json["recipient"]
                let recipient = SIRecipient()
                
                if let id = record["Id"].string {
                    recipient.id = id
                }
                
                if let name = record["Organization__r"]["Name"].string {
                    recipient.name = name
                }
                
                if let awardType = record["Award_Type__c"].string {
                    recipient.awardType = self.parseRecipientAwardType(awardType)
                }
                
                recipients.append(recipient)
            }
            
            callback(recipients: recipients)
            
        });
        
    }
    
    func requestRecipient(recipientId id: String, callback: (recipient: SIRecipient?) -> Void) {
        
        getRequest(url: EVENTS_URL + "/recipients/\(id)", callback: { json in
        
            guard let json = json else {
                callback(recipient: nil)
                return
            }
            
            let recipient = SIRecipient()
            
            if json["recipient"].isExists() {
                
                let record = json["recipient"]
                
                if let id = record["Id"].string {
                    recipient.id = id
                }
                
                if let name = record["Organization"]["Name"].string {
                    recipient.name = name
                }
                
                if let logoURL = record["Organization"]["Logo__c"].string {
                    recipient.logoURL = logoURL
                }
                
                if let awardType = record["Award_Type__c"].string {
                    recipient.awardType = self.parseRecipientAwardType(awardType)
                }
                
                if let photoList = record["List_of_Photos__c"].string {
                    recipient.photoList = photoList
                }
                
                if let videoList = record["List_of_Videos__c"].string {
                    recipient.videoList = videoList
                }
                
                if let pressRelease = record["Press_Release__c"].string {
                    recipient.pressRelease = pressRelease
                }
                
                if let profile = record["Profile__c"].string {
                    recipient.profile = profile
                }
                
                if let summary = record["Summary__c"].string {
                    recipient.summary = summary
                }
            }
            
            callback(recipient: recipient)
            
        });
        
    }
    
    private func parseRecipientAwardType(awardType: String) -> SIRecipient.AwardType {
        switch awardType {
            case "Shingo Prize":
                return .ShingoPrize
            case "Silver Medallion":
                return .Silver
            case "Bronze Medallion":
                return .Bronze
            case "Research":
                return .Research
            case "Publication":
                return .Publication
            default:
                return .None
        }
    }
    
    func requestRooms(venueId id: String, callback: (rooms: [SIRoom]?) -> Void) {
        
        getRequest(url: EVENTS_URL + "/rooms?venue_id=\(id)", callback: { json in
        
            guard let json = json else {
                callback(rooms: nil)
                return
            }
            
            var rooms = [SIRoom]()
            
            if let records = json["rooms"].array {
                
                for record in records {
                    
                    let room = SIRoom()
                    
                    if let id = record["Id"].string {
                        room.id = id
                    }
                    
                    if let name = record["Name"].string {
                        room.name = name
                    }
                 
                    rooms.append(room)
                    
                }
                
            }
            
            callback(rooms: rooms)
            
        });
        
    }
    
    func requestRoom(roomId id: String, callback: (room: SIRoom?) -> Void) {
        
        getRequest(url: EVENTS_URL + "/rooms/\(id)", callback: { json in
        
            guard let json = json else {
                callback(room: nil)
                return
            }
            
            let room = SIRoom()
            
            if json["room"].isExists() {
                
                let record = json["room"]
                
                if let id = record["Id"].string {
                    room.id = id
                }
                
                if let name = record["Name"].string {
                    room.name = name
                }
                
                if let x = record["Map_Coordinate__c"]["latitude"].double {
                    room.mapCoordinate.0 = x
                }
                
                if let y = record["Map_Coordinate__c"]["longitude"].double {
                    room.mapCoordinate.1 = y
                }

            }

            callback(room: room)
            
        });
        
    }
    
    func requestSponsors(eventId id: String, callback: () -> Void) {
        
        
        
    }
    
    func requestSponsor(sponsorId id: String, callback: () -> Void) {
       
        
        
    }
    
    func requestVenues(eventId id: String, callback: () -> Void) {
       
        
        
    }
    
    func requestVenue(venueId id: String, callback: () -> Void) {
        
        
        
    }
    
    
    // MARK: - Supporting Functions
    //////////////////////////
    // Supporting Functions //
    //////////////////////////
    
    // Check for internet connectivity
    func checkForInternetConnection() -> Bool {
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            return false
        case .Online(.WWAN), .Online(.WiFi):
            return true
        }
    }
    
    func sessionDateTimeStringParser(rawDate r: String) -> String {
        // The API returns a string that looks like "2016-09-21T19:30:00.000+0000"
        // The "+0000" in the returned string needs to be removed for self.sessionDateFormatter
        // to correctly parse the date
        return r.split("+")[0]
    }
    
    // make HTTP POST request
    private func postRequest(url url: String, parameters: [String:String], callback: (value: JSON?) -> ())  {
        Alamofire.request(.POST, url, parameters: parameters).responseJSON { response in
            
            guard response.result.isSuccess else {
                print("Error while performing API POST request: \(response.result.error)")
                callback(value: nil)
                return
            }
            
            guard let response = response.result.value else {
                print("Error while performing API POST request: Invalid response")
                callback(value: nil)
                return
            }
            
            let responseJSON = JSON(response)
            print(responseJSON)
            callback(value: responseJSON)
        }
    }
    
    // make HTTP GET request
    private func getRequest(url url: String, callback: (value: JSON?) -> ()) {
        Alamofire.request(.GET, url).responseJSON { response in
            
            guard response.result.isSuccess else {
                print("Error while performing API GET request: \(response.result.error!)")
                callback(value: nil)
                return
            }
            
            guard let response = response.result.value else {
                print("Error while performing API GET request: Invalid response")
                callback(value: nil)
                return
            }
            
            let responseJSON = JSON(response)
            
            if let success = responseJSON["success"].bool {
                if !success {
                    callback(value: nil)
                    return
                }
            }
            
            print(responseJSON)
            callback(value: responseJSON)
        }
    }

    
}