//
//  SettingsTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/12/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import Alamofire

protocol UnwindToMainVCProtocol {
    func updateEvents(events: [SIEvent]?)
}

class SettingsTableViewController: UITableViewController, SIRequestDelegate {
    
    var events: [SIEvent]?
    
    var delegate: UnwindToMainVCProtocol?
    
    var request: Alamofire.Request?
    
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
    
    @IBAction func didTapProfileSettings(sender: AnyObject) {}

    @IBAction func didTapReportABug(sender: AnyObject) {
        performSegueWithIdentifier("ReportBugView", sender: sender)
    }
    
    @IBAction func didTapReloadData(sender: AnyObject) {
        
        let activityView = ActivityViewController()
        activityView.delegate = self
        
        presentViewController(activityView, animated: true) {
            
            self.request = SIRequest().requestEvents({ events in
                self.dismissViewControllerAnimated(true, completion: {
                    if let events = events {
                        if let delegate = self.delegate {
                            delegate.updateEvents(events)
                            self.performSegueWithIdentifier("UnwindToMainVC", sender: self)
                        }
                    } else {
                        SIRequest.displayInternetAlert(forViewController: self, completion: nil)
                    }
                })
            })
        }
    }
    
    func cancelRequest() {
        
        if let request = request {
            request.cancel()
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Navigation
    @IBAction func unwindToSettings(segue: UIStoryboardSegue) {}
    
}
