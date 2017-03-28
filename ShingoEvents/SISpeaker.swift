//
//  SISpeaker.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/21/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit

class SISpeaker: SIObject {
    
    enum SpeakerType: String {
        case keynote = "Keynote",
        concurrent = "Concurrent",
        none = ""
    }
    
    // related object id's
    var associatedSessionIds : [String]
    
    // speaker specific properties
    var title : String
    var pictureURL : String
    var organizationName : String
    var contactEmail : String
    var speakerType: SpeakerType {
        didSet {
            /*
             Since the same speaker can speak in both Keynote and Concurrent sessions,
             if the speaker speaks in any Keynote session, his/her speakerType should
             remain as a Keynote Speaker. This is to maintain integrity of the SIObjects
             speaker types when displaying each section of speakers in SpeakerListTBLVC.
             */
            if oldValue == .keynote { self.speakerType = .keynote }
        }
    }
    
    override init() {
        title = ""
        pictureURL = ""
        organizationName = ""
        contactEmail = ""
        speakerType = .none
        associatedSessionIds = [String]()
        super.init()
    }
    
    /// Gets additional information about the speaker object.
    private func requestSpeakerInformation(_ callback: () -> ()) {
        SIRequest().requestSpeaker(speakerId: id) { (speaker) in
            if let speaker = speaker {
                
                self.name = speaker.name
                self.id = speaker.id
                
                self.title = speaker.title
                if self.pictureURL.isEmpty {
                    self.pictureURL = speaker.pictureURL
                }
                self.attributedSummary = speaker.attributedSummary
                self.organizationName = speaker.organizationName
                self.contactEmail = speaker.contactEmail
                self.associatedSessionIds = speaker.associatedSessionIds
            }
        }
    }
    
    // helper function that makes the http request to get speaker image.
    private func requestSpeakerImage(_ callback: (() -> Void)?) {
        
        if image != nil || pictureURL.isEmpty {
            if let cb = callback { cb() }
            return
        }
        
        requestImage(URLString: pictureURL, callback: { image in
            if let image = image as UIImage? {
                self.image = image
                self.didLoadImage = true
            }
            
            if let cb = callback { cb() }
        });
    }
    
    // Returns speaker image asynchronously. If self.image exists, the image will be immediately returned in the
    // callback, otherwise it will make an http request for the image. This method *always* returns an image
    func getSpeakerImage(callback: ((UIImage) -> Void)?) {
        
        guard let cb = callback else { return requestSpeakerImage(nil) }
        
        guard let image = self.image else {
            return requestSpeakerImage() {
                if let image = self.image {
                    return cb(image)
                } else {
                    return cb(#imageLiteral(resourceName: "Name Filled-100"))
                }
            }
        }
        
        return cb(image)
        
    }
    
    private func getMiddleInitial() -> [String] {
        if let fullname = name.split(" ") {
            
            var middle = [String]()
            
            for n in fullname {
                if n != name.first! || n != name.last! {
                    middle.append(String(n.characters.first!).uppercased())
                }
            }
            
            return middle
        } else {
            return [""]
        }
    }
    
    /// returns last name.
    func getLastName() -> String {
        guard let fullname = name.split(" ") else {
            return name
        }
        
        if let lastname = fullname.last {
            return lastname
        }
        
        return name
    }
    
    /// Returns name in format of: "lastname, firstname M.I."
    func getFormattedName() -> String {
        
        var formattedName = name.first! + ", " + name.last!
        for mi in getMiddleInitial() {
            formattedName += " \(mi) "
        }
        
        return formattedName
    }
    
}
