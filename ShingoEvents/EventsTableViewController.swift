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
    
    var appData: AppData!
    var cell_index_path: NSIndexPath!
    var number_of_async_tasks = 7
    var async_tasks_completed = 0
    var progress:Float = 0
    
    var activityView = ActivityView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissViewControllerAnimated(true, completion: nil)
        if appData == nil {
            let alert = UIAlertController(title: "Oops!",
                message: "We were unable to fetch any data for you. Please check your internet connection and try reloading our upcoming events in the main menu.",
                preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
            appData = AppData()
        }
        
    }
    
    
    func asyncTaskDidComplete() -> Void {
        async_tasks_completed += 1
        if async_tasks_completed == number_of_async_tasks {
            let cell = tableView.cellForRowAtIndexPath(cell_index_path) as! EventTableViewCell
            cell.event = self.appData.event
            self.performSegueWithIdentifier("EventMenu", sender: self)
            activityView.removeActivityViewFromDisplay()
        } else {
            progress += Float(1.0) / Float(number_of_async_tasks + 1)
            activityView.progressIndicator.progress += progress
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let events = appData.upcomingEvents
        if events != nil
        {
            return events.count
        }
        else
        {
            return 0
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let event = appData.upcomingEvents[indexPath.row]
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateStyle = .MediumStyle
        let dateRangeText = "\(dateFormatter.stringFromDate(event.eventStartDate)) - \(dateFormatter.stringFromDate(event.eventEndDate))"
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EventsCell", forIndexPath: indexPath) as! EventTableViewCell
        
        cell.updateCellProperties(dateRangeText: dateRangeText, event: event)
            
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 93.0 as CGFloat
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! EventTableViewCell
        appData.event = cell.event
        cell_index_path = indexPath
        self.async_tasks_completed = 0
        
        if !cell.event.didLoadSessions {
            
            activityView.displayActivityView(message: "Loading Conference Data...", forView: self.view, withRequest: nil)
            // appData.eventSessions should have data populated before making other API calls
            appData.getEventSessions() {
                self.asyncTaskDidComplete()
                self.appData.getAgenda() {
                    self.asyncTaskDidComplete()
                }
                self.appData.getSpeakers() {
                    self.asyncTaskDidComplete()
                }
                self.appData.getRecipients() {
                    self.asyncTaskDidComplete()
                }
                self.appData.getExhibitors() {
                    self.asyncTaskDidComplete()
                }
                self.appData.getAffiliates() {
                    self.asyncTaskDidComplete()
                }
                self.appData.getSponsors() {
                    self.asyncTaskDidComplete()
                }
            }
            
            cell.event.didLoadSessions = true
            
        } else {
            self.performSegueWithIdentifier("EventMenu", sender: self)
        }

        
    }
    
    
    //     MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "EventMenu" {
            let dest_vc = segue.destinationViewController as! EventMenuViewController
            dest_vc.appData = self.appData
            let backButton = UIBarButtonItem()
            backButton.title = "Back"
            navigationItem.backBarButtonItem = backButton
        }
    }
    
    
}









