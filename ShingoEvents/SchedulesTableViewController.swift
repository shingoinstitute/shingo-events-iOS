//
//  SchedulesTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/14/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class  SchedulesTableViewCell: UITableViewCell {
    
    var sessions:[EventSession]!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

class SchedulesTableViewController: UITableViewController {

    var event:Event!

    var dataToSend = [EventSession]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SchedulesTableViewCell
        dataToSend = cell.sessions!
        performSegueWithIdentifier("SessionListView", sender: self)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.event!.eventAgenda.days_array.count
        } else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScheduleCell", forIndexPath: indexPath) as! SchedulesTableViewCell
        
        switch indexPath.section {
        case 0:
            cell.sessions = self.event.eventAgenda.days_array[indexPath.row].sessions
            
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            let date_string = formatter.stringFromDate(cell.sessions[0].start_end_date!.0)
            
            cell.textLabel?.text = (self.event?.eventAgenda.days_array[indexPath.row].dayOfWeek)! + " " + date_string
        default:
            break
        }
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SessionListView" {
            let dest_vc = segue.destinationViewController as! SessionListTableViewController
            if dest_vc.day_sessions == nil || dest_vc.event != nil {
                sortSessionsByDate(&dataToSend)
                dest_vc.day_sessions = dataToSend
                dest_vc.event = self.event!
            }
        }
    }
    
    
    // MARK: - Custom functions
    
    func sortSessionsByDate(inout sessions:[EventSession]) {
    
        for(var i = 0; i < sessions.count - 1; i++) {
            for(var j = 0; j < sessions.count - i - 1; j++) {
                
                if sessions[j].start_end_date == nil { continue }
                
                if sessions[j].start_end_date!.0.timeIntervalSince1970 > sessions[j+1].start_end_date!.0.timeIntervalSince1970
                {
                    let temp = sessions[j].start_end_date!
                    sessions[j].start_end_date! = sessions[j+1].start_end_date!
                    sessions[j+1].start_end_date! = temp
                }
                
                if sessions[j].start_end_date!.0.timeIntervalSince1970 == sessions[j+1].start_end_date!.0.timeIntervalSince1970
                {
                    if sessions[j].start_end_date!.1.timeIntervalSince1970 > sessions[j+1].start_end_date!.1.timeIntervalSince1970
                    {
                        let temp = sessions[j].start_end_date!
                        sessions[j].start_end_date! = sessions[j+1].start_end_date!
                        sessions[j+1].start_end_date! = temp
                    }
                }
            }
        }
    }
    
}















