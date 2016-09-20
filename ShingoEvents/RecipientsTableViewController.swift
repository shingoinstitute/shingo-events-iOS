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
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ChallengerInfoView" {
            let destination = segue.destination as! ChallengerInfoViewController
            if let recipient = sender as? SIRecipient {
                destination.navigationController?.topViewController?.title = recipient.name
                destination.recipient = recipient
                // Send something
            }
        }
        
        if segue.identifier == "ResearchInfoView" {
            let destination = segue.destination as! ResearchInfoViewController
            
            if let recipient = sender as? SIRecipient {
                destination.navigationController?.topViewController?.title = recipient.name
                destination.recipient = recipient
                // Send something
            }
            
        }
        
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
        cell.recipient = dataSource[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! RecipientTableViewCell
        
        if let recipient = cell.recipient {
            switch recipient.awardType {
                case .ShingoPrize,
                     .Silver,
                     .Bronze:
                    self.performSegue(withIdentifier: "ChallengerInfoView", sender: recipient)
                case .Research:
                    self.performSegue(withIdentifier: "ResearchInfoView", sender: recipient)
                case .Publication:
                    // Might change segue later to be a screen customized to publication recipients
                    self.performSegue(withIdentifier: "ResearchInfoView", sender: recipient)
                default:
                    return
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = SIColor.shingoRed()
        
        let header = UILabel()
        header.font = UIFont.boldSystemFont(ofSize: 18)
        header.textColor = .white
        
        header.text = "\(dataSource[section][0].awardType.rawValue) Recipients"
        
        view.addSubview(header)
        
        header.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        return view
    }


}






