//
//  ConnectionsTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/12/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class ConnectionsTableViewController: UITableViewController {

    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            if user.connections.count == 0 {
                return 1
            } else {
                return user.connections.count
            }

        case 1:
            return 1
        case 2:
            return 1
        default:
            print("Error with section \(section.value)")
            return 0
        }

    }



    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let connection = user.connections

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("Test", forIndexPath: indexPath)
            
            if connection.count == 0 {
                cell.textLabel!.text = String("You do not have any connections")
            } else if connection[indexPath.row].status == "pending" {
                cell.textLabel!.text = String(connection[indexPath.row].first_name + " " + connection[indexPath.row].last_name + " - waiting approval")
            } else if connection[indexPath.row].status == "approved" {
                cell.textLabel!.text = String(connection[indexPath.row].first_name + " " + connection[indexPath.row].last_name)
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("PendingConnections", forIndexPath: indexPath)
            
            if checkForWaitingStatus() == false {
                cell.textLabel!.text = "You have no pending connections"
            } else if connection[indexPath.row].status == "waiting" {
                cell.textLabel!.text = connection[indexPath.row].first_name + " " + connection[indexPath.row].last_name
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("DefaultCellType", forIndexPath: indexPath)
            cell.detailTextLabel?.text = "An error has occured."
            return cell
        }

    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Approved Conections"
        case 1:
            return "Pending Connections"
        default:
            return ""
        }
    }
    
    // NOTE: "Pending Connections" section reflects connections with a "waiting" (as opposed to "pending") status
    
    // Checks for any waiting status' in user's connections. This is then reflected in the "Pending Connections"
    // section in tableView section #1.
    func checkForWaitingStatus() -> Bool {
        var temp = false
        
        for item in user.connections {
            if item.status == "waiting" {
                temp = true
            }
        }
        
        return temp
    }
    

}
