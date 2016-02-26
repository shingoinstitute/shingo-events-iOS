//
//  ViewController.swift
//  PureLayoutTest
//
//  Created by Craig Blackburn on 2/12/16.
//  Copyright © 2016 Craig Blackburn. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import PureLayout

class ViewController: UIViewController {
    
    var venueMaps = [VenueMap]()
    var imageViews:[UIImageView] = [UIImageView]()
    
    let scrollView = UIScrollView()
    
    var didSetupConstraints = false
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(scrollView)
        scrollView.autoPinEdgesToSuperviewEdges()
        
        for venueMap in venueMaps
        {
            let imageView = UIImageView.newAutoLayoutView()
            imageView.image = venueMap.image
            imageViews.append(imageView)
            scrollView.addSubview(imageView)
        }
        getContentSizeForScrollView()

        
        view.setNeedsUpdateConstraints()
    }

    
    override func updateViewConstraints() {
        
        if !didSetupConstraints
        {

            let views = imageViews
            
            for view in views
            {
                view.autoSetDimensionsToSize(CGSize(width: self.view.frame.width, height: (view.image?.size.height)!))
            }
            
            var previousView: UIImageView?
            views.first?.autoPinEdgeToSuperviewEdge(.Top, withInset: 10.0)
            views.first?.autoPinEdgeToSuperviewEdge(.Left)
            for view in views
            {
                if let previousView = previousView
                {
                    view.autoPinEdgeToSuperviewEdge(.Left)
                    view.autoPinEdge(.Left, toEdge: .Left, ofView: scrollView)
                    view.autoPinEdge(.Top, toEdge: .Bottom, ofView: previousView)
                }
                previousView = view
            }
            
            didSetupConstraints = true
        }
        
        
        super.updateViewConstraints()
    }

    func getContentSizeForScrollView()
    {
        var height:CGFloat = 0
        for view in imageViews
        {
            height += (view.image?.size.height)!
        }
        
        var width:CGFloat = 0
        width = (imageViews.first?.frame.width)!
        for view in imageViews
        {
            if width < view.frame.width
            {
                width = view.frame.width
            }
        }
        
        scrollView.contentSize = CGSize(width: width, height: height)
    }
    
}



















