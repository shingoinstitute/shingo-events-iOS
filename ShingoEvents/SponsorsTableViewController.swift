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

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.backgroundColor = UIColor(red: 204/255.0, green: 150/255.0, blue:73/255.0, alpha: 1.0)
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
        contentView.addSubview(bannerImage)
    }
    
    override func updateConstraints() {
        if !didSetupConstraints
        {
            NSLayoutConstraint.autoSetPriority(UILayoutPriorityRequired) {
                self.bannerImage.autoSetContentCompressionResistancePriorityForAxis(.Vertical)
            }

            if let image = self.sponsor.banner_image {
                bannerImage.image = image
            } else if let image = self.sponsor.logo_image {
                bannerImage.image = image
            } else {
                bannerImage.image = UIImage(named: "logoComingSoon")
            }
            
            let cellInsets:CGFloat = 10.0
            let cellHeight:CGFloat = 150.0
            print(bannerImage.image?.size.width)
            var width:CGFloat = (bannerImage.image?.size.width)!
            var height:CGFloat = (bannerImage.image?.size.height)!
            let aspectRatio:CGFloat = height / width
            
            if bannerImage.image?.size.width > contentView.frame.width {
                width = contentView.frame.width
                height = width * aspectRatio
            }
            
            if bannerImage.image?.size.height > 150 - (cellInsets * 2.0) {
                height = cellHeight - (cellInsets * 2.0)
                width = height / aspectRatio
            }
            
            bannerImage.autoSetDimensionsToSize(CGSize(width: width, height: height))
            bannerImage.autoAlignAxis(.Horizontal, toSameAxisOfView: contentView)
            bannerImage.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 8.0)
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
}




















