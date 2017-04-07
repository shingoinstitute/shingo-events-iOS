//
//  VenueMapsCollectionView.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 4/4/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

private let CellIdentifier = "VenueMapCell"

class VenueMapsCollectionView: UIViewController {

    var venue : SIVenue!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "Shingo Icon Fullscreen")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        collectionView.backgroundView = backgroundImage
        
    }

    override var shouldAutorotate : Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapView" {
            let destination = segue.destination as! VenueMapViewController
            if let venueMap = sender as? SIVenueMap {
                destination.venueMap = venueMap
            } else {
                destination.venueMap = SIVenueMap()
            }
        }
    }

}

extension VenueMapsCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // The number of cells is the number of venue maps + 1. The +1 cell is for displaying the venue address.
        if venue.venueMaps.isEmpty {
            return 2
        }
        
        return venue.venueMaps.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch (indexPath as NSIndexPath).row {
        // The first cell displays information about the venue
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "informationCell", for: indexPath) as! VenueMapInformationCell
            cell.venue = venue
            return cell
        default:
        // The rest of the cells display maps for the venue
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as! VenueMapCollectionCell
        
            if cell.venueMap != nil {
                return cell
            }
            
            if self.venue.venueMaps.isEmpty {
                cell.venueMap = SIVenueMap()
            } else {
                cell.venueMap = self.venue.venueMaps[(indexPath as NSIndexPath).row - 1]
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row > 0 {
            let cell = collectionView.cellForItem(at: indexPath) as! VenueMapCollectionCell
            if let venueMap = cell.venueMap {
                self.performSegue(withIdentifier: "MapView", sender: venueMap)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch UIDevice.current.deviceType.rawValue {
        case 1.0 ..< 3.0:
            // iPhone 4s/SE
            return CGSize(width: 200, height: 266)
        case 3.0 ..< 5.0:
            // iPhone 5 - iPhone 6s
            return CGSize(width: 250, height: 333)
        default:
            // iPad idiom
            return CGSize(width: 300, height: 400)
        }
        
    }
    
}





