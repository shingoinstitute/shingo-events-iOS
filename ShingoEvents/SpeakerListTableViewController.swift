//
//  SpeakerListTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/22/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class SpeakerListCell: UITableViewCell
{
    
    var speaker:Speaker? = nil
    
    @IBOutlet weak var speakerNameLabel: UILabel!
    @IBOutlet weak var speakerImage: UIImageView!
    
}



class SpeakerListTableViewController: UITableViewController
{

    var speakers:[Speaker]? = nil
    var dataToSend:Speaker? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    

    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SpeakerListCell
        if cell.speaker != nil
        {
            dataToSend = cell.speaker
            performSegueWithIdentifier("SpeakerDetails", sender: self)
        }
 
    }
    
    
    // MARK: - Table view data source

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section
        {
        case 0:
            return speakers!.count
        case 1:
            return 0
        default:
            return 0
        }
    }
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("SpeakerListCell", forIndexPath: indexPath) as! SpeakerListCell
        cell.speakerNameLabel.text = speakers![indexPath.row].display_name
        cell.speaker = speakers![indexPath.row]
        if cell.speaker?.image != nil {
            cell.speakerImage.image = cell.speaker?.image
            cell.speakerImage.layer.cornerRadius = 5.0
            cell.speakerImage.layer.borderColor = UIColor.blackColor().CGColor
        }

        return cell
    }




    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "SpeakerDetails"
        {
            let dest_vc = segue.destinationViewController as! SpeakerDetailsViewController
            dest_vc.speaker = self.dataToSend
        }
    }


}
