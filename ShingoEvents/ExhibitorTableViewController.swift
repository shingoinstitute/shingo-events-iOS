//
//  ExhibitorTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/27/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import AVFoundation
import PureLayout


class ExhibitorTableViewController: UITableViewController {
    
    var sectionInformation = [(String, [SIExhibitor])]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150.0
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }

    func contentSizeCategoryChanged(notification: NSNotification) {
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ExhibitorInfoView" {
            let destination = segue.destinationViewController as! ExhibitorInfoViewController
            if let exhibitor = sender as? SIExhibitor {
                destination.exhibitor = exhibitor
            }
        }
    }
}

extension ExhibitorTableViewController {
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionInformation.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionInformation[section].1.count
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = SIColor().shingoOrangeColor
        let header = UILabel()
        header.text = sectionInformation[section].0
        header.textColor = .whiteColor()
        header.font = UIFont.boldSystemFontOfSize(16.0)
        header.backgroundColor = .clearColor()
        
        view.addSubview(header)
        header.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0))
        
        return view
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: ExhibitorTableViewCell = ExhibitorTableViewCell()
        cell.exhibitor = sectionInformation[indexPath.section].1[indexPath.row]
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ExhibitorTableViewCell
        if let exhibitor = cell.exhibitor {
            performSegueWithIdentifier("ExhibitorInfoView", sender: exhibitor)
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return 200.0
        } else {
            return 150
        }
    }


}


