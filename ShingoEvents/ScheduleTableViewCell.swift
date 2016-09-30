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
    
    var session: SISession! {
        didSet {
            entity = session
        }
    }
    
    var delegate: SISpeakerDelegate?
    
    override func updateCell() {
        
        selectionStyle = .none
        
        
        if !session.didLoadSpeakers {
            DispatchQueue.global(qos: .utility).async {
                self.session.requestSpeakers {
                    DispatchQueue.main.async {
                        if self.session.speakers.isEmpty {
                            self.speakersButton.isHidden = true
                        } else {
                            self.speakersButton.isHidden = false
                        }
                    }
                }
            }
        } else {
            if session.speakers.isEmpty {
                speakersButton.isHidden = true
            } else {
                speakersButton.isHidden = false
            }
        }
        
        speakersButton.addTarget(self, action: #selector(ScheduleTableViewCell.didTapSpeakersButton), for: .touchUpInside)

        if !session.attributedSummary.string.isEmpty || session.room != nil {
            infoTextView.isHidden = false
        } else {
            infoTextView.isHidden = true
        }
    
        if let timeFrame = Date.timeFrameBetweenDates(startDate: session.startDate, endDate: session.endDate) {
            timeLabel.attributedText = timeFrame
        } else {
            timeLabel.attributedText = NSAttributedString(string: "Session time unavailable", attributes: [NSFontAttributeName:UIFont.preferredFont(forTextStyle: .headline)])
        }
        
        titleLabel.text = "\(session.sessionType.rawValue): \(session.displayName)"
        
        if !session.didLoadSessionInformation {
            activityIndicator.startAnimating()
            session.requestSessionInformation({
                if !self.session.speakers.isEmpty {
                    self.speakersButton.isHidden = false
                    self.speakersButton.isUserInteractionEnabled = true
                }
                self.layoutIfNeeded()
                self.activityIndicator.stopAnimating()
            })
        }
    }
    
    override func expandCell() {
        if !infoTextView.isHidden {
            super.expandCell()
            
            let sessionSummary = NSMutableAttributedString()
            
            if let room = session.room {
                sessionSummary.append(NSAttributedString(string: "Room: \(room.name)", attributes: [NSFontAttributeName : UIFont.preferredFont(forTextStyle: .headline)]))
                if !session.attributedSummary.string.isEmpty {
                    sessionSummary.append(NSAttributedString(string: "\n\n"))
                }
            }
            
            let summary = NSMutableAttributedString(attributedString: session.attributedSummary)
            
            summary.addAttributes(summaryAttrs, range: summary.fullRange)
            
            sessionSummary.append(summary)

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
