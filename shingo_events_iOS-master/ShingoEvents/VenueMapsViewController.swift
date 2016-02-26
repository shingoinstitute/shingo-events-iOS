//
//  VenueMapsViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 2/4/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import PureLayout

class VenueMapsViewController: UIViewController, UIScrollViewDelegate {

    var event:Event!
    
    let messageLabel:UILabel = {
        let label = UILabel.newAutoLayoutView()
        label.textAlignment = .Center
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 2
        label.text = "Sorry, maps for this venue are not available yet."
        return label
    }()
    
    var imageViews = [UIImageView]()
    let scrollView = UIScrollView()
    
    var didSetupConstraints = false
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.whiteColor()

        if event.venueMaps == nil {
            view.addSubview(messageLabel)
        }
        else
        {
            for venueMap in event.venueMaps
            {
                let imageView = UIImageView()
                imageView.image = venueMap.image
                imageViews.append(imageView)
                scrollView.addSubview(imageView)
            }
            getContentSizeForScrollView()
            view.addSubview(scrollView)
            
            //        scrollView.delegate = self
            //        scrollView.frame = CGRectMake(0, 0, view.frame.width, view.frame.height)
            //        scrollView.flashScrollIndicators()
            //        scrollView.maximumZoomScale = 10.0
            //        scrollView.minimumZoomScale = 1.0
            //        scrollView.clipsToBounds = false
        }
        
        view.setNeedsUpdateConstraints()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.view
    }
    
    override func updateViewConstraints() {
        if didSetupConstraints == false && event.venueMaps != nil
        {
            scrollView.autoPinEdgesToSuperviewEdges()
            
            let views = imageViews
            
            for view in views
            {
                view.autoSetDimensionsToSize(CGSize(width: (view.image?.size.width)!, height: (view.image?.size.height)!))
            }
            
            views.first?.autoPinEdgeToSuperviewEdge(.Top, withInset: 10.0)
            views.first?.autoPinEdgeToSuperviewEdge(.Left)
            var previousView:UIImageView?
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
        else if didSetupConstraints == false
        {
            messageLabel.autoSetDimensionsToSize(CGSizeMake(view.frame.width, 42.0))
            messageLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: view)
            messageLabel.autoAlignAxis(.Vertical, toSameAxisOfView: view)
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
        
        var width = (imageViews.first?.sizeThatFits(CGSize()))
        for view in imageViews
        {
            if width?.width < view.frame.width
            {
                width?.width = view.frame.width
            }
        }
        
        scrollView.contentSize = CGSize(width: width!.width, height: height)
    }


}
