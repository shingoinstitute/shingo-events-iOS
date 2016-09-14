//
//  SpeakerListTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/22/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class SpeakerListTableViewController: UITableViewController {

    var keyNoteSpeakers: [SISpeaker]!
    var concurrentSpeakers: [SISpeaker]!
    var unknownSpeakers: [SISpeaker]!
    
    lazy var speakerList: [[SISpeaker]!] = [
        self.keyNoteSpeakers,
        self.concurrentSpeakers,
        self.unknownSpeakers
    ]
    
    var dataSource: [[SISpeaker]!] {
        get {
            var value = [[SISpeaker]!]()
            for speakers in speakerList {
                if speakers == nil { continue }
                if !speakers.isEmpty { value.append(speakers) }
            }
            return value
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SpeakerListCell
        if let speaker = cell.speaker {
            performSegueWithIdentifier("SpeakerDetails", sender: speaker)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SpeakerListCell
        if let speaker = cell.speaker {
            performSegueWithIdentifier("SpeakerDetails", sender: speaker)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SpeakerListCell", forIndexPath: indexPath) as! SpeakerListCell
        
        cell.aiv.hidesWhenStopped = true

        cell.speaker = dataSource[indexPath.section][indexPath.row]
        
        if cell.speakerImage.image == nil {
            cell.aiv.startAnimating()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UILabel(text: "", font: UIFont(name: "Helvetica", size: 12))
        header.textColor = .whiteColor()
        
        header.text = "  \(dataSource[section][0].speakerType.rawValue) Speakers"
        
        return header
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if dataSource[section].isEmpty { return 0 }
        
        return 32
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


class SpeakerListCell: UITableViewCell {

    @IBOutlet weak var speakerNameLabel: UILabel!
    @IBOutlet weak var speakerImage: UIImageView!
    @IBOutlet weak var aiv: UIActivityIndicatorView!
    
    var speaker: SISpeaker! {
        didSet {
            updateCell()
        }
    }
    
    func updateCell() {
        speakerNameLabel.text = speaker.name
        speaker.getSpeakerImage() { image in
            self.aiv.stopAnimating()
            self.speakerImage.image = image
        }
    }
    
}





