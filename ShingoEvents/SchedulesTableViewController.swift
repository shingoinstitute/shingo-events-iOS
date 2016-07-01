//
//  SchedulesTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/14/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class SchedulesTableViewController: UITableViewController {

    var agenda : [SIAgenda]!
    var eventName : String!

    var dataToSend = [SISession]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if agenda == nil || eventName == nil {
            fatalError()
        }
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        SIRequest().requestSessions(id: agenda[indexPath.row].id, callback: { sessions in
            if let sessions = sessions {
                self.performSegueWithIdentifier("SessionListView", sender: sessions)
            }
        })
        
        
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agenda.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScheduleCell", forIndexPath: indexPath) as! SchedulesTableViewCell
        
        cell.updateCell(agenda[indexPath.row])
        
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
        if segue.identifier == "SessionListView" {
            let destination = segue.destinationViewController as! SessionListTableViewController
            if let sessions = sender as? [SISession] {
                destination.sessions = sessions
            }
        }
    }
    
}


class  SchedulesTableViewCell: UITableViewCell {
    
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













