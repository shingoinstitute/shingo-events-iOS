//
//  SessionInfoViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 2/11/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class SessionSpeakerCell: UITableViewCell {
    
    @IBOutlet weak var speakerNameLabel: UILabel!
    @IBOutlet weak var speakerImage: UIImageView!
    var speaker:Speaker!
    
}

class SessionInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var abstractTextField: UITextView!
    @IBOutlet weak var expandButton: UIButton!
    
    var session:EventSession!
    var speakers:[Speaker]!
    var dataToSend:Speaker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = session.name
        roomLabel.text = "Room " + session.room
        abstractTextField.text = session.abstract
        abstractTextField.scrollEnabled = false
        abstractTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        abstractTextField.layer.borderWidth = 1.0
        abstractTextField.layer.cornerRadius = 5.0
        
        expandButton.backgroundColor = UIColor(colorLiteralRed: 0.0/255.0, green: 47.0/255.0, blue: 86.0/255.0, alpha: 1.0)
        expandButton.setTitleColor(.whiteColor(), forState: UIControlState.Normal)
        expandButton.layer.cornerRadius = 3.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapExpandTf(sender: AnyObject) {
         self.performSegueWithIdentifier("showTextFieldPopover", sender: self)
    }

    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SessionSpeakerCell
        dataToSend = cell.speaker
        performSegueWithIdentifier("SpeakerDetails", sender: self)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (session?.speaker_ids.count)!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 117.0
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 117.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("SpeakerCell", forIndexPath: indexPath) as! SessionSpeakerCell
        
        let speaker_id = session?.speaker_ids[indexPath.row]
        for speaker in speakers! {
            if speaker.speaker_id == speaker_id! {
                cell.speakerNameLabel.text = speaker.display_name
                cell.speakerImage.image = speaker.image
                cell.speaker = speaker
            }
        }
        cell.speakerImage.layer.cornerRadius = 3.0
        return cell
        
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SpeakerDetails" {
            let dest_vc = segue.destinationViewController as! SpeakerDetailsViewController
            dest_vc.speaker = self.dataToSend
        }
        
        if segue.identifier == "showTextFieldPopover" {
            let destination = segue.destinationViewController as! SessionTextPopoverViewController
            destination.abstractText = abstractTextField.text
            let controller = destination.popoverPresentationController
            
            if controller != nil
            {
                controller?.delegate = self
            }
        }
    }

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }

}



