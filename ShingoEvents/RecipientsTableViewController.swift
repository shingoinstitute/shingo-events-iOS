//
//  RecipientsTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/26/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class RecipientsTableViewController: UITableViewController {

    var appData: AppData!
    var recipientToSend:Recipient!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numOfRows = 0
        if appData != nil {
            switch section {
            case 0:
                numOfRows = appData.shingoPrizeRecipients.count
            case 1:
                numOfRows = appData.silverRecipients.count
            case 2:
                numOfRows = appData.bronzeRecipients.count
            case 3:
                numOfRows = appData.researchRecipients.count
            default: break
                
            }
        }
        if numOfRows < 1 {
            return 1
        } else {
            return numOfRows
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecipientCell", forIndexPath: indexPath) as! RecipientTableViewCell
        switch indexPath.section {
        case 0:
            if !appData.shingoPrizeRecipients.isEmpty {
//                cell.recipientLabel!.text = appData.shingoPrizeRecipients[indexPath.row].name
                cell.recipient = appData.shingoPrizeRecipients[indexPath.row]
            }
        case 1:
            if !appData.silverRecipients.isEmpty {
//                cell.textLabel!.text = appData.silverRecipients[indexPath.row].name
                cell.recipient = appData.silverRecipients[indexPath.row]
            }
        case 2:
            if !appData.bronzeRecipients.isEmpty {
//                cell.textLabel!.text = appData.bronzeRecipients[indexPath.row].name
                cell.recipient = appData.bronzeRecipients[indexPath.row]
            }
        case 3:
            if !appData.researchRecipients.isEmpty {
//                cell.textLabel!.text = appData.researchRecipients[indexPath.row].name
                cell.recipient = appData.researchRecipients[indexPath.row]
            }
        default:
            let recipient = Recipient()
            recipient.name = "No Recipient"
            recipient.logo_book_cover_image = UIImage(named: "shingo_icon")
            cell.recipient = recipient
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! RecipientTableViewCell
        if cell.recipient != nil
        {
            recipientToSend = cell.recipient
            if recipientToSend.award_type == .Research
            {
                performSegueWithIdentifier("ResearchInfoView", sender: self)
            }
            else
            {
                performSegueWithIdentifier("ChallengerInfoView", sender: self)
            }
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
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
//        view.backgroundColor = .orangeColor()
        
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
            let dest_vc = segue.destinationViewController as! ChallengerInfoViewController
            dest_vc.navigationController?.topViewController?.title = recipientToSend.award
            dest_vc.recipient = recipientToSend
        }
        
        if segue.identifier == "ResearchInfoView" {
            let dest_vc = segue.destinationViewController as! ResearchInfoViewController
            dest_vc.recipient = recipientToSend
        }
        
    }


}






