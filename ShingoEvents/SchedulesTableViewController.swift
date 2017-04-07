//
//  SchedulesTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/14/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import Alamofire

class SchedulesTableViewController: UITableViewController, SISpeakerDelegate {

    var event: SIEvent!
    
    lazy var agendas: [SIAgenda]! = {
        return self.event.agendas
    }()
    
    lazy var eventName: String! = {
       return self.event.name
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Schedule"
    }
    
    var gradientBackgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        agendas != nil && !agendas.isEmpty ? requestDataForTable() : addNoContentLabelNotification()
        tableView.backgroundView = gradientBackgroundView
        gradientBackgroundView.backgroundColor = .lightShingoBlue
        
        let gradientLayer = RadialGradientLayer()
        gradientLayer.frame = gradientBackgroundView.bounds
        gradientBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tableView.reloadData),
                                               name: NSNotification.Name.UIContentSizeCategoryDidChange,
                                               object: nil)
        
        tableView.estimatedRowHeight = 106
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.backgroundColor = .shingoBlue

    }
    
    private func requestDataForTable() {

        for section in 0 ..< self.agendas.count {
            let agenda = self.agendas[section]
            if !agenda.didLoadSessions {
                agenda.requestAgendaSessions({
                    let sessions = agenda.sessions.sorted {$1.startDate.regionDate > $0.startDate.regionDate}
                    agenda.sessions = sessions
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    for session in sessions {
                        session.requestSessionInformation(nil)
                    }
                })
            }
        }
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
                var keynoteSpeakers = [SISpeaker]()
                var concurrentSpeakers = [SISpeaker]()
                var otherSpeakers = [SISpeaker]()
                
                for speaker in speakers {
                    if speaker.speakerType == .keynote {
                        keynoteSpeakers.append(speaker)
                    } else if speaker.speakerType == .concurrent {
                        concurrentSpeakers.append(speaker)
                    } else {
                        otherSpeakers.append(speaker)
                    }
                }
                
                if !keynoteSpeakers.isEmpty { destination.keyNoteSpeakers = keynoteSpeakers }
                if !concurrentSpeakers.isEmpty { destination.concurrentSpeakers = concurrentSpeakers }
                if !otherSpeakers.isEmpty { destination.unknownSpeakers = otherSpeakers }
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
        
        let session = agendas[indexPath.section].sessions[indexPath.row]

        cell.session = session
        cell.delegate = self
        
        cell.isExpanded = session.isSelected

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
        
        let dateText: String = agendas[section].date.toString()
        
        let label = UILabel(text: "\t\(agendas[section].displayName), \(dateText)", font: UIFont.preferredFont(forTextStyle: .headline))
        label.textColor = UIColor.white
        
        return label
    }
    
}






