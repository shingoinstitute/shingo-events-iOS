//
//  SISession.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/21/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation
import Alamofire

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
    var didLoadSessionDetails : Bool
    var speakers : [SISpeaker]
    
    var displayName : String
    var sessionType : SessionType
    var sessionTrack : String
    var room : SIRoom?
    var startDate : Date
    var endDate : Date
    
    override init() {
        didLoadSpeakers = false
        didLoadSessionDetails = false
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
                self.didLoadSessionDetails = true
                
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
