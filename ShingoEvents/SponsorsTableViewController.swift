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
    var other: [SISponsor]!
    
    var sectionTitles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if friends.isEmpty && supporters.isEmpty && benefactors.isEmpty && champions.isEmpty && presidents.isEmpty && other.isEmpty {
            displayNoContentNotification()
        }
    }
    
    private func displayNoContentNotification() {
        let label: UILabel = {
            let view = UILabel.newAutoLayoutView()
            view.text = "No Content Available"
            view.textColor = .whiteColor()
            view.sizeToFit()
            return view
        }()
        
        view.addSubview(label)
        
        label.autoAlignAxis(.Horizontal, toSameAxisOfView: view)
        label.autoAlignAxis(.Vertical, toSameAxisOfView: view)
    }
}

extension SponsorsTableViewController {
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        sectionTitles = []
        
        if presidents.count > 0 {
            sectionTitles.append("Presidents")
        }
        if champions.count > 0 {
            sectionTitles.append("Champions")
        }
        if benefactors.count > 0 {
            sectionTitles.append("Benefactors")
        }
        if supporters.count > 0 {
            sectionTitles.append("Supporters")
        }
        if friends.count > 0 {
            sectionTitles.append("Friends")
        }
        if other.count > 0 {
            sectionTitles.append("Other")
        }

        return sectionTitles.count
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.backgroundColor = SIColor.shingoGoldColor()
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
        
        switch sectionTitles[section] {
        case "Presidents": return presidents.count
        case "Champions": return champions.count
        case "Benefactors": return benefactors.count
        case "Supporters": return supporters.count
        case "Friends": return friends.count
        case "Other": return other.count
        default:
            print("Error: Invalid section title detected in SponsorsTableViewController.")
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SponsorCell", forIndexPath: indexPath) as! SponsorTableViewCell
        
        switch sectionTitles[indexPath.section] {
            case "Friends":
                if (friends.count > 0) {
                    cell.sponsor = friends[indexPath.row]
                }
            case "Supporters":
                if (supporters.count > 0) {
                    cell.sponsor = supporters[indexPath.row]
                }
            case "Benefactors":
                if (benefactors.count > 0) {
                    cell.sponsor = benefactors[indexPath.row]
                }
            case "Champions":
                if (champions.count > 0) {
                    cell.sponsor = champions[indexPath.row]
                }
            case "Presidents":
                if (presidents.count > 0) {
                    cell.sponsor = presidents[indexPath.row]
                }
            case "Other":
                if other.count > 0 {
                    cell.sponsor = other[indexPath.row]
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


class SponsorTableViewCell: UITableViewCell {
    
    var sponsor: SISponsor! {
        didSet {
            updateCell()
        }
    }
    
    var didSetupConstraints = false

    var nameLabel: UILabel = {
        let view = UILabel.newAutoLayoutView()
        view.numberOfLines = 0
        view.lineBreakMode = .ByWordWrapping
        view.textAlignment = .Center
        return view
    }()
    
    var logoImageView: UIImageView = {
        let image = UIImageView.newAutoLayoutView()
        image.contentMode = .ScaleAspectFit
        return image
    }()
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            contentView.addSubview(nameLabel)
            contentView.addSubview(logoImageView)
            
            NSLayoutConstraint.autoSetPriority(UILayoutPriorityRequired) {
                self.logoImageView.autoSetContentCompressionResistancePriorityForAxis(.Vertical)
            }
            
            nameLabel.sizeToFit()
            nameLabel.autoSetDimension(.Height, toSize: 24)
            nameLabel.autoPinEdge(.Top, toEdge: .Top, ofView: contentView, withOffset: 5)
            nameLabel.autoAlignAxis(.Vertical, toSameAxisOfView: contentView)
            
            logoImageView.autoPinEdge(.Top, toEdge: .Bottom, ofView: nameLabel, withOffset: 5)
            logoImageView.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 5)
            logoImageView.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -5)
            logoImageView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: contentView, withOffset: -5)
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    private func updateCell() {
        if let sponsor = sponsor {
            nameLabel.text = sponsor.name
            sponsor.getLogoImage() { image in
                self.logoImageView.image = image
                self.setNeedsDisplay()
            }
        }
        
    }
}



