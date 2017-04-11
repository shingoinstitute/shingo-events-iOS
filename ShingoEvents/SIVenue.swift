//
//  SIVenue.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/21/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation
import MapKit

class SIVenue: SIObject {
    enum VenueType : Int {
        case none = 0,
        conventionCenter = 1,
        hotel = 2,
        museum = 3,
        restaurant = 4,
        other = 5
    }
    
    var didLoadVenue : Bool
    var address : String
    var location : CLLocationCoordinate2D?
    var venueType : VenueType
    var venueMaps : [SIVenueMap]
    
    override init() {
        didLoadVenue = false
        address = ""
        venueMaps = [SIVenueMap]()
        location = nil
        venueType = .none
        super.init()
    }
    
    func requestVenueInformation() {
        SIRequest().requestVenue(venueId: self.id) { (venue) in
            if let venue = venue {
                self.id = venue.id
                self.name = venue.name
                self.address = venue.address
                self.location = venue.location
                self.venueType = venue.venueType
                self.venueMaps = venue.venueMaps
            }
            self.didLoadVenue = true
        }
    }
    
}
