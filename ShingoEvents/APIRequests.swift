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
    
    var dateFormatter : NSDateFormatter!
    
    init() {
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
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
                print("Error while performing API GET request: \(response.result.error)")
                callback(value: nil)
                return
            }
            
            guard let response = response.result.value else {
                print("Error while performing API GET request: Invalid response")
                callback(value: nil)
                return
            }
            
            let responseJSON = JSON(response)
            print(responseJSON)
            callback(value: responseJSON)
        }
    }
    
    
    ///////////////
    // API Calls //
    ///////////////
    
    // Gets all events from Salesforce
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
                            event.startDate = self.dateFormatter.dateFromString(startDate)
                        }
                        
                        if let endDate = record["End_Date__c"].string {
                            event.endDate = self.dateFormatter.dateFromString(endDate)
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
    
    // Gets an event from Salesforce by id
    func requestEvent(id: String, callback: (event: SIEvent) -> Void) {
        
        getRequest(url: EVENTS_URL + "/\(id)") { json in
            
            let event = SIEvent()
            
            if let json = json {
                
                if let id = json["Id"].string {
                    event.id = id
                }
                
                if let name = json["Name"].string {
                    event.name = name
                }
                
                if let startDate = json["Start_Date__c"].string {
                    event.startDate = self.dateFormatter.dateFromString(startDate)
                }
                
                if let endDate = json["End_Date__c"].string {
                    event.endDate = self.dateFormatter.dateFromString(endDate)
                }
                
                if let type = json["Event_Type__c"].string {
                    event.eventType = type
                }
                
                if let bannerURL = json["Banner_URL__c"].string {
                    event.bannerImageURL = bannerURL
                }
                
                if let salesText = json["Sales_Text__c"].string {
                    event.salesText = salesText
                }
                
            }
            callback(event: event)
        }
        
    }
    
    // Gets all days for a single event
    func requestDays(eventId eventId: String, callback: (agendas: [SIAgenda]?) -> Void) {
        
        postRequest(url: EVENTS_URL + "/days", parameters: ["event_id": eventId]) { json in
            
            guard let json = json else {
                callback(agendas: nil)
                return
            }
            
            callback(agendas: self.parseDaysRequest(json))
        }
    }
    
    // Gets all days from Salesforce
    func requestDays(callback: (agendas: [SIAgenda]?) -> ()) {
        
        getRequest(url: EVENTS_URL + "/days") { json in
            
            guard let json = json else {
                callback(agendas: nil)
                return
            }
            
            callback(agendas: self.parseDaysRequest(json))
        }
        
    }

    func parseDaysRequest(json: JSON) -> [SIAgenda] {
        
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
                
                agendas.append(agenda)
            }
        }
        return agendas
    }
    
    // Gets a single day by id.
    func requestDay(id: String, callback: (agenda: SIAgenda?) -> ()) {
        
        getRequest(url: EVENTS_URL + "/days?\(id)") { json in
            
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
                            session.startDate = self.dateFormatter.dateFromString(startDate)
                        }
                        
                        if let endDate = record["End_Date_Time__c"].string {
                            session.endDate = self.dateFormatter.dateFromString(endDate)
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
    
    // Gets all sessions from for a single event
    func requestSessions(id id: String, callback: (sessions: [SISession]?) -> ()) {
        postRequest(url: EVENTS_URL + "/sessions", parameters: ["agenda_id":id]) { json in
            
            guard let json = json else {
                callback(sessions: nil)
                return
            }
            
            callback(sessions: self.parseSessionResponse(json))
        }
    }
    
    // Gets all sessions from Salesforce
    func requestSessions(callback: (sessions: [SISession]?) -> ()) {
        
        getRequest(url: EVENTS_URL + "/sessions") { json in
            
            guard let json = json else {
                callback(sessions: nil)
                return
            }
            
            callback(sessions: self.parseSessionResponse(json))
            
        }
        
    }
    
    func parseSessionResponse(json: JSON) -> [SISession] {
        
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
                    session.startDate = self.dateFormatter.dateFromString(startDate)
                }
                
                if let endDate = record["End_Date_Time__c"].string {
                    session.endDate = self.dateFormatter.dateFromString(endDate)
                }
                
                if let type = record["Session_Type__c"].string {
                    session.sessionType = type
                }
                
                sessions.append(session)
            }
        }
        return sessions
    }
    
    // Gets a single session by id
    func requestSession(id: String, callback: (session: SISession?) -> ()) {
        
        getRequest(url: EVENTS_URL + "sessions/\(id)") { json in
            
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
                    session.startDate = self.dateFormatter.dateFromString(startDate)
                }
                
                if let endDate = record["End_Date_Time__c"].string {
                    session.endDate = self.dateFormatter.dateFromString(endDate)
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
    
    // Gets all speakers from Salesforce
    func requestSpeakers(sessionId id: String, callback: (speakers: [SISpeaker]?) -> ()) {
        
        postRequest(url: EVENTS_URL + "/speakers", parameters: ["session_id":id]) { json in
            
            guard let json = json else {
                callback(speakers: nil)
                return
            }
            
            callback(speakers: self.parseSpeakerResponse(json))
            
        }
        
    }
    
    // Gets all speakers for a single session
    func requestSpeakers(callback: (speakers: [SISpeaker]?) -> ()) {
        
        getRequest(url: EVENTS_URL + "/speakers") { json in
            
            guard let json = json else {
                callback(speakers: nil)
                return
            }
            
            callback(speakers: self.parseSpeakerResponse(json))
            
        }
        
    }
    
    func parseSpeakerResponse(json: JSON) -> [SISpeaker] {
        
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
    
    // Gets a single speaker by id
    func requestSpeaker(speakerId id: String, callback: (speaker: SISpeaker?) -> ()) {
        
        getRequest(url: EVENTS_URL + "/speakers/\(id)") { json in
            
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
        }
        
    }


    
}