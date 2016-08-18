//
//  ShingoModelViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 2/5/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit


class ShingoModelViewController: UIViewController {

    var scrollView:UIScrollView = {
        let view = UIScrollView.newAutoLayoutView()
        view.backgroundColor = .whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = true
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        return view
    }()
    
    var contentView:UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    var shingoModel:UIImageView = {
        let view = UIImageView.newAutoLayoutView()
        view.backgroundColor = .clearColor()
        view.image = UIImage(named: "Shingo Model")
        view.contentMode = .ScaleAspectFit
        return view
    }()
    
    var guidingPrinciples:UIImageView = {
        let view = UIImageView.newAutoLayoutView()
        view.backgroundColor = .clearColor()
        view.image = UIImage(named: "Guiding Principles Portrait")
        view.contentMode = .ScaleAspectFit
        return view
    }()
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        delegate.shouldSupportAllOrientation = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        delegate.shouldSupportAllOrientation = false
    }
    
    var shingoModelDimensionConstraints = [NSLayoutConstraint]()
    var guidingPrinciplesDimensionConstraints = [NSLayoutConstraint]()
    
    var didUpdateConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blackColor()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(shingoModel)
        contentView.addSubview(guidingPrinciples)
        
        updateViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        shingoModelDimensionConstraints.active = false
        shingoModelDimensionConstraints = shingoModel.autoSetDimensionsToSize(shingoModel.sizeThatFitsView(view))
        
        guidingPrinciplesDimensionConstraints.active = false
        guidingPrinciplesDimensionConstraints = guidingPrinciples.autoSetDimensionsToSize(guidingPrinciples.sizeThatFitsView(view))
        
    }
    
    override func updateViewConstraints() {
        if !didUpdateConstraints {
            
            shingoModelDimensionConstraints = shingoModel.autoSetDimensionsToSize(shingoModel.sizeThatFitsView(view))
            
            guidingPrinciplesDimensionConstraints = guidingPrinciples.autoSetDimensionsToSize(guidingPrinciples.sizeThatFitsView(view))
            
            let width = shingoModelDimensionConstraints.width + guidingPrinciplesDimensionConstraints.width
            let height = shingoModelDimensionConstraints.height + guidingPrinciplesDimensionConstraints.height
            scrollView.contentSize = CGSizeMake(width, height)
            
            scrollView.autoPinEdge(.Top, toEdge: .Top, ofView: view)
            scrollView.autoPinEdge(.Left, toEdge: .Left, ofView: view)
            scrollView.autoPinEdge(.Right, toEdge: .Right, ofView: view)
            scrollView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: view)
            
            contentView.autoPinEdge(.Top, toEdge: .Top, ofView: scrollView)
            contentView.autoPinEdge(.Left, toEdge: .Left, ofView: scrollView)
            contentView.autoPinEdge(.Right, toEdge: .Right, ofView: scrollView)
            contentView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: scrollView)
            
            shingoModel.autoPinEdge(.Top, toEdge: .Top, ofView: contentView)
            shingoModel.autoAlignAxis(.Vertical, toSameAxisOfView: view)
            
            guidingPrinciples.autoPinEdge(.Top, toEdge: .Bottom, ofView: shingoModel)
            guidingPrinciples.autoAlignAxis(.Vertical, toSameAxisOfView: view)
            guidingPrinciples.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: contentView)
            
            didUpdateConstraints = true
        }
        
        super.updateViewConstraints()
    }

    
}



