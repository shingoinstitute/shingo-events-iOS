//
//  SIAgenda.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/21/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation
import Alamofire

protocol SIAgendaDelegate {
    func onAgendaRequestCompletion()
}

/** 
 An `SIAgenda` object represents a single day during an event
*/
class SIAgenda: SIObject {
    
    var didLoadSessions : Bool
    
    var requestDelegate: SIAgendaDelegate?
    
    // related objects
    var sessions : [SISession]
    
    var sessionsRequest: Alamofire.Request? {
        willSet(newRequest) {
            if !SIRequestManager.requestIsRunning(request: sessionsRequest) {
                self.sessionsRequest = newRequest
            }
        }
    }
    
    // agenda specific properties
    var displayName : String
    var date : SIDate
    
    override init() {
        didLoadSessions = false
        sessions = [SISession]()
        displayName = ""
        date = SIDate()
        super.init()
    }
    
    /// Gets session information for SIAgenda object using an agenda ID.
    func requestAgendaSessions(_ callback: (() -> ())?) {
        if !SIRequestManager.requestIsRunning(request: sessionsRequest) {
            sessionsRequest = SIRequest().requestSessions(agendaId: id, callback: { sessions in
                
                if let sessions = sessions {
                    self.sessions = sessions
                    self.didLoadSessions = true
                }
                
                if let delegate = self.requestDelegate {
                    delegate.onAgendaRequestCompletion()
                }
                
                if let done = callback {
                    return done()
                }

            })
        } else if let done = callback {
            return done()
        }
    }
    
}
