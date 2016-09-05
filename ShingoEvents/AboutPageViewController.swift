//
//  AboutPageViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/10/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class AboutPageViewController: UIViewController {

    @IBOutlet weak var aboutTextField: UITextView!
    
    var shigeoImageView: UIImageView = {
        let view = UIImageView.newAutoLayoutView()
        view.image = UIImage(named: "shigeoGrad")
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        view.contentMode = .ScaleAspectFill
        return view
    }()
    
    var shigeoNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Shigeo Shingo, 1909-1990"
        label.textAlignment = .Center
        label.textColor = .whiteColor()
        return label
    }()
    
    let text = "Join with us as we enter a new era of enterprise excellence where organizational culture is founded on timeless principles that enable sustainable results. Hear from leaders who have led a culture change, network with others all striving for measurable results and gain powerful insights that wil rejuvenate and refine your quest for organizational excellence."
    
    var didSetupConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = SIColor.prussianBlueColor()
        
        view.addSubviews([shigeoImageView, shigeoNameLabel])
        view.bringSubviewToFront(aboutTextField)

//        aboutTextField.scrollEnabled = false
        aboutTextField.text = text
        aboutTextField.font = UIFont.systemFontOfSize(16)
        
        aboutTextField.sizeToFit()
        aboutTextField.layoutIfNeeded()
        
        aboutTextField.clipsToBounds = true
        aboutTextField.layer.borderColor = UIColor.grayColor().CGColor
        aboutTextField.layer.borderWidth = 1
        aboutTextField.layer.cornerRadius = 3
        aboutTextField.textAlignment = .Center
        aboutTextField.alpha = 0.7
     
        updateViewConstraints()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        aboutTextField.setContentOffset(CGPointZero, animated: false)
    }

    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            aboutTextField.autoSetDimension(.Height, toSize: aboutTextField.frame.height + 60)
            
            shigeoImageView.autoPinEdge(.Top, toEdge: .Bottom, ofView: aboutTextField, withOffset: 8)
            shigeoImageView.autoPinEdgeToSuperviewMargin(.Left)
            shigeoImageView.autoPinEdgeToSuperviewMargin(.Right)
            
            shigeoNameLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: shigeoImageView, withOffset: 8)
            shigeoNameLabel.autoPinEdgeToSuperviewMargin(.Left)
            shigeoNameLabel.autoPinEdgeToSuperviewMargin(.Right)
            shigeoNameLabel.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: view, withOffset: -8)
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
}










