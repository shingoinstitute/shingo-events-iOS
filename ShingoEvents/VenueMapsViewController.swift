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
    
    var imageViews = [UIImageView]()
    
    let messageLabel:UILabel = {
        let label = UILabel.newAutoLayoutView()
        label.textAlignment = .Center
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 2
        label.text = "Sorry, maps for this venue are not available yet."
        return label
    }()
    
    let contentView:UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    let scrollView:UIScrollView = {
        let view = UIScrollView.newAutoLayoutView()
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    var didSetupConstraints = false
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        
        // If there are no venueMaps, display message label
        if event.venueMaps == nil
        {
            view.addSubview(messageLabel)
        }
        else
        {
            
            for venueMap in event.venueMaps
            {
                let imageView = UIImageView()
                imageView.image = venueMap.image
                imageView.frame = CGRectMake(0, 0, view.frame.width, view.frame.height)
                imageViews.append(imageView)
                contentView.addSubview(imageView)
            }
            scrollView.addSubview(contentView)
            view.addSubview(scrollView)
        }
        
        view.setNeedsUpdateConstraints()
        
        //        scrollView.delegate = self
        //        setZoomScale()
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    
    //    func setZoomScale() {
    //        let contentViewSize = contentView.bounds.size
    //        let scrollViewSize = scrollView.bounds.size
    //        let widthScale = scrollViewSize.width / contentViewSize.width
    //        let heightScale = contentViewSize.width / contentViewSize.height
    //
    //        scrollView.minimumZoomScale = min(widthScale, heightScale) - 1.0
    //        scrollView.maximumZoomScale = 2.0
    //        scrollView.zoomScale = 1.0
    //    }
    
    override func updateViewConstraints() {
        if didSetupConstraints == false && event.venueMaps != nil
        {
            contentView.autoSetDimension(.Height, toSize: getContentHeight())
            scrollView.autoPinEdgesToSuperviewEdges()
            
            // Set contentSize height of scrollview large enough to fit all of the venueMaps
            scrollView.contentSize = CGSize(width: view.frame.width, height: getContentHeight())
            
            
            
            // Set height and width constraints of each image to fit the size of the device screen
            for imageView in imageViews
            {
                var width:CGFloat! = imageView.image?.size.width
                var height:CGFloat! = imageView.image?.size.height
                
                let aspectRatio = height / width
                width = view.frame.width
                height = height / aspectRatio
                
                imageView.autoSetDimensionsToSize(CGSize(width: width, height: height))
            }
            
            imageViews.first?.autoPinEdgeToSuperviewEdge(.Top)
            imageViews.first?.autoPinEdgeToSuperviewEdge(.Left)
            var previousView:UIImageView?
            for view in imageViews
            {
                if let previousView = previousView
                {
                    view.autoPinEdgeToSuperviewEdge(.Left)
                    view.autoPinEdge(.Left, toEdge: .Left, ofView: contentView)
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
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    
    func getContentHeight() -> CGFloat {
        var total:CGFloat = 0.0
        
        for image in imageViews
        {
            let aspectRatio = (image.image?.size.height)! / (image.image?.size.width)!
            let height = (image.image?.size.height)! / aspectRatio
            
            total += height
        }
        return total
    }
    
}