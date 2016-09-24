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

    override func loadView() {
        super.loadView()
        
        //Begin requests for each event.
        for event in events {
            if !event.didLoadEventData {
                event.requestEvent(nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Upcoming Events"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for event in events {
            tableView.register(UINib(nibName: "EventTableViewCellNib", bundle: nil), forCellReuseIdentifier: event.id)
        }
        
        tableView.estimatedRowHeight = 100;
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        tableView.estimatedSectionHeaderHeight = 32;
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        
//        view.backgroundColor = SIColor.shingoBlue;
        view.backgroundColor = .white
    }
    
    func displayBadRequestNotification() {
        let alert = UIAlertController(title: "Oops!",
                                      message: "We were unable to fetch any data for you. Please make sure you have an internet connection.",
                                      preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension EventsTableViewController: SICellDelegate {

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let event = events[indexPath.row];
        
        let cell = tableView.dequeueReusableCell(withIdentifier: event.id, for: indexPath) as! EventTableViewCell;

        cell.delegate = self;
        cell.event = event;
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UILabel()
        
        switch events.count {
        case 1:
            view.text = "   \(events.count) Event Found"
        default:
            view.text = "   \(events.count) Events Found"
        }
        
        view.textColor = .white
        view.textAlignment = .center
        view.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return view
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! EventTableViewCell
        cell.backgroundColor = SIColor.lightShingoBlue
        
        let activityView = ActivityViewController()
        activityView.message = "Loading Event Data..."

        let event = events[(indexPath as NSIndexPath).row]
        if event.didLoadEventData {
            self.performSegue(withIdentifier: "EventMenu", sender: event)
        } else {
            present(activityView, animated: false, completion: { 
                event.requestEvent() {
                    self.dismiss(animated: true, completion: {
                        if event.didLoadEventData {
                            self.performSegue(withIdentifier: "EventMenu", sender: self.events[(indexPath as NSIndexPath).row])
                        } else {
                            self.displayBadRequestNotification()
                        }
                        
                    })
                }
            })
        }
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EventMenu" {
            let destination = segue.destination as! EventMenuViewController
            if let event = sender as? SIEvent {
                destination.event = event
            }
            navigationItem.title = ""
        }
    }
    
    func cellDidUpdate() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}





