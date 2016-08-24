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
    
    var scrollView = UIScrollView.newAutoLayoutView()
    var imageView = UIImageView.newAutoLayoutView()
    
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
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        venueMap.getVenueMapImage() { image in
            self.imageView.image = self.resizeImage(image, toSize: self.view.frame.width)
        }
        
        
        scrollView.contentMode = .Center
        
        scrollView.delegate = self
        
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        updateViewConstraints()
    }

    private func resizeImage(image: UIImage, toSize: CGFloat) -> UIImage {
        
        let height = image.size.height * (toSize / image.size.width)
        UIGraphicsBeginImageContext(CGSizeMake(toSize, height))
        image.drawInRect(CGRectMake(0, 0, toSize, height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
//        switch toInterfaceOrientation {
//        case .Portrait:
//            imageView.image = resizeImage(venueMap.getVenueMapImage(), toSize: view.frame.height)
//        case .LandscapeLeft, .LandscapeRight:
//            imageView.image = resizeImage(venueMap.getVenueMapImage(), toSize: view.frame.height)
//        default:
//            break
//        }
        venueMap.getVenueMapImage() { image in
            self.imageView.image = self.resizeImage(image, toSize: self.view.frame.height)
        }
    }
    
    override func updateViewConstraints() {
        
        if !didUpdateConstraints {
            
            scrollView.autoPinEdgesToSuperviewEdges()
            imageView.autoPinEdgesToSuperviewEdges()
            
            didUpdateConstraints = true
        }
        super.updateViewConstraints()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
