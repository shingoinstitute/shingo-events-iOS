//
//  SettingsController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 12/29/15.
//  Copyright © 2015 Shingo Institute. All rights reserved.
//

import UIKit
import QuartzCore

class SettingsController: UIViewController {

    // MARK: Properties
    


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.title = "Settings"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func didTapLogout(sender: AnyObject) {
        performSegueWithIdentifier("loginSI", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
