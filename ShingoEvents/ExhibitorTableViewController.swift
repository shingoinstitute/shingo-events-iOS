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

class ExhibitorCell: UITableViewCell {
    
    var didSetupConstraints = false
    
    var exhibitorImage:UIImageView = UIImageView.newAutoLayoutView()
    var exhibitor:Exhibitor!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    func setupViews()
    {
        contentView.addSubview(exhibitorImage)
    }
    
    override func updateConstraints() {
        if !didSetupConstraints
        {
            NSLayoutConstraint.autoSetPriority(UILayoutPriorityRequired) {
                self.exhibitorImage.autoSetContentCompressionResistancePriorityForAxis(.Vertical)
            }
            
            exhibitorImage.autoPinEdgeToSuperviewEdge(.Top, withInset: 5.0)
            exhibitorImage.autoPinEdgeToSuperviewEdge(.Leading, withInset: 5.0)
            exhibitorImage.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 5.0)
            exhibitorImage.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 5.0)
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    
}


class ExhibitorTableViewController: UITableViewController {

    var exhibitors:[Exhibitor]!
    var dataToSend:Exhibitor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(ExhibitorCell.self, forCellReuseIdentifier: "ExhibitorCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150.0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeCategoryChanged", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }

    func contentSizeCategoryChanged(notification: NSNotification) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exhibitors.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ExhibitorCell = tableView.dequeueReusableCellWithIdentifier("ExhibitorCell", forIndexPath: indexPath) as! ExhibitorCell

        cell.exhibitor = exhibitors[indexPath.row]
        cell.exhibitorImage.image = exhibitors[indexPath.row].logo_image
        cell.exhibitorImage.frame = CGRectMake(0, 0, cell.exhibitorImage.frame.width, 100.0)
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ExhibitorCell
        dataToSend = cell.exhibitor
        performSegueWithIdentifier("ExhibitorInfoView", sender: self)
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150.0
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ExhibitorInfoView" {
            let destination = segue.destinationViewController as! ExhibitorInfoViewController
            destination.exhibitor = self.dataToSend
        }
    }
    

}
