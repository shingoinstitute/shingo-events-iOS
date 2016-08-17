//
//  SettingsTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/12/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import Crashlytics
import Fabric

class SettingsTableViewController: UITableViewController {

    var buttonPushedString:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        if self.respondsToSelector(action) {
            return true
        } else {
            return false
        }
    }
    
    @IBAction func didTapProfileSettings(sender: AnyObject) {
        
    }

    @IBAction func didTapReportABug(sender: AnyObject) {
        buttonPushedString = "Report a bug"
    }

    @IBAction func didTapLeaveSuggestion(sender: AnyObject) {
        buttonPushedString = "Leave a suggestion"
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "reportABug" || segue.identifier == "feedback"
        {
            let destination = segue.destinationViewController as? ReportABugViewController
            if buttonPushedString == "Report a bug"
            {
                destination?.titleLabelString = self.buttonPushedString
            }
            else
            {
                destination?.titleLabelString = self.buttonPushedString
            }
        }
        
    }
    
}

