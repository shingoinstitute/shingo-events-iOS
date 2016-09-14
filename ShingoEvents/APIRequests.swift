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
import MapKit

let BASE_URL = "https://api.shingo.org"
let EVENTS_URL = BASE_URL + "/salesforce/events"
let SUPPORT_URL = BASE_URL + "/support"

class SIRequest {
    
    // MARK: - Properties
    
    // Date formatters uses convenience init that defaults timezone to GMT
    var dateFormatter = NSDateFormatter(locale: "en_US_POSIX", dateFormat: "yyyy-MM-dd")
    var sessionDateFormatter = NSDateFormatter(locale: "en_US_POSIX", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS")
    
    
    // Mark: - Alamofire
    
    /// HTTP GET request method.
    private func getRequest(url url: String, description: String, callback: (value: JSON?) -> ()) -> Alamofire.Request? {
        
        return Alamofire.request(.GET, url).responseJSON { response in
            
            print("+-\(self.marks(description))")
            print("| \(description) |")
            print("+-\(self.marks(description))")
            
            guard response.result.isSuccess else {
                print("Error while performing API GET request: \(response.result.error!)")
                print("+-\(self.marks(description + " - END"))")
                print("| \(description + " - END") |")
                print("+-\(self.marks(description + " - END"))")
                callback(value: nil)
                return
            }
            
            guard let response = response.result.value else {
                print("Error while performing API GET request: Invalid response")
                print("+-\(self.marks(description + " - END"))")
                print("| \(description + " - END") |")
                print("+-\(self.marks(description + " - END"))")
                callback(value: nil)
                return
            }
            
            let responseJSON = JSON(response)
            
            if let success = responseJSON["success"].bool {
                if !success {
                    print("+-\(self.marks(description + " - END"))")
                    print("| \(description + " - END") |")
                    print("+-\(self.marks(description + " - END"))")
                    callback(value: nil)
                    return
                }
            }
            
            print(responseJSON)
            
            print("+-\(self.marks(description + " - END"))")
            print("| \(description + " - END") |")
            print("+-\(self.marks(description + " - END"))")
            
            callback(value: responseJSON)
        }
    }
    
    
    /// HTTP POST request method.
    private func postRequest(url url: String, description: String, parameters: [String:String], callback: (value: JSON?) -> ()) {
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
            
            print("+-\(self.marks(description + " - END"))")
            print("| \(description + " - END") |")
            print("+-\(self.marks(description + " - END"))")
            
            callback(value: responseJSON)
        }
    }
    
}

extension SIRequest {

    // MARK: - API Calls
    
    /// Returns all ready-to-publish events from Salesforce.
    func requestEvents(callback: (events: [SIEvent]?) -> Void) -> Alamofire.Request? {
        
        return getRequest(url: EVENTS_URL, description: "REQUEST EVENTS") { json in
            
            guard let json = json else {
                callback(events: nil)
                return
            }
            
            var events = [SIEvent]()
                
            if let records = json["events"].array {
                
                for record in records {
                    
                    if let publishToApp = record["Publish_to_Web_App__c"].bool {
                        if !publishToApp {
                            continue
                        }
                    }
                    
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
                    
                    if let bannerURL = record["Banner_URL__c"].string {
                        event.bannerURL = bannerURL
                    }
                    
                    events.append(event)
                }
            }
            callback(events: events)
        }
    }
    
    /// Returns an event from Salesforce using an event ID.
    func requestEvent(eventId id: String, callback: (event: SIEvent?) -> Void) {
        
        getRequest(url: EVENTS_URL + "/\(id)", description: "REQUEST EVENT") { json in
            
            guard let json = json else {
                callback(event: nil)
                return
            }
            
            let event = SIEvent()
            
            if json["event"] != nil {
                
                let record = json["event"]
                
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
                
                if let type = record["Event_Type__c"].string {
                    event.eventType = type
                }
                
                if let bannerURL = record["Banner_URL__c"].string {
                    event.bannerURL = bannerURL
                }
                
                if let salesText = record["Sales_Text__c"].string {
                    event.salesText = salesText
                }
                
            }
            callback(event: event)
        }
        
    }
    
    /// Gets all days for a single event using an event ID.
    func requestAgendaDays(eventId eventId: String, callback: (agendas: [SIAgenda]?) -> Void) {

        getRequest(url: EVENTS_URL + "/days?event_id=\(eventId)", description: "REQUEST AGENDA FOR EVENT") { json in
            
            guard let json = json else {
                callback(agendas: nil)
                return
            }
            
            callback(agendas: self.parseDaysRequest(json))
        }
    }
    
    /// Gets all days from Salesforce.
    func requestAgendaDays(callback: (agendas: [SIAgenda]?) -> ()) {
        
        getRequest(url: EVENTS_URL + "/days", description: "REQUEST AGENDAS, ALL") { json in
            
            guard let json = json else {
                callback(agendas: nil)
                return
            }
            
            callback(agendas: self.parseDaysRequest(json))
        }
        
    }

    private func parseDaysRequest(json: JSON) -> [SIAgenda] {
        
        var agendas = [SIAgenda]()
        
        if let records = json["days"].array {
            for record in records {
                
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
    
    /// Gets basic information for sessions associated with an SIAgenda.
    func requestAgendaSessions(agendaId id: String, callback: (sessions: [SISession]?) -> Void) {
        
        getRequest(url: EVENTS_URL + "/days/\(id)", description: "REQUEST SESSIONS, BASIC") { json in
            
            guard let json = json else {
                callback(sessions: nil)
                return
            }
            
            var sessions = [SISession]()
            
            if let records = json["day"]["Shingo_Sessions__r"]["records"].array {
                
                // NOTE: The response from this API call also provides the agenda's ID, name, and display name,
                // however this information is not needed because it will have already been provided by previous API requests.
                
                // Sessions for the agenda with the provided agenda ID
                for record in records {
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
                        session.sessionType = session.parseSessionType(type)
                    }
                    
                    sessions.append(session)
                }
            }
            callback(sessions: sessions)
        }
    }
    
    /// Gets all sessions for a single event using an agenda ID. Note: Provides more detail than requestAgendaSessions().
    func requestSessions(agendaId id: String, callback: (sessions: [SISession]?) -> ()) {
        getRequest(url: EVENTS_URL + "/sessions?agenda_id=\(id)", description: "REQUEST SESSIONS, DETAILED") { json in
            
            guard let json = json else {
                callback(sessions: nil)
                return
            }
            
            callback(sessions: self.parseSessionResponse(json))
        }
    }
    
    /// Gets all sessions from Salesforce.
    func requestSessions(callback: (sessions: [SISession]?) -> ()) {
        
        getRequest(url: EVENTS_URL + "/sessions", description: "REQUEST SESSIONS, ALL") { json in
            
            guard let json = json else {
                callback(sessions: nil)
                return
            }
            
            callback(sessions: self.parseSessionResponse(json))
            
        }
        
    }
    
    private func parseSessionResponse(json: JSON) -> [SISession] {
        
        var sessions = [SISession]()

        if let records = json["sessions"].array {
            
            for record in records {
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
                    if let startDate = self.sessionDateFormatter.dateFromString(startDate.split("+")![0]) {
                        session.startDate = startDate
                    }
                }
            
                if let endDate = record["End_Date_Time__c"].string {
                    if let endDate = self.sessionDateFormatter.dateFromString(endDate.split("+")![0]) {
                        session.endDate = endDate
                    }
                }
                
                if let type = record["Session_Type__c"].string {
                    session.sessionType = session.parseSessionType(type)
                }
                
                if let track = record["Track__c"].string {
                    session.sessionTrack = track
                }
                
                if record["Room__r"].isExists() {
                    
                    let room = SIRoom()
                    
                    if let floor = record["Room__r"]["Floor"].string {
                        room.floor = floor
                    }
                    
                    if let roomName = record["Room__r"]["Name"].string {
                        room.name = roomName
                    }
                    
                    if let id = record["Room__r"]["Id"].string {
                        room.id = id
                    }
                    
                    if let xCoord = record["Room__r"]["Map_X_Coordinate__c"].double {
                        if let yCoord = record["Room__r"]["Map_Y_Coordinate__c"].double {
                            room.mapCoordinate = (xCoord, yCoord)
                        }
                    }
                    
                    session.room = room
                }
                
                if let summary = record["Summary__c"].string {
                    session.summary = summary
                }
                
                if let speakers = record["Session_Speaker_Associations__r"]["records"].array {
                    
                    for record in speakers {
                        let speaker = SISpeaker()
                        
                        if let id = record["Speaker__r"]["Id"].string {
                            speaker.id = id
                        }
                        session.speakers.append(speaker)
                    }
                }
                
                sessions.append(session)
            }
        }
        return sessions
    }
    
    /// Gets a single session using a session ID.
    func requestSession(id: String, callback: (session: SISession?) -> ()) {
        
        getRequest(url: EVENTS_URL + "/sessions/\(id)", description: "REQUEST SESSION") { json in
            
            guard let json = json else {
                callback(session: nil)
                return
            }
            
            let session = SISession()
            
            if json["session"] != nil {
                
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
                    if let startDate = self.sessionDateFormatter.dateFromString(startDate.split("+")![0]) {
                        session.startDate = startDate
                    }
                }
                
                if let endDate = record["End_Date_Time__c"].string {
                    if let endDate = self.sessionDateFormatter.dateFromString(endDate.split("+")![0]) {
                        session.endDate = endDate
                    }
                }
                
                if let type = record["Session_Type__c"].string {
                    session.sessionType = session.parseSessionType(type)
                }
                
                if let track = record["Track__c"].string {
                    session.sessionTrack = track
                }
                
                if let summary = record["Summary__c"].string {
                    session.summary = summary
                }
                
                if let roomName = record["Room__r"]["Name"].string {
                    session.room = SIRoom(name: roomName)
                }
                
            }
            
            callback(session: session)
        }
        
    }
    
    ///Gets all speakers from Salesforce, or use event ID to get all speakers for an event.
    func requestSpeakers(eventId id: String, callback: (speakers: [SISpeaker]?) -> Void) {
        
        getRequest(url: EVENTS_URL + "/speakers?event_id=\(id)", description: "REQUEST SPEAKERS, EVENT", callback: { json in
            
            guard let json = json else {
                callback(speakers: nil)
                return
            }
            
            callback(speakers: self.parseSpeakerResponse(json))
            
        });
        
    }
    
    
    ///Gets all speakers from Salesforce, or use session ID to get all speakers for a session.
    func requestSpeakers(sessionId id: String, callback: (speakers: [SISpeaker]?) -> Void) {
        
        getRequest(url: EVENTS_URL + "/speakers?session_id=\(id)", description: "REQUEST SPEAKERS, SESSION") { json in
            
            guard let json = json else {
                callback(speakers: nil)
                return
            }
            
            callback(speakers: self.parseSpeakerResponse(json))
            
        }
        
    }
    
    /// Gets all speakers from salesforce.
    func requestSpeakers(callback: (speakers: [SISpeaker]?) -> Void) {
        
        getRequest(url: EVENTS_URL + "/speakers", description: "REQUEST SPEAKERS, ALL") { json in
            
            guard let json = json else {
                callback(speakers: nil)
                return
            }
            
            callback(speakers: self.parseSpeakerResponse(json))
            
        }
        
    }
    
    private func parseSpeakerResponse(json: JSON) -> [SISpeaker] {
        
        var speakers = [SISpeaker]()
        
        if let records = json["speakers"].array {
            
            for record in records {
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
                
                if let pictureURL = record["Picture_URL__c"].string {
                    speaker.pictureURL = pictureURL
                }
                
                if let biography = record["Speaker_Biography__c"].string {
                    speaker.biography = biography
                }
                
                if let contactEmail = record["Contact__r"]["Email"].string {
                    speaker.contactEmail = contactEmail
                }
                
                if let organization = record["Organization__r"]["Name"].string {
                    speaker.organizationName = organization
                }

                if let sessionAssocs = record["Session_Speaker_Associations__r"]["records"].array {
                    for session in sessionAssocs {
                        if let isKeynoteSpeaker = session["Is_Keynote_Speaker__c"].bool {
                            if isKeynoteSpeaker {
                                speaker.speakerType = .Keynote
                            } else {
                                speaker.speakerType = .Concurrent
                            }
                        }
                    }
                }
                
                if let assocs = record["Session_Speaker_Associations__r"]["records"].array {
                    for assoc in assocs {
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
        
        getRequest(url: EVENTS_URL + "/speakers/\(id)", description: "REQUEST SPEAKER, SINGLE", callback: { json in
            
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
                    speaker.organizationName = organization
                }
            
                if let assocs = record["Session_Speaker_Associations__r"]["records"].array {
                    for assoc in assocs {
                        if let id = assoc["Session__r"]["Id"].string {
                            speaker.associatedSessionIds.append(id)
                        }
                    }
                    
                }
                
            }
            
            callback(speaker: speaker)
        });
        
    }
    
    /// Gets all exhibitors for an event.
    func requestExhibitors(eventId id: String, callback: (exhibitors: [SIExhibitor]?) -> ()) {
        
        getRequest(url: EVENTS_URL + "/exhibitors?event_id=\(id)", description: "REQUEST EXHIBITORS, EVENT", callback: { json in
        
            guard let json = json else {
                callback(exhibitors: nil)
                return
            }
            
            var exhibitors = [SIExhibitor]()
            
            if let records = json["exhibitors"].array {
                
                for record in records {
                    
                    let exhibitor = SIExhibitor()
                    
                    if let id = record["Id"].string {
                        exhibitor.id = id
                    }
                    
                    if let name = record["Organization__r"]["Name"].string {
                        exhibitor.name = name
                    }
                    
                    if let summary = record["Organization__r"]["App_Abstract__c"].string {
                        exhibitor.summary = summary
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
    
    /// Requests additional information for an exhibitor using an exhibitor ID.
    func requestExhibitor(exhibitorId id: String, callback: (exhibitor: SIExhibitor?) -> ()) {
        
        getRequest(url: EVENTS_URL + "/exhibitors/\(id)", description: "REQUEST EXHIBITOR, SINGLE", callback: { json in
            
            guard let json = json else {
                callback(exhibitor: nil)
                return
            }
            
            let exhibitor = SIExhibitor()
            
            if json["exhibitor"] != nil {
                
                let record = json["exhibitor"]
                
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
            
            callback(exhibitor: exhibitor)
            
        })
        
    }
    
    /// Requests all hotels for a single event.
    func requestHotels(eventId id: String, callback: (hotels: [SIHotel]?) -> ()) {
        
        getRequest(url: EVENTS_URL + "/hotels?event_id=\(id)", description: "REQUEST HOTEL, EVENT", callback: { json in
        
            guard let json = json else {
                callback(hotels: nil)
                return
            }
            
            var hotels = [SIHotel]()
            
            if let records = json["hotels"].array {
                
                for record in records {
                    
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
                    
                    hotels.append(hotel)
                }
            }
            
            callback(hotels: hotels)
            
        });
        
    }
    
    /// Requets hotel and provides additional information than requestHotels().
    func requestHotel(hotelId id: String, callback: (hotel: SIHotel?) -> Void) {
        
        getRequest(url: EVENTS_URL + "/hotels/\(id)", description: "REQUEST HOTEL, DETAIL", callback: { json in
        
            guard let json = json else {
                callback(hotel: nil)
                return
            }
            
            let hotel = SIHotel()
            
            if json["hotel"] != nil {
                
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
                    if let records = record["Shingo_Prices__r"]["records"].array {
                        for record in records {
                            if let price = record["Price__c"].double {
                                hotel.prices.append(price)
                            }
                        }
                    }
                }
            }
            
            callback(hotel: hotel)
            
        });
        
    }
    
    /// Requests basic information for all recipients for an event.
    func requestRecipients(eventId id: String, callback: (recipients: [SIRecipient]?) -> Void) {
        
        getRequest(url: EVENTS_URL + "/recipients?event_id=\(id)", description: "REQUEST RECIPIENTS, EVENT", callback: { json in
        
            guard let json = json else {
                callback(recipients: nil)
                return
            }
            
            var recipients = [SIRecipient]()
            
            if let records = json["recipients"].array {
                
                for record in records {
                    let recipient = SIRecipient()
                    
                    if let id = record["Id"].string {
                        recipient.id = id
                    }
                    
                    if let name = record["Organization__r"]["Name"].string {
                        recipient.name = name
                    }
                    
                    if let logoURL = record["Organization__r"]["Logo__c"].string {
                        recipient.logoURL = logoURL
                    }
                    
                    if let awardType = record["Award_Type__c"].string {
                        recipient.awardType = self.parseRecipientAwardType(awardType)
                    }
                    
                    if let summary = record["Summary__c"].string {
                        recipient.summary = summary
                    }
                    
                    recipients.append(recipient)
                }
            }
            
            callback(recipients: recipients)
            
        });
        
    }
    
    /// Requests a single recipient with additional information.
    func requestRecipient(recipientId id: String, callback: (recipient: SIRecipient?) -> Void) {
        
        getRequest(url: EVENTS_URL + "/recipients/\(id)", description: "REQUEST RECIPIENT, DETAIL", callback: { json in
        
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
    
    /// Requests rooms for a venue.
    func requestRooms(venueId id: String, callback: (rooms: [SIRoom]?) -> Void) {
        
        getRequest(url: EVENTS_URL + "/rooms?venue_id=\(id)", description: "REQUEST ROOMS, VENUE", callback: { json in
        
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
    
    /// Requests a room and provides additional information than requestRooms().
    func requestRoom(roomId id: String, callback: (room: SIRoom?) -> Void) {
        
        getRequest(url: EVENTS_URL + "/rooms/\(id)", description: "REQUEST ROOM, DETAIL", callback: { json in
        
            guard let json = json else {
                callback(room: nil)
                return
            }
            
            let room = SIRoom()
            
            if json["room"] != nil {
                
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
    
    /// Requests all sponsors for an event.
    func requestSponsors(eventId id: String, callback: (sponsors: [SISponsor]?) -> Void) {
        
        getRequest(url: EVENTS_URL + "/sponsors?event_id=\(id)", description: "REQUEST SPONSORS, EVENT", callback: { json in
        
            guard let json = json else {
                callback(sponsors: nil)
                return
            }
            
//            let testJSON = TestCode.generateTestCode()
            
            var sponsors = [SISponsor]()
            
            if let records = json["sponsors"].array {
                
                for record in records {
                    
                    let sponsor = SISponsor()
                    
                    if let id = record["Id"].string {
                        sponsor.id = id
                    }
                    
                    if let organization = record["Organization__r"]["Name"].string {
                        sponsor.name = organization
                    }
                    
                    if let logoURL = record["Organization__r"]["Logo__c"].string {
                        sponsor.logoURL = logoURL
                    }
                    
                    if let bannerURL = record["Banner_URL__c"].string {
                        sponsor.bannerURL = bannerURL
                    }
                    
                    if let splashScreenURL = record["Splash_Screen_URL__c"].string {
                        sponsor.splashScreenURL = splashScreenURL
                    }
                    
                    if let type = record["Sponsor_Level__c"].string {
                        sponsor.sponsorType = self.getSponsorType(type: type)
                    }
                    
                    sponsors.append(sponsor)
                }
            }
            
            callback(sponsors: sponsors)
            
        });
        
    }
    
    /// Requests detailed information for a sponsor.
    func requestSponsor(sponsorId id: String, callback: (sponsor: SISponsor?) -> Void) {
       
        getRequest(url: EVENTS_URL + "/sponsors/\(id)", description: "REQUEST SPONSOR, DETAIL", callback: { json in
        
            guard let json = json else {
                callback(sponsor: nil)
                return
            }
            
            let sponsor = SISponsor()
            
            if json["sponsor"].isExists() {
                
                let record = json["sponsor"]
                
                if let id = record["Id"].string {
                    sponsor.id = id
                }
                
                if let name = record["Name"].string {
                    sponsor.name = name
                }
                
                if let logoURL = record["Logo__c"].string {
                    sponsor.logoURL = logoURL
                }
                
                if let summary = record["App_Abstract__c"].string {
                    sponsor.summary = summary
                }
                
                if let bannerURL = record["Banner_URL__c"].string {
                    sponsor.bannerURL = bannerURL
                }
                
                if let splashScreenURL = record["Splash_Screen_URL__c"].string {
                    sponsor.splashScreenURL = splashScreenURL
                }
                
                if let type = record["Sponsor_Level__c"].string {
                    sponsor.sponsorType = self.getSponsorType(type: type)
                }
            }
            
            callback(sponsor: sponsor)
            
        });
        
    }
    
    private func getSponsorType(type type: String) -> SISponsor.SponsorType {
        switch type {
            case "President": return .President
            case "Champion" : return .Champion
            case "Benefactor": return .Benefactor
            case "Supporter": return .Supporter
            case "Friend": return .Friend
            default: return .None
        }
    }
    
    /// Requests all venues for an event. Typically there will only be one venue per event, but there is the possibility of being more than one.
    func requestVenues(eventId id: String, callback: (venues: [SIVenue]?) -> Void) {
       
        getRequest(url: EVENTS_URL + "/venues?event_id=\(id)", description: "REQUEST VENUES, EVENT", callback: { json in
        
            guard let json = json else {
                callback(venues: nil)
                return
            }
            
            var venues = [SIVenue]()
            
            if let records = json["venues"].array {
                
                for record in records {
                    
                    let venue = SIVenue()
                    
                    if let id = record["Id"].string {
                        venue.id = id
                    }
                    
                    if let name = record["Name"].string {
                        venue.name = name
                    }
                    
                    if let address = record["Address__c"].string {
                        venue.address = address
                    }
                    
                    venues.append(venue)
                }
            }
            
            callback(venues: venues)
            
        });
        
    }
    
    /// Requests detailed information for a single venue.
    func requestVenue(venueId id: String, callback: (venue: SIVenue?) -> Void) {
        
        getRequest(url: EVENTS_URL + "/venues/\(id)", description: "REQUEST VENUE, DETAIL", callback: { json in
        
            guard let json = json else {
                callback(venue: nil)
                return
            }
            
            let venue = SIVenue()
            
            if json["venue"].isExists() {
                
                let record = json["venue"]
                
                if let id = record["Id"].string {
                    venue.id = id
                }
                
                if let name = record["Name"].string {
                    venue.name = name
                }
                
                if let address = record["Address__c"].string {
                    venue.address = address
                }
                
                if let xCoord = record["Venue_Location__c"]["longitude"].float {
                    if let yCoord = record["Venue_Location__c"]["latitude"].float {
                        venue.location = CLLocationCoordinate2D(latitude: CLLocationDegrees.init(yCoord), longitude: CLLocationDegrees.init(xCoord))
                    }
                }
                
                if let type = record["Venue_Type__c"].string {
                    venue.venueType = self.parseVenueType(type: type)
                }

                if let maps__r = record["Maps__r"]["records"].array {
                    for map in maps__r {
                        
                        let venueMap = SIVenueMap()
                        
                        if let name = map["Name"].string {
                            venueMap.name = name
                        }
                        
                        if let floor = map["Floor__c"].int {
                            venueMap.floor = floor
                        }
                        
                        if let mapURL = map["URL__c"].string {
                            venueMap.mapURL = mapURL
                        }
                        venue.venueMaps.append(venueMap)
                    }
                }
                
            }
            
            callback(venue: venue)
            
        });
        
    }
    
    private func parseVenueType(type type: String) -> SIVenue.VenueType{
        
        switch type {
            case "Convention Center": return .ConventionCenter
            case "Hotel": return .Hotel
            case "Museum": return .Museum
            case "Restaurant": return .Restaurant
            case "Other": return .Other
            default: return .None
        }
        
    }
    
    /// Requests all affiliates from salesforce.
    func requestAffiliates(callback: (affiliates: [SIAffiliate]?) -> ()) {
        
        getRequest(url: BASE_URL + "/salesforce/affiliates", description: "REQUEST AFFILIATES, ALL") { (json) in
            guard let json = json else {
                callback(affiliates: nil)
                return
            }
            
            var affiliates = [SIAffiliate]()
            
            if let records = json["affiliates"].array {
                for record in records {
                    
                    let affiliate = SIAffiliate()
                    
                    if let id = record["Id"].string {
                        affiliate.id = id
                    }
                    
                    if let name = record["Name"].string {
                        affiliate.name = name
                    }
                    
                    if let logoURL = record["Logo__c"].string {
                        affiliate.logoURL = logoURL
                    }
                    
                    if let websiteURL = record["Website"].string {
                        affiliate.websiteURL = websiteURL
                    }
                    
                    if let summary = record["App_Abstract__c"].string {
                        affiliate.summary = summary
                    }
                    
                    affiliates.append(affiliate)
                }
            }
            
            callback(affiliates: affiliates)
        }
        
    }
    
    /// Posts a bug report to the backend server.
    func postBugReport(parameters: [String:String], callback: (Bool) -> Void) {
        
        postRequest(url: SUPPORT_URL + "/bugs", description: "POST BUG REPORT",parameters: parameters) { (json) in
            guard let json = json else {
                callback(false)
                return
            }
            
            if let success = json["success"].bool {
                callback(success)
            } else {
                callback(false)
            }
        }
    }
    
    /// Posts feedback to the backend server.
    func postFeedback(parameters: [String:String], callback: (Bool) -> Void) {
        
        postRequest(url: SUPPORT_URL + "/feedback", description: "POST FEEDBACK", parameters: parameters) { (json) in
            guard let json = json else {
                callback(false)
                return
            }
            
            if let success = json["success"].bool {
                callback(success)
            } else {
                callback(false)
            }
        }
    }
    
    // MARK: - Other
    
    class func displayInternetAlert(forViewController vc: UIViewController, completion: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(
            title: "Connection Error",
            message: "Could not connect to server. The Internet connection appears to be offline.",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        let action = UIAlertAction(title: "Okay", style: .Cancel, handler: completion)

        alert.addAction(action)
        
        vc.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func marks(string: String) -> String {
        let count = string.characters.count
        var marks = ""
        for _ in 0 ..< count + 1 {
            marks += "-"
        }
        return "\(marks)+"
    }
    
}









