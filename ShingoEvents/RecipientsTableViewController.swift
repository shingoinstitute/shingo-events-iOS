//
//  RecipientsTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/26/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit



class RecipientsTableViewController: UITableViewController {

    var spRecipients: [SIRecipient]!
    var silverRecipients: [SIRecipient]!
    var bronzeRecipients: [SIRecipient]!
    var researchRecipients: [SIRecipient]!
    var publicationRecipients: [SIRecipient]!
    
    lazy var recipients: [[SIRecipient]] = [
        self.spRecipients,
        self.silverRecipients,
        self.bronzeRecipients,
        self.researchRecipients,
        self.publicationRecipients
    ]
    
    var dataSource: [[SIRecipient]] {
        get {
            var value = [[SIRecipient]]()
            for r in recipients {
                if !r.isEmpty {
                    value.append(r)
                }
            }
            return value
        }
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
}

extension RecipientsTableViewController {
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipientCell", for: indexPath) as! RecipientTableViewCell
        
        cell.entity = dataSource[indexPath.section][indexPath.row]
        
        cell.isExpanded = cell.entity.isSelected
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! RecipientTableViewCell

        cell.isExpanded = !cell.isExpanded
        
        tableView.beginUpdates()
        tableView.endUpdates()

    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel(text: "\(dataSource[section][0].awardType.rawValue) Recipients", font: UIFont.preferredFont(forTextStyle: .headline))
        header.textColor = .white
        header.textAlignment = .center
        header.backgroundColor = .shingoRed
        
        return header
    }


}






