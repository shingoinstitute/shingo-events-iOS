//
//  VenueMapCollectionCell.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 4/4/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class VenueMapCollectionCell: UICollectionViewCell {
    
    var venueMap : SIVenueMap! {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet weak var venueImage: UIImageView!
    @IBOutlet weak var mapNameLabel: UILabel!
    
    func updateCell() {
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 3
        
        if venueMap != nil {
            mapNameLabel.text = venueMap.name
            mapNameLabel.font = UIFont(name: "Helvetica", size: 16.0)
            venueMap.getVenueMapImage() { image in
                self.venueImage.image = image
            }
            venueImage.contentMode = .scaleAspectFit
        }
        
        
    }
}

class VenueMapInformationCell: UICollectionViewCell {
    
    var venue : SIVenue! {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var address: UILabel!
    
    
    func updateCell() {
        
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        contentView.layer.cornerRadius = 3.0
        
        title.textColor = UIColor.yellow
        title.text = venue.name
        title.font = UIFont(name: "Helvetica", size: 18.0)
        
        address.textColor = UIColor.yellow
        address.font = UIFont(name: "Helvetica", size: 18.0)
        address.text = venue.address
        
        if venue.name.isEmpty {
            address.text = "Venue information not available."
        }
        
    }
    

    
}






