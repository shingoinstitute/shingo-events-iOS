//
//  MapViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/27/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapItem: MKMapItem!
    @IBOutlet var mapView: MKMapView!
    var venue: SIVenue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Conference Location"
        
        
        if let location = venue.location {
            
            let region: MKCoordinateRegion = MKCoordinateRegionMake(location, MKCoordinateSpanMake(0.1 , 0.1))
            
            mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = venue.name
            
            mapView.addAnnotation(annotation)
            mapView.selectAnnotation(annotation, animated: true)
            
        } else {
            let alert = UIAlertController(title: "Oops!", message: "Sorry, this conference location is currently unavailable.", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
    }


    @IBAction func getDirectionsButton(_ sender: AnyObject) {
        
        guard let location = venue.location else {
            return
        }
        
        mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location, addressDictionary: nil))
        mapItem.name = venue.name
        let regionSpan = MKCoordinateRegionMakeWithDistance(location, 0.5, 0.5)
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsMapCenterKey : NSValue(mkCoordinate: location),
            MKLaunchOptionsMapSpanKey : NSValue(mkCoordinateSpan: regionSpan.span)
        ])

    }
    
}





