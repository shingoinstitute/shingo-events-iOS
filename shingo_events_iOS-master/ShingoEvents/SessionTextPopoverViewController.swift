//
//  SessionTextPopoverViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 2/11/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class SessionTextPopoverViewController: UIViewController {

    var abstractText:String!
    @IBOutlet weak var abstractTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        abstractTextField.text = abstractText
        abstractTextField.textColor = .whiteColor()
    }

}

