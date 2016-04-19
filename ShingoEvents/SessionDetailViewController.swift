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
        label.font = UIFont.boldSystemFontOfSize(20.0)
        label.textColor = .whiteColor()
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.lineBreakMode = .ByWordWrapping
        return label
    }()
    
    var roomLabel:UILabel = {
        let label = UILabel.newAutoLayoutView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.backgroundColor = UIColor.clearColor()
        label.textColor = .whiteColor()
        return label
    }()
    
    var summaryLabel:UILabel = {
        let label = UILabel.newAutoLayoutView()
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.Center
        let attributes = [NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue,
                          NSParagraphStyleAttributeName : style]
        let attrText = NSAttributedString(string: "Summary", attributes: attributes)
        label.attributedText = attrText
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .Center
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
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
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
        
        scrollView.backgroundColor = ShingoColors().shingoRed
        tableView.backgroundColor = ShingoColors().shingoRed
        
        // Load data
        titleLabel.text = session.name
        roomLabel.text = "Location: " + session.room
        
        if session.abstract == "" || session.abstract == "null" || session.richAbstract == "" || session.richAbstract == "null"
        {
            textField.text = "Session details coming soon."
        }
        else if session.richAbstract != nil
        {

            do {
                let htmlString = "<!DOCTYPE html><html><body><font size=\"5\">" + session.richAbstract! + "</font></body></html>"
                let attrString = try NSAttributedString(data: htmlString.dataUsingEncoding(NSUTF8StringEncoding)!,
                                                        options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                                                    NSCharacterEncodingDocumentAttribute : NSUTF8StringEncoding],
                                                        documentAttributes: nil)
                textField.attributedText = attrString
            } catch {
                print("Error with richAbstract in SessionDetailViewController")
            }
            
        }
        else
        {
            textField.text = session.abstract
        }
        
//        }
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

        scrollView.autoSetDimensionsToSize(CGSize(width: self.view.frame.width, height: self.view.frame.height))
//        scrollView.sizeToFit()
        scrollView.autoPinEdgesToSuperviewEdges()
        
        contentView.autoPinEdgeToSuperviewEdge(.Top)
        contentView.autoPinEdgeToSuperviewEdge(.Left)
        contentView.autoSetDimension(.Width, toSize: view.frame.width)
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
        
//        titleLabel.autoSetDimension(.Width, toSize: view.frame.width)
        titleLabel.autoPinEdge(.Top, toEdge: .Top, ofView: contentView, withOffset: 8.0)
        titleLabel.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 8.0)
        titleLabel.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -8.0)
        
//        roomLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 42)
        roomLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel, withOffset: 8.0)
        roomLabel.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 8.0)
        roomLabel.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -8.0)
        
//        summaryLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 42)
        summaryLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: roomLabel, withOffset: 8.0)
        summaryLabel.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: 8.0)
        summaryLabel.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: -8.0)
        
        
        textField.sizeToFit()
        textField.layoutIfNeeded()
        textField.autoSetDimension(.Width, toSize: view.frame.width)
        textField.autoPinEdge(.Left, toEdge: .Left, ofView: view, withOffset: 0)
        textField.autoPinEdge(.Right, toEdge: .Right, ofView: view, withOffset: 0)
        textField.autoPinEdge(.Top, toEdge: .Bottom, ofView: summaryLabel, withOffset: 0)
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
