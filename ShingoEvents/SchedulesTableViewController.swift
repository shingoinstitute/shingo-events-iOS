//
//  SchedulesTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/14/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class SchedulesTableViewController: UITableViewController {

    var agendas : [SIAgenda]!
    var eventName : String!

    var dataToSend = [SISession]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Schedule"
    }
 
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        navigationItem.title = ""
        if segue.identifier == "SessionListView" {
            let destination = segue.destinationViewController as! SessionListTableViewController
            if let sessions = sender as? [SISession] {
                destination.sessions = self.sortSessionsByDate(sessions)
            }
        }
    }
    
    // MARK: - Sorting
    private func sortSessionsByDate(sender: [SISession]) -> [SISession] {
        var sessions = sender
        for i in 0 ..< sessions.count - 1 {
            
            for n in 0 ..< sessions.count - i - 1 {
                
                if sessions[n].startDate.isGreaterThanDate(sessions[n+1].startDate) {
                    let session = sessions[n]
                    sessions[n] = sessions[n+1]
                    sessions[n+1] = session
                }
            }
        }
        
        return sessions
    }
    
}


extension SchedulesTableViewController {

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agendas.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScheduleCell", forIndexPath: indexPath) as! SchedulesTableViewCell
        cell.agenda = agendas[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if agendas[indexPath.row].didLoadSessions {
            self.performSegueWithIdentifier("SessionListView", sender: agendas[indexPath.row].sessions)
        } else {
            
            let av = ActivityViewController()
            
            self.presentViewController(av, animated: true, completion: {
                self.agendas[indexPath.row].requestAgendaSessions() {
                    self.dismissViewControllerAnimated(false, completion: {
                        self.performSegueWithIdentifier("SessionListView", sender: self.agendas[indexPath.row].sessions)
                    });
                }
            });
        }
    }
}


class SchedulesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var agendaLabel: UILabel!
    var agenda : SIAgenda! {
        didSet {
            updateCell()
        }
    }
    
    func updateCell() {
        
        if let agenda = self.agenda {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.dateStyle = .MediumStyle
            dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
            
//            let dateText: String = dateFormatter.stringFromDate(agenda.date.dateByAddingTimeInterval(60*60*24))
            
            agendaLabel.text = "\(agenda.displayName), \(dateFormatter.stringFromDate(agenda.date))"
        }
    }
    
}











