//
//  AffiliateListTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 2/1/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

public class AffiliateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var affiliate:Affiliate? = nil
    
}

class AffiliateListTableViewController: UITableViewController {

    var affiliates:[Affiliate]? = nil
    var dataToSend:Affiliate? = nil
    
    let cellHeight:CGFloat = 117.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - User interaction
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! AffiliateTableViewCell
        dataToSend = cell.affiliate
        performSegueWithIdentifier("AffiliateView", sender: self)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if affiliates != nil {
            return (affiliates?.count)!
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AffiliateCell", forIndexPath: indexPath) as! AffiliateTableViewCell
        
        if affiliates![indexPath.row].logo_image != nil {
            cell.logoImage.image = affiliates![indexPath.row].logo_image
            if cell.logoImage.frame.height > self.cellHeight
            {
                cell.logoImage.frame = CGRect(x: 0, y: 0, width: cellHeight, height: cellHeight)
            }
        }
        if affiliates![indexPath.row].name != nil {
            cell.nameLabel.text = affiliates![indexPath.row].name
        }
        cell.affiliate = affiliates![indexPath.row]
        return cell
    }




    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AffiliateView" {
            let destination = segue.destinationViewController as! AfilliateViewController
            destination.affiliate = self.dataToSend
        }
    }


}
