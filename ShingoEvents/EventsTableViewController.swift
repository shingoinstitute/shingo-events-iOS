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
    
    func updateCell(event event: SIEvent) {
        self.event = event
        self.nameLabel.text = event.name
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateStyle = .MediumStyle
        let dates = "\(dateFormatter.stringFromDate(event.startDate)) - \(dateFormatter.stringFromDate(event.endDate))"
        self.dateRangeLabel.text = dates
    }
    
}


class EventsTableViewController: UITableViewController {
    
    var events = [SIEvent]()

    var activityView = ActivityView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func displayBadRequestNotification() {
        let alert = UIAlertController(title: "Oops!",
                                      message: "We were unable to fetch any data for you. Please make sure you have an internet connection.",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return events.count
            default:
                return 0
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EventsCell", forIndexPath: indexPath) as! EventTableViewCell
        cell.updateCell(event: events[indexPath.row])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 93.0 as CGFloat
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let activityView = ActivityView()
        activityView.displayActivityView(message: "Loading Event Data...", forView: self.view, withRequest: nil)
        activityView.animateProgress(1.0)
        SIRequest().requestEvent(events[indexPath.row].id) { event in
            
            activityView.removeActivityViewFromDisplay()
            
            if let event = event {
                self.performSegueWithIdentifier("EventMenu", sender: event)
            } else {
                self.displayBadRequestNotification()
            }
        }
        
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "EventMenu" {
            let destination = segue.destinationViewController as! EventMenuViewController
            destination.event = sender as! SIEvent
            print((sender as! SIEvent).name)
        }
    }
    
    
}









