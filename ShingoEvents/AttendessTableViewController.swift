//
//  AttendessTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 10/10/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class AttendessTableViewController: UITableViewController {

    enum AttendeeSortOrder: String {
        case ascending = "A - Z"
        case descending = "Z - A"
    }
    
    var attendees: [SIAttendee]!
    
    @IBOutlet weak var sortBarButton: UIBarButtonItem!
    
    var sortOrder: AttendeeSortOrder = .descending
    
    @IBAction func sortAttendees(_ sender: AnyObject) {
        
        switch sortOrder {
        case .descending:
            sortOrder = .ascending
            sortBarButton.title = "Sort " + sortOrder.rawValue
            let sorted = attendees.sorted(by: { $0.getLastName() > $1.getLastName() })
            attendees = sorted
        case .ascending:
            sortOrder = .descending
            sortBarButton.title = "Sort " + sortOrder.rawValue
            let sorted = attendees.sorted(by: { $0.getLastName() < $1.getLastName() })
            attendees = sorted
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = ""
        
        tableView.estimatedRowHeight = 107
        tableView.rowHeight = UITableViewAutomaticDimension
        
        sortBarButton.title = "Sort " + sortOrder.rawValue
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendees.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Attendee Cell", for: indexPath) as! AttendeeTableViewCell
        
        cell.attendee = attendees[indexPath.row]

        return cell
    }

}
