//
//  Event.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/7/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import MapKit


public class Event {
    var eventSessions:[EventSession]! // An array of every session throughout the entire conference
    var name = String() // Title of the conference
    var event_start_date = NSDate() // Date of first day of the conference
    var event_end_date = NSDate() // Date of last day of the conference
    var event_id = String() // This item is parsed from the key "Id" in JSON response.
    var host_organization = String()
    var host_city = String() // Host city
    var event_type = String() // Event type
    var eventAgenda = EventAgenda() // This item is used to separate each day of the conference and holds an array of data where 
    // each element contains sessions relating to a particular day.
    var venueMaps:[VenueMap]!
    var location:CLLocationCoordinate2D!
    var eventSpeakers:[Speaker]!
}

public class EventAgenda {
    var agenda_id = String()
    var days_array = [EventDay]()
}

public class EventDay {
    var day_id = String()
    var dayOfWeek = String()
    var sessions = [EventSession]()
}

public class EventSession {
    var session_id = String()
    var name = String()
    var abstract = String()
    var start_end_date:(NSDate, NSDate)!
    var room = String()
    var notes = String()
    var status = String()
    var time = NSDate()
    var format: String!
    var richAbstract: String?
    var sessionSpeakers = [Speaker?]()
    var speaker_ids = [String]()
}

public class Speaker: AppDataImage {
    var speaker_id:String!
    var name: String!
    var title: String!
    var biography: String!
    var image_url: String!
    var image: UIImage!
    var display_name: String!
    var organization: String!
    var richBiography: String?
    
    public func getImage(url:String?) {
        if url == nil {
            print("WARNING! Null url string sent to function AppDataImage::getImage, for speaker: \(self.display_name)")
            return
        }
        print("Attempting to fetch image for Speaker")
        Alamofire.request(.GET, url!).responseImage {
            response in
            
            if let image = response.result.value {
                print("image downloaded: \(image.size.width)x\(image.size.height)")
                self.image = image
            } else {
                self.image = UIImage(named: "100x100PL")
                print("ERROR! Image download failed | Request from \(url!), for speaker: \(self.display_name)")
            }
            
        }
    }
    
}

public class Recipient: AppDataImage {
    
    enum RECIP_TYPE {
        case ShingoAward,
        Silver,
        Bronze,
        Research,
        NULL
    }
    
    var award_type: RECIP_TYPE? = nil
    var recipient_id: String!
    var name: String!
    var abstract: String!
    var richAbstract: String?
    var event_id: String!
    var award: String!
    var authors: String!
    var logo_book_cover_image: UIImage!
    var logo_book_cover_url: String!

    func getRecipientImage(url:String?, callback: (image: UIImage?) -> Void) {
        if url == nil {
            print("WARNING! Null url string sent to function AppDataImage:getImage")
            callback(image: nil)
            return
        }
        print("Attempting to fetch image @func AppDataImage::getImage")
        Alamofire.request(.GET, url!).responseImage {
            response in
            
            print(response.response)
            
            if let image = response.result.value {
                print("image downloaded: \(image.size.width)x\(image.size.height)")
                callback(image: image)
            } else {
                print("ERROR! Image download failed | Request from \(url!)")
                callback(image: nil)
            }
        }
    }
    
}

public class Exhibitor: AppDataImage {
    var SF_id:String!
    var name:String!
    var description:String!
    var richDescription: String?
    var phone:String!
    var email:String!
    var website:String!
    var logo_url:String!
    var logo_image:UIImage!
    var event_id:String!
}


public class Affiliate: AppDataImage {
    var id:String!
    var name:String!
    var abstract:String!
    var richAbstract: String?
    var logo_url:String!
    var logo_image:UIImage!
    var website_url:String!
    var phone:String!
    var email:String!
}

public class Sponsor: AppDataImage {
    enum SPONSOR_TYPE {
        case Friend,
        Supporter,
        Benefactor,
        Champion,
        President
    }
    
    var sponsor_type:SPONSOR_TYPE? = nil
    var id:String? = nil
    var mdf_amount:Int? = nil
    var logo_url:String? = nil
    var logo_image:UIImage? = nil
    var banner_url:String? = nil
    var banner_image:UIImage? = nil
    var level:String? = nil
    var event_id:String? = nil
    var name:String? = nil
    
    func getSponsorImage(url:String?, callback: (image: UIImage?) -> Void) {
        if url == nil {
            print("WARNING! Null url string sent to function AppDataImage:getImage")
            callback(image: UIImage(named: "sponsor_banner_pl"))
            return
        }
        print("Attempting to fetch image @func AppDataImage:getImage")
        Alamofire.request(.GET, url!).responseImage {
            response in
    
            print(response.response)
            
            if let image = response.result.value {
                print("image downloaded: \(image.size.width)x\(image.size.height)")
                callback(image: image)
            } else {
                print("WARNING! Image download failed | Request from \(url!) | for sponsor: \(self.name)")
                callback(image: UIImage(named: "sponsor_banner_pl"))
            }
            
        }
    }
    
}

public class VenueMap: AppDataImage {
    var name:String!
    var image:UIImage!
    var url:String
    
    override init() {
        self.name = ""
        self.url = ""
        self.image = UIImage()
    }
    
    convenience init(name: String, url:String)
    {
        self.init()
        self.name = name
        self.url = url
        self.getVenueImage(url)
    }
    
    func getVenueImage(url:String) {
        self.getImage(self.url)
        {
            image in
            self.image = image
        }
    }
    
}

public class AppDataImage {
    
    public func getImage(url:String?, callback: (image: UIImage?) -> Void) {
        if url == nil {
            print("WARNING! Null url string sent to function AppDataImage:getImage")
            callback(image: nil)
            return
        }
        print("Attempting to fetch image @func AppDataImage::getImage")
        Alamofire.request(.GET, url!).responseImage {
            response in
            
            print(response.response)
            
            if let image = response.result.value {
                print("image downloaded: \(image.size.width)x\(image.size.height)")
                callback(image: image)
            } else {
                print("ERROR! Image download failed | Request from \(url!)")
                callback(image: UIImage(named: "shingo_icon_200x200"))
            }
        }
    }
    
}

extension String {
    func trim() -> String
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
}


