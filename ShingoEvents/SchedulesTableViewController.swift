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
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    func performActionOnSpeakers(_ data: [SISpeaker]) {
        performSegue(withIdentifier: "SpeakerListView", sender: data)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigationItem.title = ""
        
        switch segue.identifier! {
            
        case "SpeakerListView":
                
            let destination = segue.destination as! SpeakerListTableViewController
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return agendas.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agendas[section].sessions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as! SchedulesTableViewCell
        
        cell.speakersButton.isHidden = true
        cell.speakersButton.isUserInteractionEnabled = false
        
        cell.session = agendas[(indexPath as NSIndexPath).section].sessions[(indexPath as NSIndexPath).row]
        cell.delegate = self
        
        if cellShouldExpand[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row] {
            cell.expandCell()
        } else {
            cell.shrinkCell()
        }

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SchedulesTableViewCell
        
        cell.isExpanded = !cell.isExpanded
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        
        let dateText = dateFormatter.string(from: agendas[section].date as Date)
        
        let title = "  \(agendas[section].displayName), \(dateText)"
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
}

extension SchedulesTableViewController {
    // MARK: - Sorting
    fileprivate func sortSessionsByDate(_ sender: [SIObject]?) -> [SISession]? {
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
            infoTextView.layer.shadowColor = UIColor.gray.cgColor
            infoTextView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            infoTextView.layer.shadowOpacity = 1
            infoTextView.layer.shadowRadius = 3
            infoTextView.layer.masksToBounds = false
            infoTextView.layer.cornerRadius = 3
        }
    }
    @IBOutlet weak var speakersButton: UIButton! {
        didSet {
            speakersButton.imageView?.contentMode = .scaleAspectFit
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
        
        selectionStyle = .none
        
        speakersButton.addTarget(self, action: #selector(SchedulesTableViewCell.didTapSpeakersButton), for: .touchUpInside)
        
        if let session = session {
            timeLabel.text = Date().timeFrameBetweenDates(startDate: session.startDate, endDate: session.endDate)
            
            titleLabel.font = UIFont.helveticaOfFontSize(16)
            titleLabel.text = "\(session.sessionType.rawValue): \(session.displayName)"
            
            if !session.didLoadSessionInformation {
                activityIndicator.startAnimating()
                session.requestSessionInformation({
                    if !session.speakers.isEmpty {
                        self.speakersButton.isHidden = false
                        self.speakersButton.isUserInteractionEnabled = true
                    }
                    self.layoutIfNeeded()
                    self.activityIndicator.stopAnimating()
                })
            } else {
                if !session.speakers.isEmpty {
                    self.speakersButton.isHidden = false
                    self.speakersButton.isUserInteractionEnabled = true
                }
            }
            
        }
    }
    
    fileprivate func expandCell() {
        guard let info = getAttributedStringForSession(room: session.room, summary: session.summary) else {
            infoTextView.text = "Check back later for more information."
            infoTextView.font = UIFont.helveticaOfFontSize(14)
            infoTextView.textColor = .black
            return
        }
        
        if info.string == "\n\nTap To See Less..." {
            
            let leftStyle = NSMutableParagraphStyle()
            leftStyle.alignment = .left
            
            let notificationText = NSMutableAttributedString(string: "Check back later for more information.", attributes: [
                NSFontAttributeName : UIFont.helveticaOfFontSize(14),
                NSParagraphStyleAttributeName : leftStyle
                ])
            notificationText.append(info)
            
            infoTextView.attributedText = notificationText
            
            return
        }
        
        infoTextView.attributedText = info
    }
    
    fileprivate func shrinkCell() {
        infoTextView.text = "Select For More Info >"
        infoTextView.textAlignment = .center
        infoTextView.textColor = .gray
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
    
    fileprivate func getAttributedStringForSession(room: SIRoom?, summary: String) -> NSAttributedString? {

        var roomName = ""
        
        if let room = room {
            if !room.name.isEmpty {
                roomName += "<p><b>Room: \(room.name)</b></p>"
            }
        }
        
        do {
            
            let leftStyle = NSMutableParagraphStyle()
            leftStyle.alignment = .left
            
            let attributes: [String:AnyObject] = [
                NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType as AnyObject,
                NSCharacterEncodingDocumentAttribute : String.Encoding.utf8 as AnyObject,
                NSParagraphStyleAttributeName : leftStyle
            ]
            
            let attributedRoomName = try NSMutableAttributedString(data: "<font face=\"Arial, Helvetica, sans-serif\" size=\"4\">\(roomName)</font>".data(using: String.Encoding.utf8)!,
                                                               options: attributes,
                                                               documentAttributes: nil)
            
            let attrSummary = try NSMutableAttributedString(data: "<font face=\"Arial, Helvetica, sans-serif\" size=\"4\">\(summary)</font>".data(using: String.Encoding.utf8)!,
                                                        options: attributes,
                                                        documentAttributes: nil)
            
            attributedRoomName.append(attrSummary)
            
            
            
            let centeredStyle = NSMutableParagraphStyle()
            centeredStyle.alignment = .center
            
            let swipeAttributes = [
                NSParagraphStyleAttributeName : centeredStyle,
                NSForegroundColorAttributeName : UIColor.gray,
                NSFontAttributeName : UIFont.helveticaOfFontSize(14)
            ]
            
            let swipeUpIndicator = NSMutableAttributedString(string: "\n\nTap To See Less...", attributes: swipeAttributes)
            
            attributedRoomName.append(swipeUpIndicator)
            
            return attributedRoomName
        } catch {
            return nil
        }

    }
    
}












