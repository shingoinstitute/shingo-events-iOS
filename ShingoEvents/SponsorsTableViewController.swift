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
    
    var friends:[Sponsor]!
    var supporters:[Sponsor]!
    var benefactors:[Sponsor]!
    var champions:[Sponsor]!
    var presidents:[Sponsor]!
    
    var sectionTitles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(SponsorTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150.0
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }

    func contentSizeCategoryChanged(notification: NSNotification) {
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var numSections = 0
        if presidents.count > 0 {
            numSections++
            sectionTitles.append("Presidents")
        }
        if champions.count > 0 {
            numSections++
            sectionTitles.append("Champions")
        }
        if benefactors.count > 0 {
            numSections++
            sectionTitles.append("Benefactors")
        }
        if supporters.count > 0 {
            numSections++
            sectionTitles.append("Supporters")
        }
        if friends.count > 0 {
            numSections++
            sectionTitles.append("Friends")
        }

        return numSections
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let title = sectionTitles[section]
        
        if title == "President" {
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
        let cell = tableView.dequeueReusableCellWithIdentifier("SponsorCell", forIndexPath: indexPath) as! SponsorTableViewCell

        switch sectionTitles[indexPath.section] {
        case "Friends":
            if (friends?.count > 0) {
                cell.bannerImage.image = friends[indexPath.row].banner_image
                cell.sponsor = friends[indexPath.row]
            }
        case "Supporters":
            if (supporters?.count > 0) {
                cell.bannerImage.image = supporters[indexPath.row].banner_image
                cell.sponsor = supporters[indexPath.row]
            }
        case "Benefactors":
            if (benefactors?.count > 0) {
                cell.bannerImage.image = benefactors[indexPath.row].banner_image
                cell.sponsor = benefactors[indexPath.row]
            }
        case "Champions":
            if (champions?.count > 0) {
                cell.bannerImage.image = champions[indexPath.row].banner_image
                cell.sponsor = champions[indexPath.row]
            }
        case "Presidents":
            if (presidents?.count > 0) {
                cell.bannerImage.image = presidents[indexPath.row].banner_image
                cell.sponsor = presidents[indexPath.row]
            }
        default: break
        }
        cell.selectionStyle = .None
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }


    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        switch sectionTitles[indexPath.section] {
        case "Friends":
            if friends!.count > 0 {
                if let image = friends[indexPath.row].banner_image {
                    return image.size.height as CGFloat
                }
            }
        case "Supporters":
            if supporters!.count > 0 {
                return 351.0
            }
        case "Benefactors":
            if benefactors!.count > 0 {
                return 351.0
            }
        case "Champions":
            if champions!.count > 0 {
                return 351.0
            }
        case "Presidents":
            if presidents?.count > 0 {
                return 351.0
            }
        default:
            return 44.0
        }
        return 150.0
    }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150.0
    }

}

class SponsorTableViewCell:UITableViewCell {
    
    var sponsor:Sponsor!
    
    let horizontalInsets:CGFloat = 15.0
    let verticalInsets:CGFloat = 10.0
    
    var didSetupConstraints = false

    var bannerImage:UIImageView = UIImageView.newAutoLayoutView()
    var testView:UIView = UIView.newAutoLayoutView()
    
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
//        testView.addSubview(bannerImage)
        contentView.addSubview(bannerImage)
    }
    
    override func updateConstraints() {
        if !didSetupConstraints
        {
            NSLayoutConstraint.autoSetPriority(UILayoutPriorityRequired) {
                self.bannerImage.autoSetContentCompressionResistancePriorityForAxis(.Vertical)
            }
            
            if sponsor.sponsor_type == .Friend {
                if let image = self.sponsor.logo_image {
                    bannerImage.image = image
                } else {
                    bannerImage.image = UIImage(named: "100x100PL")
                }
            } else {
                if let image = self.sponsor.banner_image {
                    bannerImage.image = image
                } else {
                    bannerImage.image = UIImage(named: "600x100PL")
                }
            }
            
//            bannerImage.autoSetDimensionsToSize(CGSize(width: contentView.frame.width, height: contentView.frame.height + 20.0))
            bannerImage.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets.init(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0))

            didSetupConstraints = true
        }
        super.updateConstraints()
    }
}




















