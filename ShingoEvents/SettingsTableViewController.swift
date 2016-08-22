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

protocol UnwindToMainVC {
    func updateEvents(events: [SIEvent]?)
}

class SettingsTableViewController: UITableViewController {
    
    var events: [SIEvent]?
    
    var delegate: UnwindToMainVC?
    
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
        performSegueWithIdentifier("reportABug", sender: sender)
    }

    @IBAction func didTapLeaveSuggestion(sender: AnyObject) {
        performSegueWithIdentifier("feedback", sender: sender)
    }
    
    @IBAction func didTapReloadData(sender: AnyObject) {
        let activityView = ActivityViewController()
        presentViewController(activityView, animated: true) {
            SIRequest().requestEvents({ events in
                self.dismissViewControllerAnimated(true, completion: {
                    if self.delegate != nil {
                        self.delegate?.updateEvents(events)
                    }
                })
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "reportABug" {
            let destination = segue.destinationViewController as? ReportABugViewController
            destination?.titleLabel.text = "Report Bug"
        }
        
        if segue.identifier == "feedback" {
            let destination = segue.destinationViewController as? ReportABugViewController
            destination?.titleLabel.text = "Leave Suggestion"
        }
        
    }
    
}

