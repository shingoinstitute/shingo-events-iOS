//
//  SpeakerListTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/22/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class SpeakerListCell: UITableViewCell {
    
    var speaker: SISpeaker!
    @IBOutlet weak var speakerNameLabel: UILabel!
    @IBOutlet weak var speakerImage: UIImageView!
    
    func updateCellProperties(speaker: SISpeaker) {
        self.speaker = speaker
        speakerNameLabel.text = speaker.name
        speakerImage.image = speaker.getSpeakerImage()
    }
    
}


class SpeakerListTableViewController: UITableViewController {

    var speakers: [SISpeaker]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SpeakerListCell
        if let speaker = cell.speaker {
            performSegueWithIdentifier("SpeakerDetails", sender: speaker)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return speakers.count
        case 1:
            return 0
        default:
            return 0
        }
    }
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SpeakerListCell", forIndexPath: indexPath) as! SpeakerListCell
        let speaker = speakers[indexPath.row]
        cell.updateCellProperties(speaker)

        return cell
    }




    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SpeakerDetails" {
            let destination = segue.destinationViewController as! SpeakerDetailsViewController
            if let speaker = sender as? SISpeaker {
                destination.speaker = speaker
            }
        }
    }

}







