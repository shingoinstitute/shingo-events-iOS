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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ChallengerInfoView" {
            let destination = segue.destinationViewController as! ChallengerInfoViewController
            if let recipient = sender as? SIRecipient {
                destination.navigationController?.topViewController?.title = recipient.name
                destination.recipient = recipient
                // Send something
            }
        }
        
        if segue.identifier == "ResearchInfoView" {
            let destination = segue.destinationViewController as! ResearchInfoViewController
            
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
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecipientCell", forIndexPath: indexPath) as! RecipientTableViewCell
        cell.recipient = dataSource[indexPath.section][indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! RecipientTableViewCell
        
        if let recipient = cell.recipient {
            switch recipient.awardType {
                case .ShingoPrize,
                     .Silver,
                     .Bronze:
                    self.performSegueWithIdentifier("ChallengerInfoView", sender: recipient)
                case .Research:
                    self.performSegueWithIdentifier("ResearchInfoView", sender: recipient)
                case .Publication:
                    // Might change segue later to be a screen customized to publication recipients
                    self.performSegueWithIdentifier("ResearchInfoView", sender: recipient)
                default:
                    return
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = SIColor.shingoGoldColor()
        
        let header = UILabel()
        header.font = UIFont.boldSystemFontOfSize(18)
        header.textColor = .whiteColor()
        
        header.text = "\(dataSource[section][0].awardType.rawValue) Recipients"
        
        view.addSubview(header)
        
        header.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        return view
    }


}






