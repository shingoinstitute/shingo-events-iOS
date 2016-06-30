//
//  RecipientsTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/26/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class RecipientsTableViewController: UITableViewController {

    var recipients : SIRecipients!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let recipients = recipients {
            switch section {
            case 0:
                if let recipients = recipients.shingoPrizeRecipients {
                    return recipients.count
                }
            case 1:
                if let recipients = recipients.silverRecipients {
                    return recipients.count
                }
            case 2:
                if let recipients = recipients.bronzeRecipients {
                    return recipients.count
                }
            case 3:
                if let recipients = recipients.researchRecipients {
                    return recipients.count
                }
            default: break
                
            }
        }
        
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecipientCell", forIndexPath: indexPath) as! RecipientTableViewCell
        switch indexPath.section {
        case 0:
            if let recipient = recipients.shingoPrizeRecipients {
                cell.recipient = recipient[indexPath.row]
            }
        case 1:
            if let recipient = recipients.silverRecipients {
                cell.recipient = recipient[indexPath.row]
            }
        case 2:
            if let recipient = recipients.bronzeRecipients {
                cell.recipient = recipient[indexPath.row]
            }
        case 3:
            if let recipient = recipients.researchRecipients {
                cell.recipient = recipient[indexPath.row]
            }
        default:
            let recipient = SIRecipient()
            recipient.name = "No Recipient"
            recipient.logoBookCoverImage = UIImage(named: "shingo_icon")
            cell.recipient = recipient
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as! RecipientTableViewCell
//        if let recipient = cell.recipient {
//            // Do something with recipient
//            tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        }
    }
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42.0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 132.0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(netHex: 0xcd8931)
        
        let header = UILabel()
        header.font = UIFont.boldSystemFontOfSize(18)
        header.textColor = .whiteColor()
        
        switch section {
        case 0:
            header.text = " Shingo Prize Recipients"
        case 1:
            header.text = " Silver Medallion Recipients"
        case 2:
            header.text = " Bronze Medallion Recipients"
        case 3:
            header.text = " Research Award Recipients"
        default:
            header.text = ""
        }
        
        view.addSubview(header)
        
        header.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        return view
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ChallengerInfoView" {
            let destination = segue.destinationViewController as! ChallengerInfoViewController
            if let recipient = sender as? SIRecipient {
                destination.navigationController?.topViewController?.title = recipient.name
                // Send something
            }
        }
        
        if segue.identifier == "ResearchInfoView" {
            let destination = segue.destinationViewController as! ResearchInfoViewController
            
            if let recipient = sender as? SIRecipient {
                destination.navigationController?.topViewController?.title = recipient.name
                // Send something
            }
            
        }
        
    }


}






