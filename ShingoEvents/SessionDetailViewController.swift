//
//  SessionDetailViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/1/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import PureLayout

class SessionSpeakerCell: UITableViewCell {
    
    @IBOutlet weak var speakerNameLabel: UILabel!
    @IBOutlet weak var speakerImage: UIImageView!
    var speaker:Speaker!
    
}

class SessionDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var session:EventSession!
    var speakers:[Speaker]!
    var dataToSend:Speaker!
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Custom UIViews
    var titleLabel:UILabel = {
        let label = UILabel.newAutoLayoutView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clearColor()
        label.textColor = .whiteColor()
        label.numberOfLines = 2
        label.lineBreakMode = .ByWordWrapping
        return label
    }()
    
    var roomLabel:UILabel = {
        let label = UILabel.newAutoLayoutView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 2
        label.backgroundColor = UIColor.clearColor()
        label.textColor = .whiteColor()
        return label
    }()
    
    var summaryLabel:UILabel = {
        let label = UILabel.newAutoLayoutView()
        label.text = "Summary:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .whiteColor()
        label.backgroundColor = .clearColor()
        return label
    }()
    
    var textField:UITextView = {
        let view = UITextView.newAutoLayoutView()
        view.backgroundColor = .whiteColor()
        view.editable = true
        view.font = UIFont.systemFontOfSize(15)
        view.editable = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var contentView:UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = UIColor(colorLiteralRed: 0.0/255.0, green: 47.0/255.0, blue: 86.0/255.0, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var scrollView:UIScrollView = {
        let view = UIScrollView.newAutoLayoutView()
        view.backgroundColor = .whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var didSetupConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.removeFromSuperview() // remove tableView before re-adding it
        
        // Load data
        titleLabel.text = session.name
        roomLabel.text = "Location: " + session.room
        
        if session.abstract == "" || session.abstract == "null"
        {
            textField.text = "Session details coming soon."
        }
        else
        {
            textField.text = session.abstract
        }
        textField.scrollEnabled = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(roomLabel)
        contentView.addSubview(summaryLabel)
        contentView.addSubview(textField)
        scrollView.addSubview(contentView)
        if session.speaker_ids.count > 0 {
            scrollView.addSubview(tableView)
        }
        view.addSubview(scrollView)

        scrollView.autoSetDimensionsToSize(CGSize(width: view.frame.width, height: view.frame.height))
        scrollView.autoPinEdgesToSuperviewEdges()
        
        contentView.autoPinEdgeToSuperviewEdge(.Top)
        contentView.autoPinEdgeToSuperviewEdge(.Left)
        contentView.autoPinEdgeToSuperviewEdge(.Right)
        
        if session.speaker_ids.count != 0
        {
            tableView.autoPinEdge(.Top, toEdge: .Bottom, ofView: contentView)
            tableView.autoPinEdgeToSuperviewEdge(.Left)
            tableView.autoPinEdgeToSuperviewEdge(.Right)
            tableView.autoPinEdgeToSuperviewEdge(.Bottom)
        }
        else
        {
            contentView.autoPinEdgeToSuperviewEdge(.Bottom)
        }
        
        titleLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width - 16, height: 42)
        titleLabel.autoSetDimension(.Height, toSize: titleLabel.frame.height)
        titleLabel.autoPinEdge(.Top, toEdge: .Top, ofView: contentView, withOffset: 8.0)
        titleLabel.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: 8.0)
        titleLabel.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 8.0)
        
        roomLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 35)
        roomLabel.autoSetDimension(.Height, toSize: 35.0)
        roomLabel.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 8.0)
        roomLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel, withOffset: 8.0)
        
        summaryLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 21)
        summaryLabel.autoSetDimension(.Height, toSize: 21)
        summaryLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: roomLabel, withOffset: 8.0)
        summaryLabel.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 8.0)
        
        
        textField.sizeToFit()
        textField.layoutIfNeeded()
        textField.autoSetDimension(.Width, toSize: view.frame.width)
        textField.autoPinEdgeToSuperviewEdge(.Left)
        textField.autoPinEdgeToSuperviewEdge(.Right)
        textField.autoPinEdge(.Top, toEdge: .Bottom, ofView: summaryLabel, withOffset: 8.0)
        textField.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: contentView, withOffset: 0.0)
        
        if session.speaker_ids.count > 0
        {
            let tableViewCellHeight:CGFloat = 117.0
            let tableViewHeight:CGFloat = CGFloat(tableView.contentSize.height) + (CGFloat(tableViewCellHeight) * CGFloat(session.speaker_ids.count))
            tableView.autoSetDimension(.Height, toSize: tableViewHeight)
            tableView.autoPinEdge(.Top, toEdge: .Bottom, ofView: contentView, withOffset: 0.0)
            tableView.autoPinEdgeToSuperviewEdge(.Left)
            tableView.autoPinEdgeToSuperviewEdge(.Right)
        }
    }
    
    
    // Mark: - TableView data
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SessionSpeakerCell
        dataToSend = cell.speaker
        performSegueWithIdentifier("SpeakerDetailsView", sender: self)
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
        
        if segue.identifier == "SpeakerDetailsView" {
            let dest_vc = segue.destinationViewController as! SpeakerDetailsViewController
            dest_vc.speaker = self.dataToSend
        }
    }
    

}
