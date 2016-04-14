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
    var location:CLLocationCoordinate2D? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Conference Location"
        
        let initial_zoom_region:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
        if location == nil {
            location = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            
            let warning = UIAlertController(title: "Oops!", message: "Sorry, your conference location is currently unavailable.", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            warning.addAction(cancelAction)
            self.presentViewController(warning, animated: true, completion: nil)
            
        } else {
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location!, initial_zoom_region)
            print("Map location: Lat: \(location!.latitude) | Lng: \(location!.longitude)")
            mapView.setRegion(region, animated: true)

            let annotation = MKPointAnnotation()
            annotation.coordinate = location!
            annotation.title = "Shingo Conference Location"
            
            mapView.addAnnotation(annotation)
        }
        
    }


    @IBAction func getDirectionsButton(sender: AnyObject) {
        mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location!, addressDictionary: nil))
        mapItem.name = "Shingo Conference Location"
        let regionSpan = MKCoordinateRegionMakeWithDistance(location!, 0.5, 0.5)
        mapItem.openInMapsWithLaunchOptions([
            MKLaunchOptionsMapCenterKey : NSValue(MKCoordinate: self.location!),
            MKLaunchOptionsMapSpanKey : NSValue(MKCoordinateSpan: regionSpan.span)
        ])

    }
    
}





