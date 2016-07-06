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
    
    // MARK: - Properties
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
    
    // MARK: - Properties
    var events = [SIEvent]()
    var event : SIEvent?
    var time : Double = 0
    var timer : NSTimer!

    var activityView = ActivityView()
    
    override func loadView() {
        super.loadView()
        for i in 0 ..< events.count {
            SIRequest().requestEvent(eventId: events[i].id, callback: { event in
                if let event = event {
                    event.didLoadEventData = true
                    self.events[i] = event
                }
            })
        }
        
        
    }
    
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
        activityView.displayActivityView(message: "Loading Event Data...", forView: self.view)

        let event = events[indexPath.row]
        if event.didLoadEventData {
            activityView.removeActivityViewFromDisplay()
            self.performSegueWithIdentifier("EventMenu", sender: event)
        } else {
            self.event = event
            time = 0
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(EventsTableViewController.checkRequestStatus), userInfo: nil, repeats: true)
        }
    }
    
    @objc func checkRequestStatus() {
        
        guard let event = self.event else {
            fatalError()
        }
        
        time += 0.1
        
        if self.events.count == 0 {
            timer.invalidate()
            activityView.removeActivityViewFromDisplay()
            return
        }
        
        if event.didLoadEventData {
            timer.invalidate()
            activityView.removeActivityViewFromDisplay()
            performSegueWithIdentifier("EventMenu", sender: event)
        }
        
        if time > 12.0 {
            timer.invalidate()
            activityView.removeActivityViewFromDisplay()
            displayBadRequestNotification()
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



