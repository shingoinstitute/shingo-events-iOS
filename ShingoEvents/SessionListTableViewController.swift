//
//  SessionListTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/20/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit


class SessionTableViewCell: UITableViewCell {
    
    var session:EventSession? = nil
    @IBOutlet weak var sessionTitleLabel: UILabel!
    @IBOutlet weak var sessionTimeLabel: UILabel!

}

class SessionListTableViewController: UITableViewController {
    
    var day_sessions:[EventSession]? = nil
    var dataToSend:EventSession? = nil
    var event:Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SessionTableViewCell
        dataToSend = cell.session
        performSegueWithIdentifier("SessionInfoView", sender: self)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if day_sessions != nil {
            return (day_sessions?.count)!
        } else {
            return 1
        }

    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let session_date = day_sessions![0].start_end_date!.0
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        let date_string = formatter.stringFromDate(session_date)
        return "Sessions for  " + date_string
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "GillSans", size: 16.0)
        header.textLabel?.textColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SessionCell", forIndexPath: indexPath) as! SessionTableViewCell
        cell.session = day_sessions![indexPath.row]
        cell.sessionTitleLabel?.text = day_sessions![indexPath.row].name
        if day_sessions![indexPath.row].start_end_date != nil
        {
            let start_date = day_sessions![indexPath.row].start_end_date!.0
            let end_date = day_sessions![indexPath.row].start_end_date!.1
            let calendar = NSCalendar.currentCalendar()
            let comp_start = calendar.components([.Hour, .Minute], fromDate: start_date)
            let comp_end = calendar.components([.Hour, .Minute], fromDate: end_date)
            let start_time:String = timeStringFromComponents(comp_start.hour, minute: comp_start.minute)
            let end_time:String = timeStringFromComponents(comp_end.hour, minute: comp_end.minute)
            
            cell.sessionTimeLabel.text = start_time + " - " + end_time
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85.0
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "SessionInfoView" {
            let dest_vc = segue.destinationViewController as! SessionInfoViewController
            if dest_vc.session == nil {
                dest_vc.session = dataToSend
                dest_vc.speakers = self.event.speakers
            }
        }
        
    }

    // MARK: - Custom Functions
    
    func timeStringFromComponents(var hour: Int, minute:Int) -> String {
        var time:String = String()
        var am_pm:String = String()
        if hour > 12 {
            hour = hour - 12
            am_pm = " pm"
        } else {
            am_pm = " am"
        }
        time = String(hour) + ":"
        
        if minute < 10 {
            time += "0" + String(minute) + am_pm
        } else {
            time += String(minute) + am_pm
        }
        return time
    }
    
}
