//
//  SponsorsTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 2/3/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import PureLayout

class SponsorsTableViewController: UITableViewController {

    let cellIdentifier = "SponsorCell"
    
    var friends:[SISponsor]!
    var supporters:[SISponsor]!
    var benefactors:[SISponsor]!
    var champions:[SISponsor]!
    var presidents:[SISponsor]!
    
    var sectionTitles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var numSections = 0
        if presidents.count > 0 {
            numSections += 1
            sectionTitles.append("Presidents")
        }
        if champions.count > 0 {
            numSections += 1
            sectionTitles.append("Champions")
        }
        if benefactors.count > 0 {
            numSections += 1
            sectionTitles.append("Benefactors")
        }
        if supporters.count > 0 {
            numSections += 1
            sectionTitles.append("Supporters")
        }
        if friends.count > 0 {
            numSections += 1
            sectionTitles.append("Friends")
        }

        return numSections
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.backgroundColor = UIColor(netHex: 0xcd8931)
        header.text = sectionTitles[section]
        header.textColor = .whiteColor()
        header.font = UIFont.boldSystemFontOfSize(16.0)
        header.textAlignment = .Center
        
        return header
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let title = sectionTitles[section]
        
        if title == "Presidents" {
            return presidents.count
        } else if title == "Champions" {
            return champions.count
        } else if title == "Benefactors" {
            return benefactors.count
        } else if title == "Supporters" {
            return supporters.count
        } else if title == "Friends" {
            return friends.count
        } else {
            print("ERROR: Was not able to get number of rows in section when given a section title.")
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("SponsorCell", forIndexPath: indexPath) as! SponsorTableViewCell
        let cell = SponsorTableViewCell()
//        switch sectionTitles[indexPath.section] {
//        case "Friends":
//            if (friends?.count > 0) {
//                cell.bannerImage.image = friends[indexPath.row].getRecipientImage()
//                cell.sponsor = friends[indexPath.row]
//            }
//        case "Supporters":
//            if (supporters?.count > 0) {
//                cell.bannerImage.image = supporters[indexPath.row].getRecipientImage()
//                cell.sponsor = supporters[indexPath.row]
//            }
//        case "Benefactors":
//            if (benefactors?.count > 0) {
//                cell.bannerImage.image = benefactors[indexPath.row].getRecipientImage()
//                cell.sponsor = benefactors[indexPath.row]
//            }
//        case "Champions":
//            if (champions?.count > 0) {
//                cell.bannerImage.image = champions[indexPath.row].getRecipientImage()
//                cell.sponsor = champions[indexPath.row]
//            }
//        case "Presidents":
//            if (presidents?.count > 0) {
//                cell.bannerImage.image = presidents[indexPath.row].getRecipientImage()
//                cell.sponsor = presidents[indexPath.row]
//            }
//        default: break
//        }
        cell.selectionStyle = .None
        cell.contentView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 150.0)
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }


    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150.0
    }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150.0
    }

}

class SponsorTableViewCell:UITableViewCell {
    
    var sponsor:SISponsor!
    
    let horizontalInsets:CGFloat = 15.0
    let verticalInsets:CGFloat = 10.0
    
    var didSetupConstraints = false

    var bannerImage:UIImageView = UIImageView.newAutoLayoutView()
    var testView:UIView = UIView.newAutoLayoutView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bannerImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        if !didSetupConstraints
        {
            NSLayoutConstraint.autoSetPriority(UILayoutPriorityRequired) {
                self.bannerImage.autoSetContentCompressionResistancePriorityForAxis(.Vertical)
            }
            
//            if let image = self.sponsor.logoImage {
//                bannerImage.image = image
//            } else if let image = self.sponsor.bannerImage {
//                bannerImage.image = image
//            }
            
            bannerImage.contentMode = UIViewContentMode.ScaleAspectFit
            
            bannerImage.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
}



