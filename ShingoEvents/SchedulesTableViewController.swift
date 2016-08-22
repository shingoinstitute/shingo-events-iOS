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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        providesPresentationContextTransitionStyle = true
        definesPresentationContext = true
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
    
    // MARK: - Other Functions
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

// MARK: - Table view data source
extension SchedulesTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agendas.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScheduleCell", forIndexPath: indexPath) as! SchedulesTableViewCell
        cell.updateCell(agendas[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if agendas[indexPath.row].didLoadSessions {
            self.performSegueWithIdentifier("SessionListView", sender: agendas[indexPath.row].sessions)
        } else {
            
            let av = ActivityViewController()
            av.modalPresentationStyle = .OverCurrentContext
            
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
    var agenda : SIAgenda!
    
    func updateCell(agenda: SIAgenda) {
        self.agenda = agenda
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateStyle = .MediumStyle
        
        let date = dateFormatter.stringFromDate(agenda.date)
        
        agendaLabel.text = "\(agenda.displayName), \(date)"
    }
    
}











