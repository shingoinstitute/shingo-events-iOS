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
        let view = UIScrollView.newAutoLayout()
        view.translatesAutoresizingMaskIntoConstraints = true
        view.backgroundColor = .white
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    var contentView:UIView = UIView.newAutoLayout()
    
    var shingoModel:UIImageView = {
        let view = UIImageView.newAutoLayout()
        view.backgroundColor = .clear
        view.image = UIImage(named: "Shingo Model")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    var guidingPrinciples:UIImageView = {
        let view = UIImageView.newAutoLayout()
        view.backgroundColor = .clear
        view.image = UIImage(named: "Guiding Principles Portrait")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate.shouldSupportAllOrientation = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate.shouldSupportAllOrientation = false
    }
    
    var shingoModelDimensionConstraints = [NSLayoutConstraint]()
    var guidingPrinciplesDimensionConstraints = [NSLayoutConstraint]()
    
    var didUpdateConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(shingoModel)
        contentView.addSubview(guidingPrinciples)
        
        updateViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        //Must set height and width constraints active property to false before resizing them
        shingoModelDimensionConstraints.active = false
        guidingPrinciplesDimensionConstraints.active = false
        
        //Resizes images height/width constraints after screen rotation
        shingoModelDimensionConstraints = shingoModel.autoSetDimensions(to: shingoModel.sizeThatViewFits(view: view))
        guidingPrinciplesDimensionConstraints = guidingPrinciples.autoSetDimensions(to: guidingPrinciples.sizeThatViewFits(view: view))
        
    }
    
    override func updateViewConstraints() {
        if !didUpdateConstraints {
            
            shingoModelDimensionConstraints = shingoModel.autoSetDimensions(to: shingoModel.sizeThatViewFits(view: view))
            guidingPrinciplesDimensionConstraints = guidingPrinciples.autoSetDimensions(to: guidingPrinciples.sizeThatViewFits(view: view))
            
            scrollView.autoPinEdge(.top, to: .top, of: view)
            scrollView.autoPinEdge(.left, to: .left, of: view)
            scrollView.autoPinEdge(.right, to: .right, of: view)
            scrollView.autoPinEdge(.bottom, to: .bottom, of: view)
            
            contentView.autoPinEdge(.top, to: .top, of: scrollView)
            contentView.autoPinEdge(.left, to: .left, of: scrollView)
            contentView.autoPinEdge(.right, to: .right, of: scrollView)
            contentView.autoPinEdge(.bottom, to: .bottom, of: scrollView)
            
            shingoModel.autoPinEdge(.top, to: .top, of: contentView)
            shingoModel.autoAlignAxis(.vertical, toSameAxisOf: view)
            
            guidingPrinciples.autoPinEdge(.top, to: .bottom, of: shingoModel)
            guidingPrinciples.autoAlignAxis(.vertical, toSameAxisOf: view)
            guidingPrinciples.autoPinEdge(.bottom, to: .bottom, of: contentView)
            
            didUpdateConstraints = true
        }
        
        super.updateViewConstraints()
    }
}



