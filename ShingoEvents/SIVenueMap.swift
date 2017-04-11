//
//  SIVenueMap.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/21/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit

class SIVenueMap: SIObject {
    
    var mapURL : String {
        didSet {
            requestVenueMapImage(nil)
        }
    }
    var floor : Int
    
    override init() {
        mapURL = ""
        floor = -1
        super.init()
    }
    
    func getVenueMapImage(_ callback: @escaping (UIImage) -> Void) {
        
        guard let image = self.image else {
            requestVenueMapImage() {
                if let image = self.image {
                    callback(image)
                } else if let image = UIImage(named: "mapNotAvailable") {
                    callback(image)
                } else {
                    callback(UIImage())
                }
            }
            return
        }
        
        callback(image)
    }
    
    func requestVenueMapImage(_ callback: (() -> Void)?) {
        
        if image != nil || mapURL.isEmpty {
            if let cb = callback { cb() }
        } else {
            self.requestImage(URLString: mapURL) { (image) in
                if let image = image {
                    self.image = image
                    self.didLoadImage = true
                }
                if let cb = callback { cb() }
            }
        }
    }
    
}
