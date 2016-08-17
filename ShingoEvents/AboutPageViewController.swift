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
    
    var background:UIImageView = {
        let view = UIImageView.newAutoLayoutView()
        if let image = UIImage(named: "shigeo_graduate_noclip_full") {
            view.image = image
        }
        view.contentMode = .ScaleAspectFill
        return view
    }()
    
    let text = "Join with us as we enter a new era of enterprise excellence where organizational culture is founded on timeless principles that enable sustainable results. Hear from leaders who have led a culture change, network with others all striving for measurable results and gain powerful insights that wil rejuvenate and refine your quest for organizational excellence."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(background)
        view.bringSubviewToFront(aboutTextField)

        background.autoPinEdgesToSuperviewEdges()
        
        automaticallyAdjustsScrollViewInsets = false
        
        aboutTextField.scrollEnabled = false
        aboutTextField.text = text
        aboutTextField.font = UIFont.systemFontOfSize(16.0)
        aboutTextField.sizeToFit()
        aboutTextField.layoutIfNeeded()

        aboutTextField.clipsToBounds = true
        aboutTextField.layer.borderColor = UIColor.grayColor().CGColor
        aboutTextField.layer.borderWidth = 1.0
        aboutTextField.layer.cornerRadius = 3.0
        aboutTextField.textAlignment = .Center
        aboutTextField.alpha = 0.7
        
    }

    override func viewWillDisappear(animated: Bool) {
        background.image = UIImage()
    }
    

}
