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
    
    var exhibitor: SIExhibitor!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .DisclosureIndicator
        contentView.addSubview(exhibitorImage)
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            NSLayoutConstraint.autoSetPriority(UILayoutPriorityRequired) {
                self.exhibitorImage.autoSetContentCompressionResistancePriorityForAxis(.Vertical)
            }
            
            exhibitorImage.contentMode = UIViewContentMode.ScaleAspectFit
            
            var width: CGFloat = 0.0
            var height: CGFloat = 0.0
            
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                width = contentView.frame.width * (1/3)
                height = 150
            } else {
                width = 300
                height = 200
            }
            
            exhibitorImage.autoSetDimensionsToSize(CGSize(width: width, height: height))
            exhibitorImage.autoAlignAxis(.Horizontal, toSameAxisOfView: contentView)
            exhibitorImage.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 8)
            
            label.text = exhibitor.name
            label.numberOfLines = 4
            label.lineBreakMode = .ByWordWrapping
            label.font = UIFont.boldSystemFontOfSize(14.0)
            
            label.autoPinEdgeToSuperviewEdge(.Top)
            label.autoPinEdge(.Left, toEdge: .Right, ofView: exhibitorImage, withOffset: 8)
            label.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -10)
            label.autoPinEdgeToSuperviewEdge(.Bottom)
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    
}

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////

class ExhibitorTableViewController: UITableViewController {

    var exhibitors:[SIExhibitor]!
    var dataToSend:SIExhibitor!
    var sectionInformation = [(Character, [SIExhibitor])]()
    
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
        header.text = String(sectionInformation[section].0).uppercaseString
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
        let cell :ExhibitorCell = ExhibitorCell()
        let exhibitor = sectionInformation[indexPath.section].1[indexPath.row]
        cell.exhibitor = exhibitor
        cell.exhibitorImage.image = exhibitor.logoImage
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
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return 200.0
        } else {
            return 150
        }
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ExhibitorInfoView" {
            let destination = segue.destinationViewController as! ExhibitorInfoViewController
            destination.exhibitor = self.dataToSend
        }
    }


}


