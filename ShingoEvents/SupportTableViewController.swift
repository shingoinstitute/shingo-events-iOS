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
    func updateEvents(_ events: [SIEvent]?)
}

class SettingsTableViewController: UITableViewController {
    
    var events: [SIEvent]?
    
    var delegate: UnwindToMainVCProtocol?
    
    var request: Alamofire.Request?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        if self.responds(to: action) {
            return true
        } else {
            return false
        }
    }
    
    @IBAction func didTapProfileSettings(_ sender: AnyObject) {}

    @IBAction func didTapReportABug(_ sender: AnyObject) {
        performSegue(withIdentifier: "ReportBugView", sender: sender)
    }
    
    @IBAction func didTapReloadData(_ sender: AnyObject) {
        
        let activityView = ActivityViewController()
        
        present(activityView, animated: true) {
            
            SIRequest().requestEvents({ events in
                self.dismiss(animated: false, completion: {
                    if let events = events {
                        if let delegate = self.delegate {
                            delegate.updateEvents(events)
                            self.performSegue(withIdentifier: "UnwindToMainVC", sender: self)
                        }
                    } else {
                        SIRequest.displayInternetAlert(forViewController: self, completion: nil)
                    }
                })
            })
        }
    }
    
    //MARK: - Navigation
    @IBAction func unwindToSettings(_ segue: UIStoryboardSegue) {}
    
}
