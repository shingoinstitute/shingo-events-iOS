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
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 3
        
        if venueMap == nil {
            return
        }
        
        self.mapNameLabel.text = venueMap.name
        
        venueImage.image = venueMap.getVenueMapImage()
        venueImage.contentMode = .ScaleAspectFit
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
        
        contentView.backgroundColor = SIColor().shingoBlueColor
        contentView.layer.cornerRadius = 3.0
        contentView.layer.borderColor = UIColor.lightGrayColor().CGColor
        contentView.layer.borderWidth = 5.0
        
        title.textColor = UIColor.whiteColor()
        address.textColor = UIColor.whiteColor()
        
        title.text = venue.name
        address.text = venue.address
        
        if venue.name.isEmpty {
            address.text = "Venue information not available."
        }
        
    }
    

    
}






