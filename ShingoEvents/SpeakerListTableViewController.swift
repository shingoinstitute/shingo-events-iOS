//
//  SpeakerListTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/22/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class SpeakerListTableViewController: UITableViewController, SICellDelegate {

    var keyNoteSpeakers: [SISpeaker]!
    var concurrentSpeakers: [SISpeaker]!
    var unknownSpeakers: [SISpeaker]!
    
    lazy var speakerList: [[SISpeaker]?] = [
        self.keyNoteSpeakers,
        self.concurrentSpeakers,
        self.unknownSpeakers
    ]
    
    lazy var dataSource: [[SISpeaker]] = {
        var dataSource = [[SISpeaker]]()
        for speakerListType in self.speakerList {
            if let speakers = speakerListType {
                if !speakers.isEmpty {
                    dataSource.append(speakers)
                }
            }
        }
        return dataSource
    }()
    
    var gradientBackgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = gradientBackgroundView
        gradientBackgroundView.backgroundColor = .lightShingoBlue
        
        let gradientLayer = RadialGradientLayer()
        gradientLayer.frame = gradientBackgroundView.bounds
        gradientBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SchedulesTableViewController.adjustFontForCategorySizeChange), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.backgroundColor = .shingoBlue
        
        //Begin loading of speaker profile pictures
        for speakerList in dataSource {
            for speaker in speakerList {
                if !speaker.didLoadImage {
                    speaker.getSpeakerImage(callback: nil)
                }
            }
        }
        
    }
 
    func cellDidUpdate() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func adjustFontForCategorySizeChange() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}

extension SpeakerListTableViewController {
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpeakerListCell", for: indexPath) as! SpeakerTableViewCell
        
        cell.entity = dataSource[indexPath.section][indexPath.row]
        
        cell.isExpanded = cell.entity.isSelected
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SpeakerTableViewCell
        
        cell.isExpanded = !cell.isExpanded
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UILabel(text: "", font: UIFont.preferredFont(forTextStyle: .headline))
        header.textColor = .white

        guard let speaker = dataSource[section].first else {
            return nil
        }
        
        switch speaker.speakerType {
        case .keynote:
            header.text  = "  Keynote Speakers"
        case .concurrent:
            header.text  = "  Concurrent Speakers"
        case .none:
            header.text  = "  Speakers"
        }
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
}



