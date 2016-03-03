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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var contentView:UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = UIColor.whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var shingoModel:UIImageView = {
        let view = UIImageView.newAutoLayoutView()
        view.backgroundColor = .clearColor()
        view.image = UIImage(named: "Shingo Model")
        return view
    }()
    
    var guidingPrinciples:UIImageView = {
        let view = UIImageView.newAutoLayoutView()
        view.backgroundColor = .clearColor()
        view.image = UIImage(named: "Guiding Principles Portrait")
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blueColor()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(shingoModel)
        contentView.addSubview(guidingPrinciples)
        
        scrollView.autoSetDimensionsToSize(CGSize(width: self.view.frame.width, height: self.view.frame.height))

        let imageHeightRatioToViewHeight:CGFloat = 1.4
        
        contentView.autoSetDimensionsToSize(CGSize(width: self.view.frame.width, height: self.view.frame.height * imageHeightRatioToViewHeight))
        contentView.autoPinEdgeToSuperviewEdge(.Top)
        contentView.autoPinEdgeToSuperviewEdge(.Left)
        contentView.autoPinEdgeToSuperviewEdge(.Right)
        contentView.autoPinEdgeToSuperviewEdge(.Bottom)
        
        shingoModel.autoSetDimension(.Height, toSize: view.frame.height * (imageHeightRatioToViewHeight / 2))
        shingoModel.autoPinEdgeToSuperviewEdge(.Top)
        shingoModel.autoPinEdgeToSuperviewEdge(.Right)
        shingoModel.autoPinEdgeToSuperviewEdge(.Left)
        
        guidingPrinciples.autoSetDimension(.Height, toSize: view.frame.height * (imageHeightRatioToViewHeight / 2))
        guidingPrinciples.autoPinEdge(.Top, toEdge: .Bottom, ofView: shingoModel, withOffset: 8.0)
        guidingPrinciples.autoPinEdgeToSuperviewEdge(.Right)
        guidingPrinciples.autoPinEdgeToSuperviewEdge(.Left)

        scrollView.contentSize = CGSize(width: self.view.frame.width, height: contentView.frame.height)
        
        
    }



}























