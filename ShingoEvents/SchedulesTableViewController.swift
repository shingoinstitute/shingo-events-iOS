//
//  SchedulesTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/14/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class SchedulesTableViewController: UITableViewController, SISpeakerDelegate {

    var agendas: [SIAgenda]!
    var eventName: String!

    var cellShouldExpand: [[Bool]] {
        get {
            var agendaSource = [[Bool]]()
            for agenda in self.agendas {
                var sessionSource = [Bool]()
                for session in agenda.sessions {
                    sessionSource.append(session.isSelected)
                }
                agendaSource.append(sessionSource)
            }
            return agendaSource
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Schedule"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 106
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = SIColor.prussianBlueColor()
        
        for agenda in agendas {
            if !agenda.didLoadSessions {
                agenda.requestAgendaSessions({
                    if let sessions = self.sortSessionsByDate(agenda.sessions) {
                        agenda.sessions = sessions
                        
                        for session in sessions {
                            if !session.didLoadSessionInformation {
                                session.requestSessionInformation({})
                            }
                        }
                        
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
    
    func performActionOnSpeakers(data: [SISpeaker]) {
        performSegueWithIdentifier("SpeakerListView", sender: data)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        navigationItem.title = ""
        
        switch segue.identifier! {
            
        case "SpeakerListView":
                
            let destination = segue.destinationViewController as! SpeakerListTableViewController
            if let speakers = sender as? [SISpeaker] {
                var kSpeakers = [SISpeaker]()
                var cSpeakers = [SISpeaker]()
                var uSpeakers = [SISpeaker]()
                
                for speaker in speakers {
                    if speaker.speakerType == .Keynote {
                        kSpeakers.append(speaker)
                    } else if speaker.speakerType == .Concurrent {
                        cSpeakers.append(speaker)
                    } else {
                        uSpeakers.append(speaker)
                    }
                }
                
                if !kSpeakers.isEmpty {
                    destination.keyNoteSpeakers = kSpeakers
                }
                
                if !cSpeakers.isEmpty {
                    destination.concurrentSpeakers = cSpeakers
                }
                
                if !uSpeakers.isEmpty {
                    destination.unknownSpeakers = uSpeakers
                }
                
            }
            
        default:
            break
        }
        
    }
    
}


extension SchedulesTableViewController {

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return agendas.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agendas[section].sessions.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScheduleCell", forIndexPath: indexPath) as! SchedulesTableViewCell
        
        cell.speakersButton.hidden = true
        cell.speakersButton.userInteractionEnabled = false
        
        cell.session = agendas[indexPath.section].sessions[indexPath.row]
        cell.delegate = self
        
        if cellShouldExpand[indexPath.section][indexPath.row] {
            cell.expandCell()
        } else {
            cell.shrinkCell()
        }

        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SchedulesTableViewCell
        
        cell.isExpanded = !cell.isExpanded
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        
        let dateText = dateFormatter.stringFromDate(agendas[section].date)
        
        let title = "  \(agendas[section].displayName), \(dateText)"
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFontOfSize(16)
        label.textColor = UIColor.whiteColor()
        
        return label
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
}

extension SchedulesTableViewController {
    // MARK: - Sorting
    private func sortSessionsByDate(sender: AnyObject?) -> [SISession]? {
        var sessions = sender as! [SISession]
        for i in 0 ..< sessions.count - 1 {
            
            for n in 0 ..< sessions.count - i - 1 {
                
                if sessions[n].startDate.isGreaterThanDate(sessions[n+1].startDate) {
                    let session = sessions[n]
                    sessions[n] = sessions[n+1]
                    sessions[n+1] = session
                }
            }
        }
        
        return sessions
    }
}

class SchedulesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoTextView: UITextView! {
        didSet {
            infoTextView.layer.shadowColor = UIColor.grayColor().CGColor
            infoTextView.layer.shadowOffset = CGSizeMake(0, 2.0)
            infoTextView.layer.shadowOpacity = 1
            infoTextView.layer.shadowRadius = 3
            infoTextView.layer.masksToBounds = false
            infoTextView.layer.cornerRadius = 3
        }
    }
    @IBOutlet weak var speakersButton: UIButton! {
        didSet {
            speakersButton.imageView?.contentMode = .ScaleAspectFit
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    
    var delegate: SISpeakerDelegate?
    
    var isExpanded = false {
        didSet {
            if isExpanded {
                self.expandCell()
                session.isSelected = true
            } else {
                self.shrinkCell()
                session.isSelected = false
            }
        }
    }
    
    var session: SISession! {
        didSet {
            updateCell()
        }
    }
    
    func updateCell() {
        
        selectionStyle = .None
        
        speakersButton.addTarget(self, action: #selector(SchedulesTableViewCell.didTapSpeakersButton), forControlEvents: .TouchUpInside)
        
        if let session = session {
            timeLabel.text = NSDate().timeFrameBetweenDates(startDate: session.startDate, endDate: session.endDate)
            
            titleLabel.font = UIFont.helveticaOfFontSize(16)
            titleLabel.text = "\(session.sessionType.rawValue): \(session.displayName)"
            
            if !session.didLoadSessionInformation {
                activityIndicator.startAnimating()
                session.requestSessionInformation({
                    if !session.speakers.isEmpty {
                        self.speakersButton.hidden = false
                        self.speakersButton.userInteractionEnabled = true
                    }
                    self.layoutIfNeeded()
                    self.activityIndicator.stopAnimating()
                })
            } else {
                if !session.speakers.isEmpty {
                    self.speakersButton.hidden = false
                    self.speakersButton.userInteractionEnabled = true
                }
            }
            
        }
    }
    
    private func expandCell() {
        guard let info = getAttributedStringForSession(room: session.room, summary: session.summary) else {
            infoTextView.text = "Check back later for more information."
            infoTextView.font = UIFont.helveticaOfFontSize(14)
            return
        }
        
        if info.string.isEmpty {
            infoTextView.text = "Check back later for more information."
            infoTextView.font = UIFont.helveticaOfFontSize(14)
            return
        }
        
        infoTextView.attributedText = info
        infoTextView.textAlignment = .Left
        infoTextView.textColor = .blackColor()
    }
    
    private func shrinkCell() {
        infoTextView.text = "Select For More Info >"
        infoTextView.textAlignment = .Center
        infoTextView.textColor = .grayColor()
        infoTextView.font = UIFont.helveticaOfFontSize(14)
        infoTextView.layer.borderWidth = 0
    }
    
    @IBAction func didTapSpeakersButton() {
        if !session.speakers.isEmpty {
            if let delegate = delegate {
                delegate.performActionOnSpeakers(session.speakers)
            }
        }
    }
    
    private func getAttributedStringForSession(room room: SIRoom?, summary: String) -> NSAttributedString? {
        
        let attributes: [String:AnyObject] = [
            NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute : NSUTF8StringEncoding
        ]
        
        var roomName = ""
        
        if let room = room {
            if !room.name.isEmpty {
                roomName += "<p><b>Room: \(room.name)</b></p>"
            }
        }
        
        do {
            let attributedRoomName = try NSMutableAttributedString(data: "<font face=\"Arial, Helvetica, sans-serif\" size=\"4\">\(roomName)</font>".dataUsingEncoding(NSUTF8StringEncoding)!,
                                                               options: attributes,
                                                               documentAttributes: nil)
            
            let attrSummary = try NSMutableAttributedString(data: "<font face=\"Arial, Helvetica, sans-serif\" size=\"4\">\(summary)</font>".dataUsingEncoding(NSUTF8StringEncoding)!,
                                                        options: attributes,
                                                        documentAttributes: nil)
            
            attributedRoomName.appendAttributedString(attrSummary)
            
            return attributedRoomName
        } catch {
            return nil
        }

    }
    
}












