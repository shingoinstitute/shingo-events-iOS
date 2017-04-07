//
//  SIRequestManager.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 4/7/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation
import Alamofire

protocol SIRequestManagerDelegate {
//    func onAgendaRequestComplete()
//    func onSpeakersRequestComplete()
//    func onAffiliateRequestComplete()
//    func onVenueRequestComplete()
//    func onRecipientRequestComplete()
//    func onSponsorRequestComplete()
//    func onAttendeeRequestComplete()
    func onRequestComplete(requestType type: SIRequestType)
}

enum SIRequestType {
    case event,
    agenda,
    speaker,
    recipient,
    affiliate,
    exhibitor,
    sponsor,
    attendee,
    sessions,
    venue,
    map,
    none
}

class SIRequestManager {
    
    var event: SIEvent
    
    var delegate: SIRequestManagerDelegate?
    
    var agendaRequests: Alamofire.Request?
    var speakersRequest: Alamofire.Request?
    var venueRequests: Alamofire.Request?
    var recipientRequests: Alamofire.Request?
    var affiliateRequests: Alamofire.Request?
    var exhibitorRequests: Alamofire.Request?
    var sponsorRequests: Alamofire.Request?
    var attendeeRequests: Alamofire.Request?
    var sessionRequests: [Alamofire.Request?] = [] {
        willSet (newRequests) {
            for request in sessionRequests {
                /**
                 If a request has stopped running, update value for `sessionRequests`,
                 otherwise allow current request to finish it's api requests.
                 */
                if !SIRequestManager.requestIsRunning(request: request) {
                    self.sessionRequests = newRequests
                    break;
                }
            }
        }
    }
    
    convenience init(event: SIEvent, delegate: UIViewController) {
        self.init(event: event)
        if let delegate = delegate as? SIRequestManagerDelegate {
            self.delegate = delegate
        }
    }
    
    init(event: SIEvent, delegate: SIRequestManagerDelegate? = nil) {
        self.event = event
        self.delegate = delegate
    }
    
    func requestAll() {
        
        requestAgendas()
        
        requestSpeakers()
        
        requestVenues()
        
        requestRecipients()
        
        requestAffiliates()
        
        requestExhibitors()
        
        requestSponsors()
        
        requestAttendees()
    }
    
    /// Requests all agendas for an event
    func requestAgendas() {
        
        if !event.didLoadAgendas && !SIRequestManager.requestIsRunning(request: agendaRequests) {
            agendaRequests = event.requestAgendas() {
                self.event.didLoadAgendas = true
                
                if let delegate = self.delegate {
                    delegate.onRequestComplete(requestType: .agenda)
                }
                
                if self.event.didLoadSpeakers {
                    self.event.requestSessions {
                        if let delegate = self.delegate {
                            delegate.onRequestComplete(requestType: .sessions)
                        }
                    }
                }
            }
            
        }
    }
    
    /// Requests all speakers for an event
    func requestSpeakers() {
        if !event.didLoadSpeakers && !SIRequestManager.requestIsRunning(request: speakersRequest) {
            self.speakersRequest = event.requestSpeakers() {
                self.event.didLoadSpeakers = true
                
                if let delegate = self.delegate {
                    delegate.onRequestComplete(requestType: .speaker)
                }
                
                if self.event.didLoadAgendas {
                    self.event.requestSessions {
                        if let delegate = self.delegate {
                            delegate.onRequestComplete(requestType: .sessions)
                        }
                    }
                }
            }
        }
    }
    
    /// Requests all venue information for an event
    func requestVenues() {
        if !event.didLoadVenues && !SIRequestManager.requestIsRunning(request: venueRequests) {
            self.venueRequests = self.event.requestVenues() {
                self.event.didLoadVenues = true
                if let delegate = self.delegate {
                    delegate.onRequestComplete(requestType: .venue)
                }
            }
        }
    }
    
    /// Requests all recipients for an event
    func requestRecipients() {
        if !event.didLoadRecipients && !SIRequestManager.requestIsRunning(request: recipientRequests) {
            self.recipientRequests = self.event.requestRecipients() {
                self.event.didLoadRecipients  = true
                if let delegate = self.delegate {
                    delegate.onRequestComplete(requestType: .recipient)
                }
            }
        }
    }
    
    /// Requests all affiliates for an event
    func requestAffiliates() {
        if !event.didLoadAffiliates && !SIRequestManager.requestIsRunning(request: affiliateRequests) {
            affiliateRequests = event.requestAffiliates() {
                self.event.didLoadAffiliates = true
                if let delegate = self.delegate {
                    delegate.onRequestComplete(requestType: .affiliate)
                }
            }
        }
    }
    
    /// Requests all exhibitors for an event
    func requestExhibitors() {
        if !event.didLoadExhibitors && !SIRequestManager.requestIsRunning(request: exhibitorRequests) {
            exhibitorRequests = event.requestExhibitors() {
                self.event.didLoadExhibitors = true
                if let delegate = self.delegate {
                    delegate.onRequestComplete(requestType: .exhibitor)
                }
            }
        }
    }

    /// Requests all sponsors for an event
    func requestSponsors() {
        if !event.didLoadSponsors && !SIRequestManager.requestIsRunning(request: sponsorRequests) {
            sponsorRequests = event.requestSponsors() {
                self.event.didLoadSponsors = true
                if let delegate = self.delegate {
                    delegate.onRequestComplete(requestType: .sponsor)
                }
            }
        }
    }
    
    /// Requests all attendees for an event
    func requestAttendees() {
        if !event.didLoadAttendees && !SIRequestManager.requestIsRunning(request: attendeeRequests) {
            attendeeRequests = event.requestAttendees() {
                self.event.didLoadAttendees = true
            }
        }
    }
    
    /**
     `requestIsRunning` returns true ONLY if the request object is currently in the process of making a network request.
     
     - parameter request: The request object
     */
    static func requestIsRunning(request: Alamofire.Request?) -> Bool {
        // if request object is nil, request is not running
        guard let request = request else {
            return false
        }
        // if task is nil, request is also not running
        if let task = request.task {
            // task is only running if the state is `State.running`
            return task.state == URLSessionTask.State.running
        }
        // task is not running if method reaches this point
        return false
    }
    
    /**
     `requestsRunning` returns true ONLY if all requests object in `requests` are currently running,
     returns false if ANY of the request objects have finished their network calls.
     
     - parameter requests: An array of request objects as `Alamofire.Request?`
     */
    static func requestsRunning(requests: [Alamofire.Request?]) -> Bool {
        for request in requests {
            if SIRequestManager.requestIsRunning(request: request) {
                return true
            }
        }
        return false
    }
    
    /**
     Returns true ONLY if all of the requests for each `SIAgenda` object are currenlty running,
     returns false if ANY of them have finished their network call.
     
     - paramter agendas: An array of `SIAgenda` objects
    */
    static func agendaRequestsRunning(agendas: [SIAgenda]) -> Bool {
        for agenda in agendas {
            if !SIRequestManager.requestIsRunning(request: agenda.sessionsRequest) {
                return false
            }
        }
        return true
    }
    
}
