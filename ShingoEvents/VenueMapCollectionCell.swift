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
    
    @IBOutlet weak var venueImage: UIImageView! { didSet { venueImage.contentMode = .scaleAspectFit } }
    @IBOutlet weak var mapNameLabel: UILabel!
    
    func updateCell() {
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 3
        
        if venueMap != nil {
            mapNameLabel.text = venueMap.name
            mapNameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            venueMap.getVenueMapImage() { image in
                self.venueImage.image = image
            }
        }
        
    }
}






