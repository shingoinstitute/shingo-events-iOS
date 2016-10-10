//
//  SponsorsTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 2/3/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import PureLayout

class SponsorsTableViewController: UITableViewController, SICellDelegate {

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
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func displayNoContentNotification() {
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
    
    func cellDidUpdate() {
        tableView.beginUpdates()
        tableView.endUpdates()
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
        header.backgroundColor = .shingoBlue
        header.text = sectionTitles[section]
        header.textColor = .white
        header.font = UIFont.preferredFont(forTextStyle: .headline)
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
        
        cell.delegate = self
        
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

}


class SponsorTableViewCell: UITableViewCell {
    
    var sponsor: SISponsor! {
        didSet {
            updateCell()
        }
    }
    
    var delegate: SICellDelegate?

    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.numberOfLines = 0
            nameLabel.lineBreakMode = .byWordWrapping
            nameLabel.textAlignment = .center
        }
    }
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    func updateCell() {
        if let sponsor = sponsor {
            nameLabel.text = sponsor.name
            
            sponsor.getLogoImage() { image in
                
                if image.size.width > self.contentView.frame.width {
                    let foobar = UIImageView()
                    foobar.image = image
                    foobar.resizeImageViewToIntrinsicContentSize(thatFitsWidth: self.contentView.frame.width)
                    if let image = foobar.image {
                        self.logoImageView.image = image
                    }
                } else {
                    self.logoImageView.image = image
                }
                
                if let d = self.delegate {
                    d.cellDidUpdate()
                }
                
            }
        }
        
    }
}



