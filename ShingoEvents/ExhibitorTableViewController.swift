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
    var label:UILabel = UILabel.newAutoLayoutView()
    
    var exhibitor:Exhibitor!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .DisclosureIndicator
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.accessoryType = .DisclosureIndicator        
        setupViews()
    }
    
    
    func setupViews()
    {
        contentView.addSubview(exhibitorImage)
        contentView.addSubview(label)
    }
    
    override func updateConstraints() {
        if !didSetupConstraints
        {
            NSLayoutConstraint.autoSetPriority(UILayoutPriorityRequired) {
                self.exhibitorImage.autoSetContentCompressionResistancePriorityForAxis(.Vertical)
            }
            let cellMargin: CGFloat = 8.0
            var width:CGFloat = (exhibitorImage.image?.size.width)!
            var height:CGFloat = (exhibitorImage.image?.size.height)!
            let aspectRatio = height / width
            
            if exhibitorImage.image?.size.width > 200 {
                width = (contentView.frame.width / 2.0) - cellMargin
                height = width * aspectRatio
            }
            
            exhibitorImage.autoSetDimensionsToSize(CGSize(width: width, height: height))
            exhibitorImage.autoAlignAxis(.Horizontal, toSameAxisOfView: contentView)
            exhibitorImage.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 8.0)
            
            label.text = exhibitor.name
            label.numberOfLines = 4
            label.lineBreakMode = .ByWordWrapping
            label.font = UIFont.boldSystemFontOfSize(14.0)
            
            label.autoPinEdgeToSuperviewEdge(.Top)
            label.autoPinEdge(.Left, toEdge: .Right, ofView: exhibitorImage, withOffset: 8.0)
            label.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -10.0)
            label.autoPinEdgeToSuperviewEdge(.Bottom)
            
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
        
//        tableView.registerClass(ExhibitorCell.self, forCellReuseIdentifier: "ExhibitorCell")
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
        let cell :ExhibitorCell = ExhibitorCell()
        cell.exhibitor = exhibitors[indexPath.row]
        cell.exhibitorImage.image = exhibitors[indexPath.row].logo_image
        cell.contentView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 150)
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
