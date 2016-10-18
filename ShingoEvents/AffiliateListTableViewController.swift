//
//  AffiliateListTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 2/1/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class AffiliateListTableViewController: UITableViewController {

    var affiliateSections: [(String, [SIAffiliate])]!
    
    lazy var sectionHeaders: [String] = {
        var headers = [String]()
        for section in self.affiliateSections {
            headers.append(section.0)
        }
        return headers
    }()
    
    lazy var affiliateDataSource: [[SIAffiliate]] = {
        var sections = [[SIAffiliate]]()
        for section in self.affiliateSections {
            sections.append(section.1)
        }
        return sections
    }()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        for section in self.affiliateSections {
            for affiliate in section.1 {
                affiliate.isSelected = false
            }
        }
    }
    
    var gradientBackgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = gradientBackgroundView
        gradientBackgroundView.backgroundColor = .lightShingoBlue
        
        let gradientLayer = RadialGradientLayer()
        gradientLayer.frame = gradientBackgroundView.bounds
        gradientBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
        
        tableView.estimatedRowHeight = 186
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
    
}

extension AffiliateListTableViewController {
    
    // MARK: - TableView data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return affiliateSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return affiliateDataSource[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AffiliateCell", for: indexPath) as! AffiliateTableViewCell
        
        cell.entity = affiliateDataSource[indexPath.section][indexPath.row]
        
        cell.isExpanded = affiliateDataSource[indexPath.section][indexPath.row].isSelected
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AffiliateTableViewCell
        
        cell.isExpanded = !cell.isExpanded
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel(text: "\t\(sectionHeaders[section].uppercased())", font: UIFont.preferredFont(forTextStyle: .headline))
        header.textColor = .white
        header.backgroundColor = .shingoRed
        return header
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
}



