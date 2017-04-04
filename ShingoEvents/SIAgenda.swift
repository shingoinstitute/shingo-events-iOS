//
//  SIAgenda.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/21/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation

// An Event Day
class SIAgenda: SIObject {
    
    var didLoadSessions : Bool
    
    // related objects
    var sessions : [SISession]
    
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
    func requestAgendaSessions(_ callback: @escaping () -> ()) {
        
        switch id.isEmpty {
        case true:
            callback()
        case false:
            SIRequest().requestSessions(agendaId: id, callback: { sessions in
                
                if let sessions = sessions {
                    self.sessions = sessions
                    self.didLoadSessions = true
                }
                
                callback()
            });
        }
    }
    
}
