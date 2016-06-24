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

    var venueMaps: [SIVenueMap]! = nil
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataToSend: SIVenueMap!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = UIImageView()
        backgroundImage.image = ShingoIconImages().shingoIconForDevice()
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
        collectionView.backgroundView = backgroundImage
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MapView"
        {
            let destination = segue.destinationViewController as! VenueMapViewController
            destination.venueMap = dataToSend
        }
    }

}

extension VenueMapsCollectionView: UICollectionViewDelegate {
    
}

extension VenueMapsCollectionView: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return venueMaps.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! VenueMapCollectionCell
        cell.layer.borderColor = UIColor.grayColor().CGColor
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 3
        cell.venueMap = venueMaps[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! VenueMapCollectionCell
        dataToSend = cell.venueMap
        self.performSegueWithIdentifier("MapView", sender: self)
    }
    
}