//
//  SessionListTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/20/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit


class SessionTableViewCell: UITableViewCell {
    
    var session: SIEventSession!
    @IBOutlet weak var sessionTitleLabel: UILabel!
    @IBOutlet weak var sessionTimeLabel: UILabel!
    @IBOutlet weak var speakerLabel: UILabel!
    
    func updateCellProperties(session session: SIEventSession) {
        
        self.session = session
        
        var speakerLabelText = ""
        if let speaker = session.sessionSpeakers.first {
            
            if !session.format.isEmpty {
                speakerLabelText = session.format + ": "
            }
            
            if !speaker.name.isEmpty {
                speakerLabelText += speaker.name + ", "
            }
            
            if !speaker.title.isEmpty {
                speakerLabelText += speaker.title + ", "
            }
            
            if !speaker.organization.isEmpty {
                speakerLabelText += speaker.organization
            }
        }
        
        var timeLabelText = ""
        if !session.startEndDate.0.isNotionallyEmpty() {
            let start_date = session.startEndDate.0
            let end_date = session.startEndDate.1
            let calendar = NSCalendar.currentCalendar()
            let comp_start = calendar.components([.Hour, .Minute], fromDate: start_date)
            let comp_end = calendar.components([.Hour, .Minute], fromDate: end_date)
            let start_time:String = getTimeStringFromComponents(comp_start.hour, minute: comp_start.minute)
            let end_time:String = getTimeStringFromComponents(comp_end.hour, minute: comp_end.minute)
            
            timeLabelText = "\(start_time) - \(end_time)"
        }
        
        self.sessionTimeLabel.text = timeLabelText
        self.sessionTitleLabel.text = session.name
        self.speakerLabel.text = speakerLabelText
        
        if speakerLabelText.isEmpty {
            speakerLabel.text = session.name
            sessionTitleLabel.text = ""
        }
        
    }
    
    func getTimeStringFromComponents(hour: Int, minute:Int) -> String {
        var hour = hour
        var time = ""
        var am_pm = ""
        if hour > 12 {
            hour = hour - 12
            am_pm = " pm"
        } else if hour == 12 {
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

class SessionListTableViewController: UITableViewController {
    
    var sessions: [SIEventSession]!
    var sessionToSend: SIEventSession!
    var event: SIEvent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SessionTableViewCell
        sessionToSend = cell.session
        performSegueWithIdentifier("SessionDetailView", sender: self)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sessions != nil {
            return (sessions?.count)!
        } else {
            return 1
        }

    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let session_date = sessions![0].startEndDate.0
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
        
        cell.updateCellProperties(session: sessions[indexPath.row])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130.0
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "SessionDetailView" {
            let dest_vc = segue.destinationViewController as! SessionDetailViewController
            dest_vc.session = sessionToSend
            dest_vc.speakers = self.event.eventSpeakers
        }
        
    }

    
}
