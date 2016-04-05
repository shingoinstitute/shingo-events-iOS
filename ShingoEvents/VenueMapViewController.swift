//
//  VenueMapViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 4/5/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class VenueMapViewController: UIViewController, UIScrollViewDelegate {

    var venueMap: VenueMap! = nil
    
    var scrollView = UIScrollView()
    var image = UIImageView()
    
    var didUpdateConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = venueMap.name
        
        if venueMap != nil {
            image.image = venueMap.image
        }
        
        image.contentMode = UIViewContentMode.ScaleAspectFit
        
        scrollView.delegate = self
        
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
        
        
        updateViewConstraints()
    }

    override func updateViewConstraints() {
        
        if !didUpdateConstraints
        {
            scrollView.autoPinEdgesToSuperviewEdges()
            scrollView.addSubview(image)
            image.autoPinEdgesToSuperviewEdges()
            
            didUpdateConstraints = true
        }
        super.updateViewConstraints()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return image
    }
    
}
