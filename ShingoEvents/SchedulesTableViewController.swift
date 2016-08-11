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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
//        agendas[indexPath.row].requestAgendaInformation() {
//            self.performSegueWithIdentifier("SessionListView", sender: self.agendas[indexPath.row].sessions)
//        }
        
        if agendas[indexPath.row].didLoadSessions {
            self.performSegueWithIdentifier("SessionListView", sender: agendas[indexPath.row].sessions)
        } else {
            
            self.modalPresentationStyle = .CurrentContext
            
            let av = ActivityViewController()
            presentViewController(av, animated: true, completion: nil)

            self.agendas[indexPath.row].requestAgendaInformation() {
                self.performSegueWithIdentifier("SessionListView", sender: self.agendas[indexPath.row].sessions)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    // MARK: - Table view data source

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

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView();
        view.backgroundColor = .clearColor()
        let header = UILabel();
        header.text = eventName;
        header.lineBreakMode = .ByWordWrapping;
        header.textAlignment = .Center;
        header.numberOfLines = 2;
        header.textColor = .whiteColor();
        header.font = UIFont.boldSystemFontOfSize(16.0);
        header.clipsToBounds = true;
        header.backgroundColor = SIColor().shingoOrangeColor //UIColor(netHex: 0xde9a42);
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
        
//        dismissViewControllerAnimated(true, completion: nil)
        
        if segue.identifier == "SessionListView" {
            let destination = segue.destinationViewController as! SessionListTableViewController
            if let sessions = sender as? [SISession] {
                destination.sessions = self.sortSessionsByDate(sessions)
            }
        }
    }
    
    // MARK: - Other Functions
    
    func sortSessionsByDate(sender: [SISession]) -> [SISession] {
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













