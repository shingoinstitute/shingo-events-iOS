//
//  EventsViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/4/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import Foundation


class EventsTableViewController: UITableViewController {
    
    // MARK: - Properties
    var events: [SIEvent]!

    var activityView : ActivityViewController = {
        let view = ActivityViewController()
        view.modalPresentationStyle = .OverCurrentContext
        return view
    }()
    
    override func loadView() {
        super.loadView()
        
        //Begin requests for each event.
        for event in events {
            if !event.didLoadEventData {
                event.requestEvent(nil)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Upcoming Events"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        definesPresentationContext = true
        providesPresentationContextTransitionStyle = true
        
        view.backgroundColor = SIColor.prussianBlueColor()
    }
    
    func displayBadRequestNotification() {
        let alert = UIAlertController(title: "Oops!",
                                      message: "We were unable to fetch any data for you. Please make sure you have an internet connection.",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}

extension EventsTableViewController {

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
        cell.backgroundColor = .clearColor()
        cell.selectionStyle = .None
        cell.updateCell(event: events[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if !events[indexPath.row].didLoadBannerImage {
            return 75.0
        }
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return 240
        }
        
        return 155.0 as CGFloat
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UILabel()
        
        switch events.count {
        case 1:
            view.text = "   \(events.count) Event Found"
        default:
            view.text = "   \(events.count) Events Found"
        }
        
        view.textColor = .whiteColor()
        view.font = UIFont(name: "Helvetica", size: 12)
        return view
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! EventTableViewCell
        cell.backgroundColor = SIColor.lightBlueColor()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! EventTableViewCell
        cell.backgroundColor = SIColor.lightBlueColor()
        
        let activityView = ActivityViewController()
        activityView.modalPresentationStyle = .OverCurrentContext
        activityView.message = "Loading Event Data..."

        let event = events[indexPath.row]
        if event.didLoadEventData {
            self.performSegueWithIdentifier("EventMenu", sender: event)
        } else {
            presentViewController(activityView, animated: false, completion: { 
                event.requestEvent() {
                    self.dismissViewControllerAnimated(true, completion: {
                        self.performSegueWithIdentifier("EventMenu", sender: self.events[indexPath.row])
                    });
                }
            });
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "EventMenu" {
            let destination = segue.destinationViewController as! EventMenuViewController
            if let event = sender as? SIEvent {
                destination.event = event
            }
            navigationItem.title = ""
        }
    }
    
}


class EventTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateRangeLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    var event: SIEvent!
    
    func updateCell(event event: SIEvent) {
        self.event = event
        nameLabel.text = event.name
        
        eventImage.contentMode = .ScaleAspectFill
        eventImage.clipsToBounds = true
        eventImage.layer.cornerRadius = 3.0
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateStyle = .MediumStyle
        let dates = "\(dateFormatter.stringFromDate(event.startDate)) - \(dateFormatter.stringFromDate(event.endDate))"
        dateRangeLabel.text = dates
        
        event.getBannerImage() { image in
            self.eventImage.image = image
        }
    }
    
}

