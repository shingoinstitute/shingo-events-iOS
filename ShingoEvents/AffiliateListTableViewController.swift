//
//  AffiliateListTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 2/1/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class AffiliateListTableViewController: UITableViewController {

    var affiliateSections:[(String, [SIAffiliate])]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 117
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if affiliateSections.isEmpty {
            let notification = UILabel.newAutoLayout()
            view.addSubview(notification)
            notification.autoPinEdge(.top, to: .top, of: view, withOffset: 50)
            notification.autoAlignAxis(toSuperviewAxis: .vertical)
            notification.text = "Content Not Available"
            notification.textColor = UIColor.white
            notification.sizeToFit()
        }
        
    }
    
    // MARK: - User interaction
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AffiliateTableViewCell
        if let affiliate = cell.affiliate {
            performSegue(withIdentifier: "AffiliateView", sender: affiliate)
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if affiliateSections != nil {
            return affiliateSections.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if affiliateSections != nil {
            return affiliateSections[section].1.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = SIColor.shingoRed()
        let header = UILabel()
        header.text = String(affiliateSections[section].0).uppercased()
        header.textColor = .white
        header.font = UIFont.boldSystemFont(ofSize: 16.0)
        header.backgroundColor = .clear
        
        view.addSubview(header)
        header.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0))
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("AffiliateCell", forIndexPath: indexPath) as! AffiliateTableViewCell
        let cell = AffiliateTableViewCell()
        
        cell.affiliate = affiliateSections[(indexPath as NSIndexPath).section].1[(indexPath as NSIndexPath).row]
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        return cell
    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AffiliateView" {
            let destination = segue.destination as! AfilliateViewController
            if let affiliate = sender as? SIAffiliate {
                destination.affiliate = affiliate
            }
        }
    }


}


open class AffiliateTableViewCell: UITableViewCell {
    
    var logoImage:UIImageView = {
        let view = UIImageView.newAutoLayout()
        view.contentMode = .scaleAspectFit
        return view
    }()
    var nameLabel:UILabel = {
        let view = UILabel.newAutoLayout()
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    
    var affiliate: SIAffiliate! {
        didSet {
            updateCell()
        }
    }
    
    var didSetupConstraints = false
    
    override open func updateConstraints() {
        if !didSetupConstraints {

            contentView.addSubview(logoImage)
            contentView.addSubview(nameLabel)
            
            NSLayoutConstraint.autoSetPriority(UILayoutPriorityRequired) {
                self.logoImage.autoSetContentCompressionResistancePriority(for: .vertical)
            }
            
            logoImage.autoSetDimension(.width, toSize: contentView.frame.width * 0.33)
            logoImage.autoAlignAxis(.horizontal, toSameAxisOf: contentView, withOffset: 0)
            logoImage.autoPinEdge(.left, to: .left, of: contentView, withOffset: 8.0)
            
            nameLabel.autoSetDimension(.height, toSize: 42.0)
            nameLabel.autoAlignAxis(.horizontal, toSameAxisOf: contentView)
            nameLabel.autoPinEdge(.left, to: .right, of: logoImage, withOffset: 8.0)
            nameLabel.autoPinEdge(.right, to: .right, of: contentView, withOffset: -8.0)
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    fileprivate func updateCell() {
        
        accessoryType = .disclosureIndicator
        
        if let affiliate = affiliate {
            affiliate.getLogoImage() { image in
                self.logoImage.image = image
            }
            
            nameLabel.text = affiliate.name
        }
    }
}
