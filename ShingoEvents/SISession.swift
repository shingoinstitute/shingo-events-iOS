//
//  SISession.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/21/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation
import Alamofire

protocol SISessionDelegate {
    func onSpeakerRequestComplete()
    func onSessionDetailRequestComplete()
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
    var didLoadSessionDetails : Bool
    var speakers : [SISpeaker]
    
    var displayName : String
    var sessionType : SessionType
    var sessionTrack : String
    var room : SIRoom?
    var startDate : SIDate
    var endDate : SIDate
    
    var tableviewCellDelegate: SISessionDelegate?
    
    override init() {
        didLoadSpeakers = false
        didLoadSessionDetails = false
        speakers = [SISpeaker]()
        displayName = ""
        startDate = SIDate()
        endDate = SIDate()
        sessionType = .none
        sessionTrack = ""
        room = nil
        super.init()
    }
    
    var sessionRequest: Alamofire.Request? {
        get {
            return self._sessionRequest
        }
    }
    
    private var _sessionRequest: Alamofire.Request? {
        willSet (newRequest) {
            if let request = self._sessionRequest {
                request.cancel()
            }
            self._sessionRequest = newRequest
        }
    }
    
    var speakerRequest: Alamofire.Request? {
        get {
            return self._speakersRequest
        }
    }
    
    private var _speakersRequest: Alamofire.Request? {
        willSet (newRequest) {
            if let request = self._speakersRequest {
                request.cancel()
            }
            self._speakersRequest = newRequest
        }
    }
    
    /// Gets additional information about the session object.
    func requestSessionInformation(_ callback: (() -> ())?) {
        
        if didLoadSessionDetails || _sessionRequest != nil {
            if let done = callback {
                done()
            }
            return
        }
        
        _sessionRequest = SIRequest().requestSession(sessionId: id, callback: { session in
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
                self.didLoadSpeakers = session.didLoadSpeakers
                self.speakers = session.speakers
                
                self.didLoadSessionDetails = true
                
                self.requestSpeakers(nil)
                
                self._sessionRequest = nil
                
                if let delegate = self.tableviewCellDelegate {
                    delegate.onSessionDetailRequestComplete()
                }
                
                if let done = callback {
                    return done()
                }
            }
        });
    }
    
    /// Gets all speakers associated with the session object.
    func requestSpeakers(_ callback: (() -> ())?) {
        
        if _speakersRequest != nil || didLoadSpeakers {
            if let done = callback {
                done()
            }
            return
        }
        
        _speakersRequest = SIRequest().requestSpeakers(sessionId: id, callback: { speakers in
            if let speakers = speakers {
                self.speakers = speakers
                self.didLoadSpeakers = true
            }
            
            self._speakersRequest = nil
            
            if let delegate = self.tableviewCellDelegate {
                delegate.onSpeakerRequestComplete()
            }
            
            if let done = callback {
                return done()
            }
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
