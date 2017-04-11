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
    
    var scrollView = UIScrollView.newAutoLayout()
    var imageView = UIImageView.newAutoLayout()
    
    var didUpdateConstraints = false
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate.shouldSupportAllOrientation = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate.shouldSupportAllOrientation = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = venueMap.name
        
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        venueMap.getVenueMapImage() { image in
            self.imageView.image = self.resizeImage(image, toSize: self.view.frame.width)
        }
        
        
        scrollView.contentMode = .center
        
        scrollView.delegate = self
        
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        updateViewConstraints()
    }

    fileprivate func resizeImage(_ image: UIImage, toSize: CGFloat) -> UIImage {
        
        let height = image.size.height * (toSize / image.size.width)
        UIGraphicsBeginImageContext(CGSize(width: toSize, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: toSize, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if let img = imageView.image {
            imageView.image = resizeImage(img, toSize: self.view.frame.height)
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
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
