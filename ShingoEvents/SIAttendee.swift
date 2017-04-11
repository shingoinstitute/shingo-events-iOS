//
//  SIAttendee.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/21/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit

class SIAttendee: SIObject {
    
    var organization: String
    var title: String
    var pictureURL: String
    
    override init() {
        organization = ""
        title = ""
        pictureURL = ""
        super.init()
    }
    
    override func requestImage(URLString: String, callback: @escaping (UIImage?) -> Void) {
        
        if let image = self.image {
            return callback(image)
        }
        
        if pictureURL.isEmpty {
            return callback(nil)
        }
        
        super.requestImage(URLString: URLString) { (image) in
            if let _ = image {
                self.image = image
                self.didLoadImage = true
            }
            return callback(image)
        }
    }
    
    func getImage(callback: @escaping (UIImage) -> Void) {
        requestImage(URLString: pictureURL) { (image) in
            guard let image = image else {
                if let image = UIImage(named: "Name Filled-100") {
                    return callback(image)
                } else {
                    return callback(UIImage())
                }
            }
            
            return callback(image)
            
        }
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
    
    /// Returns name in format of: "lastname, firstname M.I."
    func getFormattedName() -> String {
        
        if name.isEmpty {
            return ""
        }
        
        let names: [String] = self.name.lowercased().split(" ")!
        for var name in names {
            name.trim()
            
            var formattedName = [String]()
            for char in name.characters {
                formattedName.append(String(describing: char))
            }
            formattedName[0] = formattedName[0].uppercased()
            name = ""
            for letter in formattedName {
                name += letter
            }
        }
        
        var formattedName = names.first! + ", " + names.last!
        for mi in getMiddleInitial() {
            formattedName += " \(mi) "
        }
        
        return formattedName
    }
    
    func getLastName() -> String {
        
        if name.isEmpty {
            return ""
        }
        
        guard let names: [String] = self.name.lowercased().split(" ") else {
            return ""
        }
        
        guard let lastname = names.last else {
            return ""
        }
        
        return lastname
    }
    
    func getFirstName() -> String {
        
        if name.isEmpty {
            return ""
        }
        
        guard let names: [String] = self.name.lowercased().split(" ") else {
            return ""
        }
        
        guard let firstname = names.first else {
            return ""
        }
        
        return firstname
        
    }
    
}
