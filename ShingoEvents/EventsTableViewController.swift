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
    var event:Event? = nil
}


class EventsTableViewController: UITableViewController {
    
    var appData:AppData!
    var cell_index_path:NSIndexPath!
    var number_of_async_tasks = 7
    var async_tasks_completed = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Number of async tasks: \(number_of_async_tasks)")

        if appData.upcomingEvents?.count == 0 {
            
            let alert = UIAlertController(title: "Oops!",
                message: "We were unable to fetch any data for you. Please check your internet connection and try again.",
                preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
            
        }
        
    }
    
    
    func asyncTaskDidComplete() -> Void {
        async_tasks_completed++
        if async_tasks_completed == number_of_async_tasks {
            let cell = tableView.cellForRowAtIndexPath(cell_index_path) as! EventTableViewCell
            cell.event = self.appData.event
            self.performSegueWithIdentifier("EventMenu", sender: self)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appData!.upcomingEvents!.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EventsCell", forIndexPath: indexPath) as! EventTableViewCell
        // Configure the cell...
        let event = appData!.upcomingEvents![indexPath.row]
        cell.event = event
        cell.nameLabel.text = event.name
        
        let formatter = NSDateFormatter() // Date formatting
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.dateStyle = .MediumStyle
        
        cell.dateRangeLabel.text = formatter.stringFromDate(cell.event!.event_start_date) + " - " + formatter.stringFromDate(cell.event!.event_end_date)
        
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

        if cell.event?.eventSessions == nil
        {
            let activitiyViewController = ActivityViewController(message: "Loading Conference Data...")
            presentViewController(activitiyViewController, animated: true, completion: nil)
            appData.getEventSessions() { // appData.eventSessions should be populated before calling other tasks
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
        } else {
            performSegueWithIdentifier("EventMenu", sender: self)
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









