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

    /*
     When a cell is tapped, it will expand to show additional
     information, or shrink to show less information if it was
     already expanded.
     
     cellExpansionTracker keeps track of which cells have been
     expanded so that cells maintain their expanded or shrunk
     style as they get recylced on the view controller.
     */
    var cellExpansionTracker: [[Bool]] {
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
        tableView.backgroundColor = SIColor.prussianBlue()
        
        if agendas == nil {
            addNoContentLabel()
            agendas = [SIAgenda]()
        } else if agendas.isEmpty {
            addNoContentLabel()
        } else {
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(forName: .UIContentSizeCategoryDidChange, object: .none, queue: OperationQueue.main) { _ in
            self.tableView.reloadData()
        }
        
    }
    
    func addNoContentLabel() {
        
        let infoLabel = UILabel.newAutoLayout()
        infoLabel.font = UIFont.helveticaOfFontSize(16)
        infoLabel.textColor = .white
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.text = "Content is currently unavailable, please check back later."
        infoLabel.lineBreakMode = .byWordWrapping
        
        tableView.addSubview(infoLabel)
        infoLabel.autoAlignAxis(.vertical, toSameAxisOf: tableView)
        infoLabel.autoAlignAxis(.horizontal, toSameAxisOf: tableView)
        infoLabel.autoPinEdge(.left, to: .left, of: tableView, withOffset: 16)
        infoLabel.autoPinEdge(.right, to: .right, of: tableView, withOffset: -16)
        
    }
    
    func performActionOnSpeakers(data: [SISpeaker]) {
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
        
        cell.session = agendas[(indexPath as NSIndexPath).section].sessions[(indexPath as NSIndexPath).row]
        cell.delegate = self
        
        if !cell.session.didLoadSpeakers || cell.session.speakers.isEmpty {
            cell.speakersButton.isHidden = true
            cell.speakersButton.isUserInteractionEnabled = false
        } else if !cell.session.speakers.isEmpty {
            cell.speakersButton.isHidden = false
            cell.speakersButton.isUserInteractionEnabled = true
        }
        
        
        if cellExpansionTracker[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row] {
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
//        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.font = UIFont.preferredFont(forTextStyle: .headline)
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
            if let timeFrame = Date.timeFrameBetweenDates(startDate: session.startDate, endDate: session.endDate) {
                timeLabel.text = timeFrame
            } else {
                timeLabel.text = "Session time is currently unavailable"
            }
            
            titleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
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
            }
            
        }
    }
    
    func expandCell() {
        guard let info = getAttributedStringForSession(room: session.room, summary: session.summary) else {
            infoTextView.text = "Check back later for more information."
            infoTextView.font = UIFont.preferredFont(forTextStyle: .body)
            infoTextView.textColor = .black
            return
        }
        
        if info.string == "\n\nTap To See Less..." {
            
            let leftStyle = NSMutableParagraphStyle()
            leftStyle.alignment = .left
            
            let notificationText = NSMutableAttributedString(string: "Check back later for more information.",
                                                             attributes: [
                                                                NSFontAttributeName : UIFont.preferredFont(forTextStyle: .body),
                                                                NSParagraphStyleAttributeName : leftStyle
                                                            ])
            notificationText.append(info)
            
            infoTextView.attributedText = notificationText
            
            return
        }
        
        infoTextView.attributedText = info
    }
    
    func shrinkCell() {
        infoTextView.text = "Select For More Info >"
        infoTextView.textAlignment = .center
        infoTextView.textColor = .gray
        infoTextView.font = UIFont.preferredFont(forTextStyle: .footnote)
        infoTextView.layer.borderWidth = 0
    }
    
    @IBAction func didTapSpeakersButton() {
        if !session.speakers.isEmpty {
            if let delegate = delegate {
                delegate.performActionOnSpeakers(data: session.speakers)
            }
        }
    }
    
    fileprivate func getAttributedStringForSession(room: SIRoom?, summary: String) -> NSAttributedString? {

        var roomName = ""
        
        if let room = room {
            if !room.name.isEmpty {
                roomName += "<p>Room: \(room.name)</p>"
            }
        }
        
        do {
            
            let leftStyle = NSMutableParagraphStyle()
            leftStyle.alignment = .left
            
            let attributes: [String:Any] = [
                NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute : String.Encoding.utf8.rawValue,
                NSParagraphStyleAttributeName : leftStyle,
            ]
            
            let attrRoomName = try NSMutableAttributedString(data: roomName.data(using: String.Encoding.utf8)!,
                                                               options: attributes,
                                                               documentAttributes: nil)
            
            
            attrRoomName.addAttribute(NSFontAttributeName, value: UIFont.preferredFont(forTextStyle: .headline), range: attrRoomName.fullRange)
            

            let attrSummary = try NSMutableAttributedString(data: summary.data(using: String.Encoding.utf8)!,
                                                        options: attributes,
                                                        documentAttributes: nil)

//            let testText = "This is un-attributed, <i>this is italicized</i>, <b>this is bolded</b>, <u>this is underlined</u>, <b><i>this is bolded and italicized</i></b>, <b><i><u>and this is bolded, italicized, and underlined</u></i></b>."
            
//            let attrSummary = try NSMutableAttributedString(data: testText.data(using: String.Encoding.utf8)!,
//                                                            options: attributes,
//                                                            documentAttributes: nil)
            
            attrSummary.usePreferredFontWhileMaintainingAttributes(forTextStyle: .subheadline)
            
            attrRoomName.append(attrSummary)
            
            let swipeAttributes:[String:Any] = [
                NSParagraphStyleAttributeName : SIParagraphStyle.center,
                NSForegroundColorAttributeName : UIColor.gray,
                NSFontAttributeName : UIFont.preferredFont(forTextStyle: .footnote)
            ]
            
            let swipeUpIndicator = NSMutableAttributedString(string: "\n\nTap To See Less...", attributes: swipeAttributes)
            
            attrRoomName.append(swipeUpIndicator)
            
            return attrRoomName
        } catch {
            return nil
        }

    }
    
}

extension String {
    var length: Int { get { return self.characters.count } }
}

extension NSMutableAttributedString {
    ///Maintains bold and italic traits while using dynamic font.
    func usePreferredFontWhileMaintainingAttributes(forTextStyle: UIFontTextStyle) {
        self.enumerateAttribute(NSFontAttributeName, in: fullRange, options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) {
            (attribute: Any?, range: NSRange, stop: UnsafeMutablePointer<ObjCBool>) in
            
            let stringInRange = self.attributedSubstring(from: range)
            
            let pointSize = UIFont.preferredFont(forTextStyle: forTextStyle).pointSize
            var updatedFont: UIFont!
            if stringInRange.isBold {
                updatedFont = UIFont.boldSystemFont(ofSize: pointSize)
            } else if stringInRange.isItalic {
                updatedFont = UIFont.italicSystemFont(ofSize: pointSize)
            } else {
                updatedFont = UIFont.systemFont(ofSize: pointSize)
            }
            print(updatedFont.familyName)
            print(updatedFont.familyName)
            self.addAttribute(NSFontAttributeName, value: updatedFont, range: range)
            
        }
    }

}

extension NSAttributedString {
    var fullRange: NSRange { get { return NSMakeRange(0, self.string.length) } }
    
    var isBold: Bool {
        get {
            var isBold = false
            self.enumerateAttribute(NSFontAttributeName, in: self.fullRange, options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) { (attribute: Any?, range: NSRange, stop: UnsafeMutablePointer<ObjCBool>) in
                if let font = attribute as? UIFont {
                    if font.fontName.lowercased().contains("bold") {
                        isBold = true
                    }
                }
            }
            return isBold
        }
    }
    
    var isItalic: Bool {
        get {
            var isItalic = false
            self.enumerateAttribute(NSFontAttributeName, in: self.fullRange, options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) { (attribute: Any?, range: NSRange, stop: UnsafeMutablePointer<ObjCBool>) in
                if let font = attribute as? UIFont {
                    if font.fontName.lowercased().contains("italic") {
                        isItalic = true
                    }
                }
            }
            return isItalic
        }
    }
}

struct SIParagraphStyle {
    
    private static var style: NSMutableParagraphStyle { get { return NSMutableParagraphStyle() } }
    
    public static var center: NSParagraphStyle {
        get {
            style.alignment = .center
            return style
        }
    }
    
    public static var justified: NSParagraphStyle {
        get {
            style.alignment = .justified
            return style
        }
    }
    
    public static var left: NSParagraphStyle {
        get {
            style.alignment = .left
            return style
        }
    }
    
    public static var natural: NSParagraphStyle {
        get {
            style.alignment = .natural
            return style
        }
    }
    
    public static var right: NSParagraphStyle {
        get {
            style.alignment = .right
            return style
        }
    }

}










