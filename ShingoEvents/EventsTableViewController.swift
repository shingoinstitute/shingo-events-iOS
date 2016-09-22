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

        definesPresentationContext = true
        providesPresentationContextTransitionStyle = true
        
        view.backgroundColor = SIColor.shingoBlue
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
        switch section {
            case 0:
                return events.count
            default:
                return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsCell", for: indexPath) as! EventTableViewCell
        
        cell.delegate = self
        cell.event = events[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if !events[(indexPath as NSIndexPath).row].didLoadImage {
            return 75
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 240
        }
        
        return 155
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
        view.font = UIFont(name: "Helvetica", size: 12)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! EventTableViewCell
        cell.backgroundColor = SIColor.lightShingoBlue
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
    
    func updateCell() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}


class EventTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateRangeLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    var event: SIEvent! {
        didSet {
            updateCell()
        }
    }
    
    var delegate: SICellDelegate?
    
    func updateCell() {
        
        backgroundColor = .clear
        selectionStyle = .none
        
        guard let event = event else {
            return
        }

        nameLabel.text = event.name
        
        eventImage.contentMode = .scaleAspectFill
        eventImage.clipsToBounds = true
        eventImage.layer.cornerRadius = 3.0
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateStyle = .medium
        let dates = "\(dateFormatter.string(from: event.startDate as Date)) - \(dateFormatter.string(from: event.endDate as Date))"
        dateRangeLabel.text = dates
        
        event.getBannerImage() { image in
            
            guard let image = image else {
                return
            }
            
            self.eventImage.image = image
            if let delegate = self.delegate {
                delegate.updateCell()
            }
            
        }
        
    }
    
}

