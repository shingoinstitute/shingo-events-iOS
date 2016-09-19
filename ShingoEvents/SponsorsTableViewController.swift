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
    
    fileprivate func displayNoContentNotification() {
        let label: UILabel = {
            let view = UILabel.newAutoLayout()
            view.text = "No Content Available"
            view.textColor = .white
            view.sizeToFit()
            return view
        }()
        
        view.addSubview(label)
        
        label.autoAlignAxis(.horizontal, toSameAxisOf: view)
        label.autoAlignAxis(.vertical, toSameAxisOf: view)
    }
}

extension SponsorsTableViewController {
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
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

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.backgroundColor = SIColor.shingoGoldColor()
        header.text = sectionTitles[section]
        header.textColor = .white
        header.font = UIFont.boldSystemFont(ofSize: 16.0)
        header.textAlignment = .center
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SponsorCell", for: indexPath) as! SponsorTableViewCell
        
        switch sectionTitles[(indexPath as NSIndexPath).section] {
            case "Friends":
                if (friends.count > 0) {
                    cell.sponsor = friends[(indexPath as NSIndexPath).row]
                }
            case "Supporters":
                if (supporters.count > 0) {
                    cell.sponsor = supporters[(indexPath as NSIndexPath).row]
                }
            case "Benefactors":
                if (benefactors.count > 0) {
                    cell.sponsor = benefactors[(indexPath as NSIndexPath).row]
                }
            case "Champions":
                if (champions.count > 0) {
                    cell.sponsor = champions[(indexPath as NSIndexPath).row]
                }
            case "Presidents":
                if (presidents.count > 0) {
                    cell.sponsor = presidents[(indexPath as NSIndexPath).row]
                }
            case "Other":
                if other.count > 0 {
                    cell.sponsor = other[(indexPath as NSIndexPath).row]
                }
            default: break
        }
        
        cell.selectionStyle = .none
        cell.contentView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 150.0)
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
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
        let view = UILabel.newAutoLayout()
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.textAlignment = .center
        return view
    }()
    
    var logoImageView: UIImageView = {
        let image = UIImageView.newAutoLayout()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            contentView.addSubview(nameLabel)
            contentView.addSubview(logoImageView)
            
            NSLayoutConstraint.autoSetPriority(UILayoutPriorityRequired) {
                self.logoImageView.autoSetContentCompressionResistancePriority(for: .vertical)
            }
            
            nameLabel.sizeToFit()
            nameLabel.autoSetDimension(.height, toSize: 24)
            nameLabel.autoPinEdge(.top, to: .top, of: contentView, withOffset: 5)
            nameLabel.autoAlignAxis(.vertical, toSameAxisOf: contentView)
            
            logoImageView.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: 5)
            logoImageView.autoPinEdge(.left, to: .left, of: contentView, withOffset: 5)
            logoImageView.autoPinEdge(.right, to: .right, of: contentView, withOffset: -5)
            logoImageView.autoPinEdge(.bottom, to: .bottom, of: contentView, withOffset: -5)
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    fileprivate func updateCell() {
        if let sponsor = sponsor {
            nameLabel.text = sponsor.name
            sponsor.getLogoImage() { image in
                self.logoImageView.image = image
                self.setNeedsDisplay()
            }
        }
        
    }
}



