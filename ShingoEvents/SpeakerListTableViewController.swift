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
    
    lazy var speakerList: [[SISpeaker]?] = [
        self.keyNoteSpeakers,
        self.concurrentSpeakers,
        self.unknownSpeakers
    ]
    
    var dataSource: [[SISpeaker]?] {
        get {
            var value = [[SISpeaker]!]()
            for speakers in speakerList {
                if speakers == nil { continue }
                if !(speakers?.isEmpty)! { value.append(speakers) }
            }
            return value
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 117
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SpeakerListCell
        if let speaker = cell.speaker {
            performSegue(withIdentifier: "SpeakerDetails", sender: speaker)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SpeakerListCell
        if let speaker = cell.speaker {
            performSegue(withIdentifier: "SpeakerDetails", sender: speaker)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section]!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpeakerListCell", for: indexPath) as! SpeakerListCell
        
        cell.aiv.hidesWhenStopped = true

        cell.speaker = dataSource[(indexPath as NSIndexPath).section]?[(indexPath as NSIndexPath).row]
        
        if cell.speakerImage.image == nil {
            cell.aiv.startAnimating()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UILabel(text: "", font: UIFont(name: "Helvetica", size: 12))
        header.textColor = .white
        
        header.text = "  \(dataSource[section]?[0].speakerType.rawValue) Speakers"
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (dataSource[section]?.isEmpty)! { return 0 }
        
        return 32
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SpeakerDetails" {
            let destination = segue.destination as! SpeakerDetailsViewController
            if let speaker = sender as? SISpeaker {
                destination.speaker = speaker
            }
        }
    }

}


class SpeakerListCell: UITableViewCell {

    @IBOutlet weak var speakerNameLabel: UILabel! {
        didSet {
            speakerNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }
    @IBOutlet weak var speakerImage: UIImageView!
    @IBOutlet weak var speakerTitle: UILabel! {
        didSet {
            speakerTitle.font = UIFont.helveticaOfFontSize(15)
        }
    }
    @IBOutlet weak var speakerCompany: UILabel! {
        didSet {
            speakerCompany.font = UIFont.helveticaOfFontSize(15)
        }
    }
    @IBOutlet weak var aiv: UIActivityIndicatorView!
    
    var speaker: SISpeaker! {
        didSet {
            updateCell()
        }
    }
    
    func updateCell() {
        speakerNameLabel.text = speaker.name
        speakerTitle.text = speaker.title
        speakerCompany.text = speaker.organizationName
        speaker.getSpeakerImage() { image in
            self.aiv.stopAnimating()
            self.speakerImage.image = image
        }
    }
    
}





