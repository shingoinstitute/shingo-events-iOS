//
//  SessionData.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/15/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import Foundation

public class SessionData {
    var attributes:[String:String] = Dictionary()
    var session_id = String()
    var session_name = String()
    var session_abstract = String()
    var sessions_date = String()
    var session_notes = String()
    var session_status = String()
    var session_time = String()
    var speakers = [Speaker]()
}

public class Speaker {
    var attributes:[String:String] = Dictionary()
    var id = String()
    var speaker_contact:[String:String] = Dictionary()
    var name = String()
    var title = String()
    var account:[String:String] = Dictionary()
    var biography = String()
    var speaker_image = NSURL()
    var speaker_display_name = String()
    
}