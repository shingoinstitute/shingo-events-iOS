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
    
    override func loadView() {
        super.loadView()
        
        let r = SIRecipient(name: "No Recipients", type: .None)
        
        if spRecipients.isEmpty {
            spRecipients.append(r)
        }
        
        if silverRecipients.isEmpty {
            silverRecipients.append(r)
        }

        if bronzeRecipients.isEmpty {
            bronzeRecipients.append(r)
        }
        
        if researchRecipients.isEmpty {
            researchRecipients.append(r)
        }
        
        if publicationRecipients.isEmpty {
            publicationRecipients.append(r)
        }
        
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

extension RecipientsTableViewController {
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            return spRecipients.count
        case 1:
            return silverRecipients.count
        case 2:
            return bronzeRecipients.count
        case 3:
            return researchRecipients.count
        case 4:
            return publicationRecipients.count
        default:
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecipientCell", forIndexPath: indexPath) as! RecipientTableViewCell
        switch indexPath.section {
            case 0:
                cell.recipient = spRecipients[indexPath.row]
            case 1:
                cell.recipient = silverRecipients[indexPath.row]
            case 2:
                cell.recipient = bronzeRecipients[indexPath.row]
            case 3:
                cell.recipient = researchRecipients[indexPath.row]
            case 4:
                cell.recipient = publicationRecipients[indexPath.row]
            default:
                cell.recipient = SIRecipient(name: "No Recipients", type: .None)
        }
        
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
                    self.performSegueWithIdentifier("PublicationInfoView", sender: recipient)
                default:
                    return
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }
//    6:50 - 8:40
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            if !spRecipients[indexPath.row].didLoadImage {
                return 42
            }
        case 1:
            if !silverRecipients[indexPath.row].didLoadImage {
                return 42
            }
        case 2:
            if !bronzeRecipients[indexPath.row].didLoadImage {
                return 42
            }
        case 3:
            if !researchRecipients[indexPath.row].didLoadImage {
                return 42
            }
        case 4:
            if !publicationRecipients[indexPath.row].didLoadImage {
                return 42
            }
        default:
            break
        }
        return 132
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = SIColor.shingoGoldColor()
        
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
        case 4:
            header.text = " Publication Award Recipients"
        default:
            header.text = ""
        }
        
        view.addSubview(header)
        
        header.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        return view
    }


}






