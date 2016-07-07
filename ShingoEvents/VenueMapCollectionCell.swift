//
//  VenueMapCollectionCell.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 4/4/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class VenueMapCollectionCell: UICollectionViewCell {
    
    var venueMap: SIVenue! {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet weak var venueImage: UIImageView!
    @IBOutlet weak var mapNameLabel: UILabel!
    
    private func updateCell() {
        mapNameLabel.text = self.venueMap.name
        venueImage.image = self.venueMap.getVenueMapImage()
    }
}
