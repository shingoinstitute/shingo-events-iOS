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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = venue.name
        addressLabel.text = venue.address
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
        if venue.venueMaps.isEmpty {
            return 1
        }
        return venue.venueMaps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as! VenueMapCollectionCell
        
            if cell.venueMap != nil {
                return cell
            }
            
            if self.venue.venueMaps.isEmpty {
                cell.venueMap = SIVenueMap()
            } else {
                cell.venueMap = self.venue.venueMaps[(indexPath as NSIndexPath).row]
            }
            
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! VenueMapCollectionCell
        if let venueMap = cell.venueMap {
            self.performSegue(withIdentifier: "MapView", sender: venueMap)
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





