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
import SwiftyJSON
import Crashlytics

class SIRequest {
    
    static let BASE_URL = "https://api.shingo.org"
    static let EVENTS_URL = BASE_URL + "/salesforce/events"
    static let SUPPORT_URL = BASE_URL + "/support"
    
    // Important! DateFormatter defaults timezone to MST, which is the timezone dates/times always originate from
    static let dateFormatter = DateFormatter(dateFormat: "yyyy-MM-dd")
    static let sessionDateFormatter = DateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
    
    /// HTTP GET request method.
    func getRequest(url: String, description: String, callback: @escaping (JSON?) -> ()) -> Alamofire.Request? {
        return Alamofire.request(url).responseJSON(queue: DispatchQueue.global(qos: .utility), options: .allowFragments) { (response) in
            print("+-\(self.marks(description))")
            print("| \(description) |")
            print("+-\(self.marks(description))")
            
            guard response.result.isSuccess else {
                print("Error while performing API GET request: \(response.result.error!)")
                print("+-\(self.marks(description + " - END"))")
                print("| \(description + " - END") |")
                print("+-\(self.marks(description + " - END"))")
                return callback(nil)
                
            }
            
            guard let response = response.result.value else {
                print("Error while performing API GET request: Invalid response")
                print("+-\(self.marks(description + " - END"))")
                print("| \(description + " - END") |")
                print("+-\(self.marks(description + " - END"))")
                return callback(nil)
            }
            
            let responseJSON = JSON(response)
            
            print(responseJSON)
            
            print("+-\(self.marks(description + " - END"))")
            print("| \(description + " - END") |")
            print("+-\(self.marks(description + " - END"))")
            
            if let success = responseJSON["success"].bool {
                if !success {
                    return callback(nil)
                }
            }
            return callback(responseJSON)
        }
        
    }
    
    /// HTTP POST request method.
    func postRequest(url: String, description: String, parameters: [String:String], callback: @escaping (_ value: JSON?) -> ()) -> Alamofire.Request? {
        return Alamofire.request(url, parameters: parameters).responseJSON { response in
            
            guard response.result.isSuccess else {
                print("Error while performing API POST request: \(response.result.error!)")
                callback(nil)
                return
            }
            
            guard let response = response.result.value else {
                print("Error while performing API POST request: Invalid response")
                callback(nil)
                return
            }
            
            print(JSON(response))
            
            print("+-\(self.marks(description + " - END"))")
            print("| \(description + " - END") |")
            print("+-\(self.marks(description + " - END"))")
            
            callback(JSON(response))
        }
    }
    

    // MARK: - API Calls
    
    /// Returns all ready-to-publish events from Salesforce.
    @discardableResult func requestEvents(_ callback: @escaping ([SIEvent]?) -> Void) -> Alamofire.Request? {
        return getRequest(url: SIRequest.EVENTS_URL + "?publish_to_web=true", description: "REQUEST EVENTS") { json in
            guard let json = json else {
                callback(nil)
                return
            }
            var events = [SIEvent]()
            if let records = json["events"].array {
                
                for record in records {
                    
                    let event = SIEvent()
                    
                    if let id = record["Id"].string {
                        event.id = id
                    }
                    
                    if let name = record["Name"].string {
                        event.name = name
                    }
                    
                    if let startDate = record["Start_Date__c"].string {
                        if let startDate = SIRequest.dateFormatter.date(from: startDate) {
                            event.startDate = self.getDateFromOffset(date: startDate)
                        }
                    }
                    
                    if let endDate = record["End_Date__c"].string {
                        if let endDate = SIRequest.dateFormatter.date(from: endDate) {
                            event.endDate = self.getDateFromOffset(date: endDate)
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
            callback(events)
        }
    }
    
    /// Returns an event from Salesforce using an event ID.
    @discardableResult func requestEvent(eventId: String, callback: @escaping (SIEvent?) -> Void) -> Alamofire.Request? {
        
        return getRequest(url: SIRequest.EVENTS_URL + "/\(eventId)", description: "REQUEST EVENT") { json in
            
            guard let json = json else {
                callback(nil)
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
                    if let startDate = SIRequest.dateFormatter.date(from: startDate) {
                        event.startDate = self.getDateFromOffset(date: startDate)
                    }
                }
                
                if let endDate = record["End_Date__c"].string {
                    if let endDate = SIRequest.dateFormatter.date(from: endDate) {
                        event.endDate = self.getDateFromOffset(date: endDate)
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
                
                if let attendeeRecords = record["Shingo_Attendees__r"]["records"].array {
                    
                    var attendees = [SIAttendee]()
                    
                    for record in attendeeRecords {
                        
                        let attendee = SIAttendee()
                        
                        let contact = record["Contact__r"]
                        
                        if let id = contact["Id"].string {
                            attendee.id = id
                        }
                        
                        if let name = contact["Name"].string {
                            attendee.name = name
                        }
                        
                        if let title = contact["Title"].string {
                            attendee.title = title
                        }
                        
                        if let org = contact["Account"]["Name"].string {
                            attendee.organization = org
                        }
                        
                        if let pictureURL = contact["Photograph__c"].string {
                            attendee.pictureURL = pictureURL
                        }
                        
                        attendees.append(attendee)
                        
                    }
                    event.attendees = attendees
                }
                
                if let ads = record["Sponsor_Ads__r"]["records"].array {
                    for ad in ads {
                        
                        guard let adId = ad["Id"].string else {
                            continue
                        }
                        
                        guard let adName = ad["Name"].string else {
                            continue
                        }
                        
                        guard let adEventId = ad["Event__c"].string else {
                            continue
                        }
                        
                        guard let sponsorId = ad["Sponsor__c"].string else {
                            continue
                        }
                        
                        guard let imageUrl = ad["Image_URL__c"].string else {
                            continue
                        }
                        
                        guard let adType = ad["Ad_Type__c"].string else {
                            continue
                        }

                        event.append(advertisement: SponsorAd(id: adId,
                                                              name: adName,
                                                              parentEventId: adEventId,
                                                              parentSponsorId: sponsorId,
                                                              imageURL: imageUrl,
                                                              adType: SponsorAd.parseType(adType)))

                        
                    }
                }
                
            }
            callback(event)
        }
        
    }
    
    /// Gets all days for a single event using an event ID.
    @discardableResult func requestAgendaDays(eventId: String, callback: @escaping ([SIAgenda]?) -> Void) -> Alamofire.Request? {

        return getRequest(url: SIRequest.EVENTS_URL + "/days?event_id=\(eventId)", description: "REQUEST AGENDA FOR EVENT") { json in
            
            guard let json = json else {
                callback(nil)
                return
            }
            
            callback(self.parseDaysRequest(json))
        }
    }
    
    /// Gets all days from Salesforce.
    @discardableResult func requestAgendaDays(_ callback: @escaping ([SIAgenda]?) -> ()) -> Alamofire.Request? {
        
        return getRequest(url: SIRequest.EVENTS_URL + "/days", description: "REQUEST AGENDAS, ALL") { json in
            
            guard let json = json else {
                callback(nil)
                return
            }
            
            callback(self.parseDaysRequest(json))
        }
        
    }

    fileprivate func parseDaysRequest(_ json: JSON) -> [SIAgenda] {
        
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
                    if let date = SIRequest.dateFormatter.date(from: date) {
                        agenda.date = getDateFromOffset(date: date)
                    }
                }
                
                agendas.append(agenda)
            }
        }
        return agendas
    }
    
    /// Gets basic information for sessions associated with an SIAgenda.
    @discardableResult func requestAgendaSessions(agendaId id: String, callback: @escaping (_ sessions: [SISession]?) -> Void) -> Alamofire.Request? {
        
        return getRequest(url: SIRequest.EVENTS_URL + "/days/\(id)", description: "REQUEST SESSIONS, BASIC") { json in
            
            guard let json = json else {
                callback(nil)
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
                        if let startDate = SIRequest.sessionDateFormatter.date(from: startDate) {
                            session.startDate = self.getDateFromOffset(date: startDate)
                        }
                    }
                    
                    if let endDate = record["End_Date_Time__c"].string {
                        if let endDate = SIRequest.sessionDateFormatter.date(from: endDate) {
                            session.endDate = self.getDateFromOffset(date: endDate)
                        }
                    }
                    
                    if let type = record["Session_Type__c"].string {
                        session.sessionType = session.parseSessionType(type)
                    }
                    
                    sessions.append(session)
                }
            }
            callback(sessions)
        }
    }
    
    /// Gets all sessions for a single event using an agenda ID. Note: Provides more detail than requestAgendaSessions().
    @discardableResult func requestSessions(agendaId id: String, callback: @escaping ([SISession]?) -> ()) -> Alamofire.Request? {
        return getRequest(url: SIRequest.EVENTS_URL + "/sessions?agenda_id=\(id)", description: "REQUEST SESSIONS, DETAILED") { json in
            
            guard let json = json else {
                callback(nil)
                return
            }
            
            callback(self.parseSessionResponse(json: json))
        }
    }
    
    /// Gets all sessions from Salesforce.
    @discardableResult func requestSessions(_ callback: @escaping ([SISession]?) -> ()) -> Alamofire.Request? {
        return getRequest(url: SIRequest.EVENTS_URL + "/sessions", description: "REQUEST SESSIONS, ALL") { json in
            
            guard let json = json else {
                callback(nil)
                return
            }
            
            callback(self.parseSessionResponse(json: json))
            
        }
        
    }
    
    fileprivate func parseSessionResponse(json: JSON) -> [SISession] {
        
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
                    if let startDate = SIRequest.sessionDateFormatter.date(from: startDate) {
                        session.startDate = self.getDateFromOffset(date: startDate)
                    }
                }
            
                if let endDate = record["End_Date_Time__c"].string {
                    if let endDate = SIRequest.sessionDateFormatter.date(from: endDate) {
                        session.endDate = self.getDateFromOffset(date: endDate)
                    }
                }
                
                if let type = record["Session_Type__c"].string {
                    session.sessionType = session.parseSessionType(type)
                }
                
                if let track = record["Track__c"].string {
                    session.sessionTrack = track
                }
                
                if record["Room__r"] != nil {
                    
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
                    if let attributedSummary = SIRequest.parseHTMLStringUsingPreferredFont(string: summary) {
                        session.attributedSummary = attributedSummary
                    }
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
    @discardableResult func requestSession(_ id: String, callback: @escaping (SISession?) -> ()) -> Alamofire.Request? {
        
        return getRequest(url: SIRequest.EVENTS_URL + "/sessions/\(id)", description: "REQUEST SESSION") { json in
            
            guard let json = json else {
                callback(nil)
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
                    if let startDate = SIRequest.sessionDateFormatter.date(from: startDate) {
                        session.startDate = self.getDateFromOffset(date: startDate)
                    }
                }
                
                if let endDate = record["End_Date_Time__c"].string {
                    if let endDate = SIRequest.sessionDateFormatter.date(from: endDate) {
                        session.endDate = self.getDateFromOffset(date: endDate)
                    }
                }
                
                if let type = record["Session_Type__c"].string {
                    session.sessionType = session.parseSessionType(type)
                }
                
                if let track = record["Track__c"].string {
                    session.sessionTrack = track
                }
                
                if let summary = record["Summary__c"].string {
                    if !summary.isEmpty {
                        if let attributedSummary = SIRequest.parseHTMLStringUsingPreferredFont(string: summary) {
                            session.attributedSummary = attributedSummary
                        }
                    }
                }
                
                if let roomName = record["Room__r"]["Name"].string {
                    session.room = SIRoom(name: roomName)
                }
                
            }
            
            callback(session)
        }
        
    }
    
    ///Gets all speakers from Salesforce, or use event ID to get all speakers for an event.
    @discardableResult func requestSpeakers(eventId id: String, callback: @escaping ([SISpeaker]?) -> Void) -> Alamofire.Request? {
        
        return getRequest(url: SIRequest.EVENTS_URL + "/speakers?event_id=\(id)", description: "REQUEST SPEAKERS, EVENT", callback: { json in
            
            guard let json = json else {
                callback(nil)
                return
            }
            
            callback(self.parseSpeakerResponse(json: json))
            
        });
        
    }
    
    
    ///Gets all speakers from Salesforce, or use session ID to get all speakers for a session.
    @discardableResult func requestSpeakers(sessionId id: String, callback: @escaping ([SISpeaker]?) -> Void) -> Alamofire.Request? {
        
        return getRequest(url: SIRequest.EVENTS_URL + "/speakers?session_id=\(id)", description: "REQUEST SPEAKERS, SESSION") { json in
            
            guard let json = json else {
                callback(nil)
                return
            }
            
            callback(self.parseSpeakerResponse(json: json))
            
        }
        
    }
    
    /// Gets all speakers from salesforce.
    @discardableResult func requestSpeakers(_ callback: @escaping ([SISpeaker]?) -> Void) -> Alamofire.Request? {
        
        return getRequest(url: SIRequest.EVENTS_URL + "/speakers", description: "REQUEST SPEAKERS, ALL") { json in
            
            guard let json = json else {
                callback(nil)
                return
            }
            
            callback(self.parseSpeakerResponse(json: json))
            
        }
        
    }
    
    fileprivate func parseSpeakerResponse(json: JSON) -> [SISpeaker] {
        
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
                    if let attributedSummary = SIRequest.parseHTMLStringUsingPreferredFont(string: biography) {
                        speaker.attributedSummary = attributedSummary
                    }
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
                                speaker.speakerType = .keynote
                            } else {
                                speaker.speakerType = .concurrent
                            }
                        }
                    }
                } else {
                    speaker.speakerType = .concurrent
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
    @discardableResult func requestSpeaker(speakerId id: String, callback: @escaping (SISpeaker?) -> ()) -> Alamofire.Request? {
        
        return getRequest(url: SIRequest.EVENTS_URL + "/speakers/\(id)", description: "REQUEST SPEAKER, SINGLE", callback: { json in
            
            guard let json = json else {
                callback(nil)
                return
            }
            
            let speaker = SISpeaker()
            
            if json["speaker"] != nil {
                
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
                    if let attributedSummary = SIRequest.parseHTMLStringUsingPreferredFont(string: biography) {
                        speaker.attributedSummary = attributedSummary
                    }
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
            
            callback(speaker)
        });
        
    }
    
    /// Gets all exhibitors for an event.
    @discardableResult func requestExhibitors(eventId id: String, callback: @escaping ([SIExhibitor]?) -> ()) -> Alamofire.Request? {
        
        return getRequest(url: SIRequest.EVENTS_URL + "/exhibitors?event_id=\(id)", description: "REQUEST EXHIBITORS, EVENT", callback: { json in
        
            guard let json = json else {
                callback(nil)
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
                    
                    if let summary = record["Organization__r"]["Summary__c"].string  {
                        if let attributedSummary = SIRequest.parseHTMLStringUsingPreferredFont(string: summary) {
                            exhibitor.attributedSummary = attributedSummary
                        }
                    } else if let summary = record["Organization__r"]["App_Abstract__c"].string {
                        if let attributedSummary = SIRequest.parseHTMLStringUsingPreferredFont(string: summary) {
                            exhibitor.attributedSummary = attributedSummary
                        }
                    }
                    
                    if let logoURL = record["Organization__r"]["Logo__c"].string {
                        exhibitor.logoURL = logoURL
                    }
                    
                    exhibitors.append(exhibitor)
                }
                
            }
          
            callback(exhibitors)
            
        });
        
    }
    
    /// Requests additional information for an exhibitor using an exhibitor ID.
    @discardableResult func requestExhibitor(exhibitorId id: String, callback: @escaping (SIExhibitor?) -> ()) -> Alamofire.Request? {
        
        return getRequest(url: SIRequest.EVENTS_URL + "/exhibitors/\(id)", description: "REQUEST EXHIBITOR, SINGLE", callback: { json in
            
            guard let json = json else {
                callback(nil)
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
                
                if let summary = organization["Summary__c"].string  {
                    if let attributedSummary = SIRequest.parseHTMLStringUsingPreferredFont(string: summary) {
                        exhibitor.attributedSummary = attributedSummary
                    }
                } else if let summary = organization["App_Abstract__c"].string {
                    if let attributedSummary = SIRequest.parseHTMLStringUsingPreferredFont(string: summary) {
                        exhibitor.attributedSummary = attributedSummary
                    }
                }
                
                if let email = organization["Public_Contact_Email__c"].string {
                    exhibitor.contactEmail = email
                }
                
                if let website = organization["Website"].string {
                    exhibitor.website = website
                }

            }
            
            callback(exhibitor)
            
        })
        
    }
    
    /// Requests all hotels for a single event.
    @discardableResult func requestHotels(eventId id: String, callback: @escaping ([SIHotel]?) -> ()) -> Alamofire.Request? {
        
        return getRequest(url: SIRequest.EVENTS_URL + "/hotels?event_id=\(id)", description: "REQUEST HOTEL, EVENT", callback: { json in
        
            guard let json = json else {
                callback(nil)
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
            
            callback(hotels)
            
        });
        
    }
    
    /// Requets hotel and provides additional information than requestHotels().
    @discardableResult func requestHotel(hotelId id: String, callback: @escaping (SIHotel?) -> Void) -> Alamofire.Request? {
        
        return getRequest(url: SIRequest.EVENTS_URL + "/hotels/\(id)", description: "REQUEST HOTEL, DETAIL", callback: { json in
        
            guard let json = json else {
                callback(nil)
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
            
            callback(hotel)
            
        });
        
    }
    
    /// Requests basic information for all recipients for an event.
    @discardableResult func requestRecipients(eventId id: String, callback: @escaping ([SIRecipient]?) -> Void) -> Alamofire.Request? {
        
        return getRequest(url: SIRequest.EVENTS_URL + "/recipients?event_id=\(id)", description: "REQUEST RECIPIENTS, EVENT", callback: { json in
        
            guard let json = json else {
                callback(nil)
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
                        if let attributedSummary = SIRequest.parseHTMLStringUsingPreferredFont(string: summary) {
                            recipient.attributedSummary = attributedSummary
                        }
                    }
                    
                    recipients.append(recipient)
                }
            }
            
            callback(recipients)
            
        });
        
    }
    
    /// Requests a single recipient with additional information.
    @discardableResult func requestRecipient(recipientId id: String, callback: @escaping (SIRecipient?) -> Void) -> Alamofire.Request? {
        
        return getRequest(url: SIRequest.EVENTS_URL + "/recipients/\(id)", description: "REQUEST RECIPIENT, DETAIL", callback: { json in
        
            guard let json = json else {
                callback(nil)
                return
            }
            
            let recipient = SIRecipient()
            
            if json["recipient"] != nil {
                
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
                    if let attributedSummary = SIRequest.parseHTMLStringUsingPreferredFont(string: summary) {
                        recipient.attributedSummary = attributedSummary
                    }
                }
            }
            
            callback(recipient)
            
        });
        
    }
    
    fileprivate func parseRecipientAwardType(_ awardType: String) -> SIRecipient.AwardType {
        switch awardType {
            case "Shingo Prize":
                return .shingoPrize
            case "Silver Medallion":
                return .silver
            case "Bronze Medallion":
                return .bronze
            case "Research":
                return .research
            case "Publication":
                return .publication
            default:
                return .none
        }
    }
    
    /// Requests rooms for a venue.
    @discardableResult func requestRooms(venueId id: String, callback: @escaping ([SIRoom]?) -> Void) -> Alamofire.Request? {
        
        return getRequest(url: SIRequest.EVENTS_URL + "/rooms?venue_id=\(id)", description: "REQUEST ROOMS, VENUE", callback: { json in
        
            guard let json = json else {
                callback(nil)
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
            
            callback(rooms)
            
        });
        
    }
    
    /// Requests a room and provides additional information than requestRooms().
    @discardableResult func requestRoom(roomId id: String, callback: @escaping (SIRoom?) -> Void) -> Alamofire.Request? {
        
        return getRequest(url: SIRequest.EVENTS_URL + "/rooms/\(id)", description: "REQUEST ROOM, DETAIL", callback: { json in
        
            guard let json = json else {
                callback(nil)
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

            callback(room)
            
        });
        
    }
    
    /// Requests all sponsors for an event.
    @discardableResult func requestSponsors(eventId id: String, callback: @escaping ([SISponsor]?) -> Void) -> Alamofire.Request? {
        
        return getRequest(url: SIRequest.EVENTS_URL + "/sponsors?event_id=\(id)", description: "REQUEST SPONSORS, EVENT", callback: { json in
        
            guard let json = json else {
                callback(nil)
                return
            }
            
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
            
            callback(sponsors)
            
        });
        
    }
    
    /// Requests detailed information for a sponsor.
    @discardableResult func requestSponsor(sponsorId id: String, callback: @escaping (SISponsor?) -> Void) -> Alamofire.Request? {
       
        return getRequest(url: SIRequest.EVENTS_URL + "/sponsors/\(id)", description: "REQUEST SPONSOR, DETAIL", callback: { json in
        
            guard let json = json else {
                return callback(nil)
            }
            
            let sponsor = SISponsor()
            
            if json["sponsor"] != nil {
                
                let record = json["sponsor"]
                print(record)
                if let id = record["Id"].string {
                    sponsor.id = id
                }
                
                if let splashScreenURL = record["Splash_Screen_URL__c"].string {
                    sponsor.splashScreenURL = splashScreenURL
                }
                
                if let name = record["Organization__r"]["Name"].string {
                    sponsor.name = name
                }
                
                if let logoURL = record["Organization__r"]["Logo__c"].string {
                    sponsor.logoURL = logoURL
                }
                
                if let summary = record["Organization__r"]["Summary__c"].string  {
                    if let attributedSummary = SIRequest.parseHTMLStringUsingPreferredFont(string: summary) {
                        sponsor.attributedSummary = attributedSummary
                    }
                } else if let summary = record["Organization__r"]["App_Abstract__c"].string {
                    if let attributedSummary = SIRequest.parseHTMLStringUsingPreferredFont(string: summary) {
                        sponsor.attributedSummary = attributedSummary
                    }
                }
                
                if let bannerURL = record["Banner_URL__c"].string {
                    sponsor.bannerURL = bannerURL
                }
                
                if let type = record["Sponsor_Level__c"].string {
                    sponsor.sponsorType = self.getSponsorType(type: type)
                }
            }
            
            callback(sponsor)
            
        });
        
    }
    
    fileprivate func getSponsorType(type: String) -> SISponsor.SponsorType {
        switch type {
            case "President": return .president
            case "Champion" : return .champion
            case "Benefactor": return .benefactor
            case "Supporter": return .supporter
            case "Friend": return .friend
            default: return .none
        }
    }
    
    /// Requests all venues for an event. Typically there will only be one venue per event, but there is the possibility of being more than one.
    @discardableResult func requestVenues(eventId id: String, callback: @escaping ([SIVenue]?) -> Void) -> Alamofire.Request? {
       
        return getRequest(url: SIRequest.EVENTS_URL + "/venues?event_id=\(id)", description: "REQUEST VENUES, EVENT", callback: { json in
        
            guard let json = json else {
                callback(nil)
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
            
            callback(venues)
            
        });
        
    }
    
    /// Requests detailed information for a single venue.
    @discardableResult func requestVenue(venueId id: String, callback: @escaping (SIVenue?) -> Void) -> Alamofire.Request? {
        
        return getRequest(url: SIRequest.EVENTS_URL + "/venues/\(id)", description: "REQUEST VENUE, DETAIL", callback: { json in
        
            guard let json = json else {
                callback(nil)
                return
            }
            
            let venue = SIVenue()
            
            if json["venue"] != nil {
                
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
            
            callback(venue)
            
        });
        
    }
    
    fileprivate func parseVenueType(type: String) -> SIVenue.VenueType{
        
        switch type {
            case "Convention Center": return .conventionCenter
            case "Hotel": return .hotel
            case "Museum": return .museum
            case "Restaurant": return .restaurant
            case "Other": return .other
            default: return .none
        }
        
    }
    
    /// Requests all affiliates from salesforce.
    @discardableResult static func requestAffiliates(callback: @escaping ([SIAffiliate]?) -> ()) -> Alamofire.Request? {
        
        return SIRequest().getRequest(url: SIRequest.BASE_URL + "/salesforce/affiliates", description: "REQUEST AFFILIATES, ALL") { (json) in
            guard let json = json else {
                callback(nil)
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
                        if let attributedSummary = SIRequest.parseHTMLStringUsingPreferredFont(string: summary) {
                            affiliate.attributedSummary = attributedSummary
                        }
                    }
                    
                    affiliates.append(affiliate)
                }
            }
            
            callback(affiliates)
        }
        
    }
    
    /// Posts a bug report to the backend server.
    class func postBugReport(parameters: Parameters, callback: @escaping (Bool) -> Void) {
        
        guard let email = parameters["email"] as? String else {
            return callback(false)
        }
        
        guard let description = parameters["description"] as? String else {
            return callback(false)
        }
        
        guard let device = parameters["device"] as? String else {
            return callback(false)
        }
        
        guard let details = parameters["details"] as? String else  {
            return callback(false)
        }
        
        let headers = [
            "content-type": "application/x-www-form-urlencoded",
            "cache-control": "no-cache",
        ]
        
        let postData = NSMutableData(data: "email=\(email)".data(using: .utf8)!)
        postData.append("&description=\(description)".data(using: .utf8)!)
        postData.append("&details=\(details)".data(using: .utf8)!)
        postData.append("&device=\(device)".data(using: .utf8)!)
        
        var request = URLRequest(url: URL(string: "https://api.shingo.org/support/bugs")!,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error: Error?) -> Void in
            
            DispatchQueue.main.async {
                
                if (error != nil) {
                    print(error!)
                    return callback(false)
                }
                
                guard let data = data else {
                    return callback(false)
                }

                do {
                    let parseJSON = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? NSDictionary

                    guard let value = parseJSON else {
                        return callback(false)
                    }

                    let json = JSON(value)

                    print(json)

                    guard let success = json["success"].bool else {
                        return callback(false)
                    }
                    
                    return callback(success)
                    
                } catch {
                    #if !DEBUG
                        Crashlytics.sharedInstance().recordError(error)
                    #endif
                    return callback(false)
                }
            }
            
        }).resume()
    }
    
    /**
     Posts feedback to the backend server.
     parameters expects the following key, value pairs
        :email:       - users email address
        :description: - feedback provided by user
        :device:      - users current device (i.e. iPhone 6)
        :details:     - ios version
        :rating:      - user rating (1-5 stars). If 0 stars, user did not give a rating
     
     This function doesn't use alamofire because of some header issues with the request.
     **/
    class func postFeedback(parameters: [String:String], callback: @escaping (Bool) -> Void) {
        
        // Validate that keys exist in the parameters object
        guard let email = parameters["email"] else {
            return callback(false)
        }
        
        guard let description = parameters["description"] else {
            return callback(false)
        }
        
        guard let device = parameters["device"] else {
            return callback(false)
        }
        
        guard let details = parameters["details"] else {
            return callback(false)
        }
        
        guard let rating = parameters["rating"] else {
            return callback(false)
        }
        
        // header content-type param must be x-www-form-urlencoded or the server will reject the request
        let headers = [
            "content-type": "application/x-www-form-urlencoded",
            "cache-control": "no-cache",
        ]
        
        // create utf8 encoded parameter string in http body
        let postData = NSMutableData(data: "email=\(email)".data(using: .utf8)!)
        postData.append("&description=\(description)".data(using: .utf8)!)
        postData.append("&details=\(details)".data(using: .utf8)!)
        postData.append("&device=\(device)".data(using: .utf8)!)
        postData.append("&rating=\(rating)".data(using: .utf8)!)
        
        // initialize request object and set property values
        var request = URLRequest(url: URL(string: "https://api.shingo.org/support/feedback")!,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        // Start session task and make request
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error: Error?) -> Void in
            
            // The response triggers UI events and must be processed on the main thread.
            DispatchQueue.main.async {
                
                if (error != nil) {
                    print(error!)
                    return callback(false)
                }
                
                guard let data = data else {
                    return callback(false)
                }
                
                do {
                    let parseJSON = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? NSDictionary
                    
                    guard let value = parseJSON else {
                        return callback(false)
                    }
                    
                    let json = JSON(value)
                    
                    print(json)
                    
                    guard let success = json["success"].bool else {
                        return callback(false)
                    }
                    
                    return callback(success)
                    
                } catch {
                    #if !DEBUG
                        Crashlytics.sharedInstance().recordError(error)
                    #endif
                    return callback(false)
                }
            }
            
        }).resume()
        
    }
    
    // MARK: - Other
    
    class func displayInternetAlert(forViewController vc: UIViewController, completion: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(
            title: "Connection Error",
            message: "Could not connect to server. The Internet connection appears to be offline.",
            preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "Okay", style: .cancel, handler: completion)

        alert.addAction(action)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    func marks(_ string: String) -> String {
        let count = string.characters.count
        var marks = ""
        for _ in 0 ..< count + 1 {
            marks += "-"
        }
        return "\(marks)+"
    }
    
    static func parseHTMLStringUsingPreferredFont(string: String) -> NSAttributedString? {
        
        do {
            
            let options: [String:Any] = [
                NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute : String.Encoding.utf8.rawValue,
            ]
            
            guard let data = string.data(using: String.Encoding.utf8) else {
                return nil
            }
            if (string.lowercased().contains("enjoy a glass of wine")) {
                print("foobar")
            }
            
            let htmlString = try NSMutableAttributedString(data: data, options: options, documentAttributes: nil)
            
            htmlString.usePreferredFontWhileMaintainingAttributes(forTextStyle: .body)
            
            return htmlString
        } catch {
            #if !DEBUG
            let error = NSError(domain: "NSAttributedStringErrorDomain",
                                code: 72283,
                                userInfo: [
                                NSLocalizedDescriptionKey : "Could not parse text into attributed string.",
                                NSLocalizedFailureReasonErrorKey: "Could not parse text for SIObject summary. Most likely reason is because the text string passed back from the API was not UTF-8 coding compliant."
                ])
            Crashlytics.sharedInstance().recordError(error)
            #endif
            return nil
        }
        
    }
    
    func getDateFromOffset(date: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents(in: TimeZone.current, from: date)
        if components.hour == nil {
            components.hour = 0
        }
        
        // off set in hours in current time zone from UTC
        let currentTZOffset = TimeZone.current.secondsFromGMT() / (60*60)
        // off set in hours in MST time zone from UTC
        let mstTZOffset = TimeZone.init(identifier: "MST")!.secondsFromGMT() / (60*60)
        
        components.hour! += Int(currentTZOffset + abs(mstTZOffset))
        guard let newDate = components.date else {
            return date
        }
        return newDate
    }
    
}









