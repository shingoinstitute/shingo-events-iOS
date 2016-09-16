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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "Shingo Icon Fullscreen")
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
        collectionView.backgroundView = backgroundImage
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MapView" {
            let destination = segue.destinationViewController as! VenueMapViewController
            if let venueMap = sender as? SIVenueMap {
                destination.venueMap = venueMap
            } else {
                destination.venueMap = SIVenueMap()
            }
        }
    }

}

extension VenueMapsCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // The number of cells is the number of venue maps plus 1. The +1 cell is for displaying the venue address.
        if venue.venueMaps.isEmpty {
            return 2
        }
        
        return venue.venueMaps.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch indexPath.row {
        // The first cell displays information about the venue
        case 0:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("informationCell", forIndexPath: indexPath) as! VenueMapInformationCell
            cell.venue = venue
            return cell
        default:
        // The rest of the cells display maps for the venue
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! VenueMapCollectionCell
        
            if cell.venueMap != nil {
                return cell
            }
            
            if self.venue.venueMaps.isEmpty {
                cell.venueMap = SIVenueMap()
            } else {
                cell.venueMap = self.venue.venueMaps[indexPath.row - 1]
            }
            
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row > 0 {
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! VenueMapCollectionCell
            if let venueMap = cell.venueMap {
                self.performSegueWithIdentifier("MapView", sender: venueMap)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        switch UIDevice.currentDevice().deviceType.rawValue {
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





