//
//  SIHotel.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/21/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation

class SIHotel: SIObject {
    
    var address : String
    var phone : String
    var website : String
    var associatedEventId : String
    var hotelCode : String
    var travelInformation : String
    var prices : [Double]
    
    
    override init() {
        address = ""
        phone = ""
        website = ""
        associatedEventId = ""
        hotelCode = ""
        travelInformation = ""
        prices = [Double]()
        super.init()
    }
}
