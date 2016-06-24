//
//  AffiliateListTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 2/1/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

public class AffiliateTableViewCell: UITableViewCell {
    
    var logoImage:UIImageView = UIImageView.newAutoLayoutView()
    var nameLabel:UILabel = UILabel.newAutoLayoutView()
    
    var affiliate: SIAffiliate!
    
    var didSetupConstraints = false
    
    override public func updateConstraints() {
        if !didSetupConstraints {
            logoImage.removeFromSuperview()
            nameLabel.removeFromSuperview()
            contentView.addSubview(logoImage)
            contentView.addSubview(nameLabel)
            
            NSLayoutConstraint.autoSetPriority(UILayoutPriorityRequired) {
                self.logoImage.autoSetContentCompressionResistancePriorityForAxis(.Vertical)
            }
            
            logoImage.image = affiliate.logoImage
            nameLabel.text = affiliate.name
  
            logoImage.contentMode = .ScaleAspectFit
            logoImage.autoSetDimension(.Width, toSize: contentView.frame.width * 0.33)
            logoImage.autoAlignAxis(.Horizontal, toSameAxisOfView: contentView, withOffset: 0)
            logoImage.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 8.0)
            
            nameLabel.autoSetDimension(.Height, toSize: 42.0)
            nameLabel.numberOfLines = 0
            nameLabel.lineBreakMode = .ByWordWrapping
            nameLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: contentView)
            nameLabel.autoPinEdge(.Left, toEdge: .Right, ofView: logoImage, withOffset: 8.0)
            nameLabel.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -8.0)
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
}

class AffiliateListTableViewController: UITableViewController {

    var affiliates: [SIAffiliate]!
    var sectionInfo:[(String, [SIAffiliate])]!
    
    var dataToSend: SIAffiliate!
    
    let cellHeight:CGFloat = 117.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - User interaction
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! AffiliateTableViewCell
        dataToSend = cell.affiliate
        performSegueWithIdentifier("AffiliateView", sender: self)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if sectionInfo != nil {
            return sectionInfo.count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionInfo != nil {
            return sectionInfo[section].1.count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(netHex: 0xcd8931)
//        view.backgroundColor = .orangeColor()
        let header = UILabel()
        header.text = String(sectionInfo[section].0).uppercaseString
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
//        let cell = tableView.dequeueReusableCellWithIdentifier("AffiliateCell", forIndexPath: indexPath) as! AffiliateTableViewCell
        let cell = AffiliateTableViewCell()
        
        let affiliate = sectionInfo[indexPath.section].1[indexPath.row]
        cell.affiliate = affiliate
        cell.logoImage.image = affiliate.logoImage
        cell.nameLabel.text = affiliate.name
        
        cell.accessoryType = .DisclosureIndicator
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        return cell
    }


    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 116
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AffiliateView" {
            let destination = segue.destinationViewController as! AfilliateViewController
            destination.affiliate = self.dataToSend
        }
    }


}
