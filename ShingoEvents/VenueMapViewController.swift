//
//  VenueMapViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 4/5/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class VenueMapViewController: UIViewController, UIScrollViewDelegate {

    var venueMap: SIVenueMap!
    
    var scrollView = UIScrollView()
    var image = UIImageView()
    
    var didUpdateConstraints = false
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        delegate.shouldSupportAllOrientation = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        delegate.shouldSupportAllOrientation = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = venueMap.name
        
        image.image = venueMap.getVenueMapImage()
        image.contentMode = UIViewContentMode.ScaleAspectFit
        
        scrollView.delegate = self
        
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
        
        
        updateViewConstraints()
    }

    override func updateViewConstraints() {
        
        if !didUpdateConstraints {
            
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
