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
    
    var background:UIImageView = UIImageView.newAutoLayoutView()
    
    let text = "Join with us as we enter a new era of enterprise excellence where organizational culture is founded on timeless principles that enable sustainable results. Hear from leaders who have led a culture change, network with others all striving for measurable results and gain powerful insights that wil rejuvenate and refine your quest for organizational excellence."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        background.image = UIImage(named: "shigeo_graduate_noclip_full")
        view.addSubview(background)
        view.bringSubviewToFront(aboutTextField)
        background.autoPinToTopLayoutGuideOfViewController(self, withInset: -5)
        background.autoAlignAxis(.Vertical, toSameAxisOfView: view)

        var width = background.image?.size.width
        var height = background.image?.size.height
        let aspectRatio = height! / width!
        
        if background.image?.size.height > view.frame.height {
            height = view.frame.height
            width = height! / aspectRatio
        }
        background.autoSetDimensionsToSize(CGSize(width: width!, height: height!))
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        aboutTextField.scrollEnabled = false
        aboutTextField.text = text
        aboutTextField.font = UIFont.systemFontOfSize(16.0)
        aboutTextField.sizeToFit()
        aboutTextField.layoutIfNeeded()
//        let frame = aboutTextField.contentSize
//        aboutTextField.frame = CGRectMake(0, 0, frame.width, frame.height)
//        aboutTextField.autoSetDimension(.Height, toSize: frame.height)
        aboutTextField.clipsToBounds = true
        aboutTextField.layer.borderColor = UIColor.grayColor().CGColor
        aboutTextField.layer.borderWidth = 1.0
        aboutTextField.layer.cornerRadius = 3.0
        aboutTextField.textAlignment = .Center
        aboutTextField.alpha = 0.8
        
    }

    override func viewWillDisappear(animated: Bool) {
        background.image = UIImage()
    }
    

}
