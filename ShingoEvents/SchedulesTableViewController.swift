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

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView();
//        view.backgroundColor = UIColor(netHex: 0xde9a42);
        view.backgroundColor = .clearColor()
        let header = UILabel();
        header.text = event.name;
        header.lineBreakMode = .ByWordWrapping;
        header.textAlignment = .Center;
        header.numberOfLines = 2;
        header.textColor = .whiteColor();
        header.font = UIFont.boldSystemFontOfSize(16.0);
        header.clipsToBounds = true;
        header.backgroundColor = UIColor(netHex: 0xde9a42);
        header.layer.borderWidth = 1.0;
        header.layer.cornerRadius = 5;
        view.addSubview(header);
        header.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4));
        
        return view;
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50;
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SessionListView" {
            let dest_vc = segue.destinationViewController as! SessionListTableViewController
            if dest_vc.sessions == nil || dest_vc.event != nil {
                sortSessionsByDate(&dataToSend)
                dest_vc.sessions = dataToSend
                dest_vc.event = self.event!
            }
        }
    }
    
    
    // MARK: - Custom functions
    
    func sortSessionsByDate(inout sessions:[EventSession]) {
    
        for i in 0 ..< sessions.count - 1 {
            for j in 0 ..< sessions.count - i - 1 {
            
                if sessions[j].start_end_date == nil { continue }
                
                if sessions[j].start_end_date!.0.timeIntervalSince1970 > sessions[j+1].start_end_date!.0.timeIntervalSince1970
                {
                    let temp = sessions[j]
                    sessions[j] = sessions[j+1]
                    sessions[j+1] = temp
                }
                
                if sessions[j].start_end_date!.0.timeIntervalSince1970 == sessions[j+1].start_end_date!.0.timeIntervalSince1970
                {
                    if sessions[j].start_end_date!.1.timeIntervalSince1970 > sessions[j+1].start_end_date!.1.timeIntervalSince1970
                    {
                        let temp = sessions[j]
                        sessions[j] = sessions[j+1]
                        sessions[j+1] = temp
                    }
                }
            }
        }
    }
    
}















