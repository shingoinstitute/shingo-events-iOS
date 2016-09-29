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
     
     cellShouldExpand keeps track of which cells have been
     expanded so that cells are consistently expanded
     or shrunken.
     */
    func cellShouldExpand(indexPath: IndexPath) -> Bool {
        if agendas.indices.contains(indexPath.section) {
            if agendas[indexPath.section].sessions.indices.contains(indexPath.row) {
                return agendas[indexPath.section].sessions[indexPath.row].isSelected
            }
        }
        return false
    }
    
    override func loadView() {
        super.loadView()
        
        if agendas == nil {
            addNoContentLabelNotification()
        } else if agendas.isEmpty {
            addNoContentLabelNotification()
        } else {
            populateDataForTable()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Schedule"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SchedulesTableViewController.adjustFontForCategorySizeChange), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
        
        tableView.estimatedRowHeight = 106
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.backgroundColor = .shingoBlue
        
        
        
    }
    
    private func populateDataForTable() {
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
    
    func adjustFontForCategorySizeChange() {
        tableView.reloadData()
    }
    
    func addNoContentLabelNotification() {
        
        agendas = [SIAgenda]()
        
        let infoLabel = UILabel.newAutoLayout()
        infoLabel.font = UIFont.preferredFont(forTextStyle: .headline)
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
                    if speaker.speakerType == .keynote {
                        kSpeakers.append(speaker)
                    } else if speaker.speakerType == .concurrent {
                        cSpeakers.append(speaker)
                    } else {
                        uSpeakers.append(speaker)
                    }
                }
                
                if !kSpeakers.isEmpty { destination.keyNoteSpeakers = kSpeakers }
                if !cSpeakers.isEmpty { destination.concurrentSpeakers = cSpeakers }
                if !uSpeakers.isEmpty { destination.unknownSpeakers = uSpeakers }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as! ScheduleTableViewCell
        
        cell.session = agendas[indexPath.section].sessions[indexPath.row]
        cell.delegate = self
        
        if !cell.session.didLoadSpeakers || cell.session.speakers.isEmpty {
            cell.speakersButton.isHidden = true
            cell.speakersButton.isUserInteractionEnabled = false
        } else if !cell.session.speakers.isEmpty {
            cell.speakersButton.isHidden = false
            cell.speakersButton.isUserInteractionEnabled = true
        }
        
        cell.isExpanded = cellShouldExpand(indexPath: indexPath);

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ScheduleTableViewCell
        
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
        
        let label = UILabel(text: "\t\(agendas[section].displayName), \(dateText)", font: UIFont.preferredFont(forTextStyle: .headline))
        label.textColor = UIColor.white
        
        return label
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














