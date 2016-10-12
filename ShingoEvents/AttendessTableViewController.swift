//
//  AttendessTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 10/10/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class AttendessTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    var attendees: [SIAttendee]!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredResults: [SIAttendee] = []
    
    var shouldShowSearchResults = false
    
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 107
        tableView.rowHeight = UITableViewAutomaticDimension
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredResults.count
        } else {
            return attendees.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Attendee Cell", for: indexPath) as! AttendeeTableViewCell
        
        cell.selectionStyle = .none
        
        if shouldShowSearchResults {
            cell.attendee = filteredResults[indexPath.row]
        } else {
            cell.attendee = attendees[indexPath.row]
        }
        

        return cell
    }

    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchController.searchBar.text!)
    }
    
    func filterContentFor(_ search: String) {
        filteredResults = attendees.filter({ (attendee) -> Bool in
            return attendee.name.lowercased().contains(search.lowercased())
        })
        shouldShowSearchResults = !search.isEmpty
        filteredResults.sort(by: { $0.name < $1.name })
        tableView.reloadData()
    }
    
}
