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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    fileprivate func displayNoContentNotification() {
        let label: UILabel = {
            let view = UILabel.newAutoLayout()
            view.text = "This event does not have any exhibitors."
            view.textColor = .white
            view.sizeToFit()
            return view
        }()
        
        view.addSubview(label)
        label.autoAlignAxis(toSuperviewAxis: .horizontal)
        label.autoAlignAxis(toSuperviewAxis: .vertical)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ExhibitorInfoView" {
            let destination = segue.destination as! ExhibitorInfoViewController
            if let exhibitor = sender as? SIExhibitor {
                destination.exhibitor = exhibitor
            }
        }
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

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .shingoRed
        let header = UILabel()
        header.text = sectionInformation[section].0
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
        
        let cell: ExhibitorTableViewCell = ExhibitorTableViewCell()
        cell.exhibitor = sectionInformation[(indexPath as NSIndexPath).section].1[(indexPath as NSIndexPath).row]
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ExhibitorTableViewCell
        if let exhibitor = cell.exhibitor {
            performSegue(withIdentifier: "ExhibitorInfoView", sender: exhibitor)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 200.0
        } else {
            return 150
        }
    }


}


