//
//  ScheduleTableViewCell.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 9/26/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import Foundation

class ScheduleTableViewCell: SITableViewCell {
    
    // timeLabel, titleLabel, and infoTextView each pass their reference to properties subclassed in SITableViewCell.
    @IBOutlet weak var timeLabel: UILabel! { didSet { entityTimeLabel = timeLabel } }
    @IBOutlet weak var titleLabel: UILabel! { didSet { entityNameLabel = titleLabel } }
    @IBOutlet weak var infoTextView: UITextView! {
        didSet {
            infoTextView.isHidden = true
            entityTextView = infoTextView
        }
    }
    
    // Note: speakersButton and activityIndicator are not defined by SITableViewCell
    @IBOutlet weak var speakersButton: UIButton!{
        didSet {
            speakersButton.isHidden = true
            speakersButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var session: SISession! { didSet { entity = session } }
    
    var delegate: SISpeakerDelegate?
    
    override func updateCell() {
        
        selectionStyle = .none
        
        session.tableviewCellDelegate = self
        
        speakersButton.addTarget(self, action: #selector(ScheduleTableViewCell.didTapSpeakersButton), for: .touchUpInside)

        infoTextView.isHidden = !(!session.attributedSummary.string.isEmpty || session.room != nil)
        
        timeLabel.text = session.startDate.toTimeString() + " - " + session.endDate.toTimeString()
        
        titleLabel.text = "\(session.sessionType.rawValue): \(session.displayName)"
        
        if session.sessionRequest == nil && !session.didLoadSessionDetails {
            
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
            
            session.requestSessionInformation({ _ in
                self.session.didLoadSessionDetails = true
                if !self.session.speakers.isEmpty {
                    self.speakersButton.isHidden = false
                    self.speakersButton.isUserInteractionEnabled = true
                }
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                self.layoutIfNeeded()
            })
            
        } else if !session.didLoadSessionDetails {
            
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
            
        } else {
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
        
        updateSpeakersButton()
    }
    
    func updateSpeakersButton() {
        if session.speakerRequest == nil && !session.didLoadSessionDetails {
            self.session.requestSpeakers({
                self.speakersButton.isHidden = self.session.speakers.isEmpty
            })
        } else if session.didLoadSessionDetails {
            speakersButton.isHidden = self.session.speakers.isEmpty
        }
    }
    
    override func expandCell() {
        
        if !infoTextView.isHidden {
            super.expandCell()
            
            let sessionSummary = NSMutableAttributedString()
            
            if let room = session.room {
                sessionSummary.append(NSAttributedString(string: "Room: \(room.name)", attributes: [
                        NSFontAttributeName : UIFont.preferredFont(forTextStyle: .headline)
                    ]))
                if !session.attributedSummary.string.isEmpty {
                    sessionSummary.append(NSAttributedString(string: "\n\n"))
                }
            }

            sessionSummary.append(session.attributedSummary)
            
            sessionSummary.addAttribute(NSForegroundColorAttributeName, value: UIColor(netHex: 0x424242), range: sessionSummary.fullRange)
            
            sessionSummary.append(tapToSeeLessText)
            
            infoTextView.attributedText = sessionSummary
        }
    }
    
    @IBAction func didTapSpeakersButton() {
        if !session.speakers.isEmpty {
            if let delegate = delegate {
                delegate.performActionOnSpeakers(data: session.speakers)
            }
        }
    }
    
}

extension ScheduleTableViewCell: SISessionDelegate {
    func onSpeakerRequestComplete() {
        DispatchQueue.main.async {
            self.speakersButton.isHidden = self.session.speakers.isEmpty
        }
    }
    
    func onSessionDetailRequestComplete() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}









