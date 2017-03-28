//
//  File.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/21/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation

class SIRoom: SIObject {
    
    var mapCoordinate : (Double, Double)
    var floor: String
    var associatedVenueID: String
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
    override init() {
        mapCoordinate = (Double(), Double())
        floor = ""
        associatedVenueID = ""
        super.init()
    }
    
}
