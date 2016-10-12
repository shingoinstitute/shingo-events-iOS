//
//  ExhibitorTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/27/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class ExhibitorTableViewController: UITableViewController {
    
    var sectionInformation = [(String, [SIExhibitor])]()
    
    var gradientBackgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = gradientBackgroundView
        gradientBackgroundView.backgroundColor = .lightShingoBlue
        
        let gradientLayer = RadialGradientLayer()
        gradientLayer.frame = gradientBackgroundView.bounds
        gradientBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150.0
        
        if sectionInformation.isEmpty {
            displayNoContentNotification()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    private func displayNoContentNotification() {
        let label: UILabel = {
            let view = UILabel.newAutoLayout()
            view.text = "Content Currently Unavailable."
            view.textColor = .white
            view.sizeToFit()
            return view
        }()
        
        view.addSubview(label)
        label.autoAlignAxis(toSuperviewAxis: .horizontal)
        label.autoAlignAxis(toSuperviewAxis: .vertical)
    }
    
}

extension ExhibitorTableViewController {
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionInformation.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionInformation[section].1.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExhibitorCell") as! ExhibitorTableViewCell
        
        cell.entity = sectionInformation[indexPath.section].1[indexPath.row]
        
        cell.isExpanded = cell.entity.isSelected
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ExhibitorTableViewCell
        
        cell.isExpanded = !cell.isExpanded
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel(text: "\t\(sectionInformation[section].0)", font: UIFont.preferredFont(forTextStyle: .headline))
        header.textColor = .white
        header.backgroundColor = .shingoRed
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    

}


