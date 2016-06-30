//
//  EventsViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/4/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import Foundation

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateRangeLabel: UILabel!
    var event: SIEvent!
    
    func updateCellProperties(dateRangeText dateRange: String, event: SIEvent) {
        self.event = event
        self.nameLabel.text = event.name
        self.dateRangeLabel.text = dateRange
    }
    
}


class EventsTableViewController: UITableViewController {
    
    let NUMBER_OF_API_REQUESTS : Double = 7
    
    var cellIndexPath : NSIndexPath!
    var numberOfAPIRequestCompleted : Double = 0 {
        didSet {
            APICallsCompleted()
        }
    }
    var gotEventSessions = false
    var gotAgenda = false
    var gotSpeakers = false
    var gotRecipients = false
    var gotExhibitors = false
    var gotAffiliates = false
    var gotSponsors = false
    
    var activityView = ActivityView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissViewControllerAnimated(true, completion: nil)
//        if appData == nil {
//            let alert = UIAlertController(title: "Oops!",
//                message: "We were unable to fetch any data for you. Please check your internet connection and try reloading our upcoming events in the main menu.",
//                preferredStyle: UIAlertControllerStyle.Alert)
//            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
//            alert.addAction(action)
//            presentViewController(alert, animated: true, completion: nil)
//            appData = AppData()
//        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let events = appData.upcomingEvents
//        if events != nil {
//            return events.count
//        } else {
//            return 0
//        }
        
        // Need to implement!!!
        return 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        let event = appData.upcomingEvents[indexPath.row]
//        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.dateStyle = .MediumStyle
//        let dateRangeText = "\(dateFormatter.stringFromDate(event.eventStartDate)) - \(dateFormatter.stringFromDate(event.eventEndDate))"
//        
        let cell = tableView.dequeueReusableCellWithIdentifier("EventsCell", forIndexPath: indexPath) as! EventTableViewCell
//
//        cell.updateCellProperties(dateRangeText: dateRangeText, event: event)
//            
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 93.0 as CGFloat
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as! EventTableViewCell
//        appData.event = cell.event
//        cellIndexPath = indexPath
//        self.numberOfAPIRequestCompleted = 0
//        
//        if !cell.event.didLoadSessions {
//            
//            activityView.displayActivityView(message: "Loading Conference Data...", forView: self.view, withRequest: nil)
//            
//            loadEventData()
//            
//            cell.event.didLoadSessions = true
//            
//        } else {
//            self.performSegueWithIdentifier("EventMenu", sender: self)
//        }

        
    }
    
    // MARK: - Custom functions
    
    func APICallDidComplete() -> Void {
        
//        if APICallsCompleted() {
//            let cell = tableView.cellForRowAtIndexPath(cellIndexPath) as! EventTableViewCell
//            cell.event = self.appData.event
//            self.performSegueWithIdentifier("EventMenu", sender: self)
//            activityView.removeActivityViewFromDisplay()
//        } else {
//            activityView.progressIndicator.progress += Float(numberOfAPIRequestCompleted / NUMBER_OF_API_REQUESTS)
//        }
    }
    
    func APICallsCompleted() -> Bool {
        if !gotEventSessions {return false}
        else if !gotAgenda {return false}
        else if !gotSpeakers {return false}
        else if !gotRecipients {return false}
        else if !gotExhibitors {return false}
        else if !gotAffiliates {return false}
        else if !gotSponsors {return false}
        else {return true}
    }
    
    func loadEventData() {
        
        // appData.eventSessions needs to have data populated first before making other API calls
//        appData.getEventSessions() {
//            
//            self.gotEventSessions = true
//            
//            self.appData.getAgenda() { self.gotAgenda = true; self.numberOfAPIRequestCompleted.increment() }
//            
//            self.appData.getSpeakers() { self.gotSpeakers = true; self.numberOfAPIRequestCompleted.increment() }
//            
//            self.appData.getRecipients() { self.gotRecipients = true; self.numberOfAPIRequestCompleted.increment()  }
//            
//            self.appData.getExhibitors() { self.gotExhibitors = true; self.numberOfAPIRequestCompleted.increment()  }
//            
//            self.appData.getAffiliates() { self.gotAffiliates = true; self.numberOfAPIRequestCompleted.increment()  }
//            
//            self.appData.getSponsors() { self.gotSponsors = true; self.numberOfAPIRequestCompleted.increment()  }
//            
//        }
        
    }
    
    
    //     MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "EventMenu" {
            
            let destination = segue.destinationViewController as! EventMenuViewController
            navigationItem.backBarButtonItem?.title = "Back"
            // Do other cool stuff
        }
    }
    
    
}









