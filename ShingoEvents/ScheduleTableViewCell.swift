//
//  ScheduleTableViewCell.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 9/26/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import Foundation

class ScheduleTableViewCell: UITableViewCell {
    
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
            session.isSelected = isExpanded
            if isExpanded {
                expandCell()
            } else {
                shrinkCell()
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
        timeLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        speakersButton.addTarget(self, action: #selector(ScheduleTableViewCell.didTapSpeakersButton), for: .touchUpInside)
        
        if let session = session {
            if let timeFrame = Date.timeFrameBetweenDates(startDate: session.startDate, endDate: session.endDate) {
                timeLabel.attributedText = timeFrame
            } else {
                timeLabel.text = "Session time is currently unavailable"
            }
            
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
    
    private func expandCell() {
        guard let info = getAttributedStringForSession() else {
            infoTextView.text = "Check back later for more information."
            infoTextView.font = UIFont.preferredFont(forTextStyle: .body)
            infoTextView.textColor = .black
            return
        }
        
        if info.string == "\n\nTap To See Less..." {
            
            let notificationText = NSMutableAttributedString(string: "Check back later for more information.",
                                                             attributes: [NSParagraphStyleAttributeName : SIParagraphStyle.left])
            notificationText.addAttribute(NSFontAttributeName, value: UIFont.preferredFont(forTextStyle: .body), range: notificationText.fullRange)
            notificationText.append(info)
            
            infoTextView.attributedText = notificationText
            
            return
        }
        
        infoTextView.attributedText = info
    }
    
    private func shrinkCell() {
        infoTextView.text = "Select For More Info >"
        infoTextView.textAlignment = .center
        infoTextView.textColor = .gray
        infoTextView.font = UIFont.preferredFont(forTextStyle: .footnote)
    }
    
    @IBAction func didTapSpeakersButton() {
        if !session.speakers.isEmpty {
            if let delegate = delegate {
                delegate.performActionOnSpeakers(data: session.speakers)
            }
        }
    }
    
    private func getAttributedStringForSession() -> NSAttributedString? {
        
        var roomName = ""
        
        if let room = session.room {
            if !room.name.isEmpty {
                roomName += "<p>Room: \(room.name)</p>"
            }
        }
        
        do {
            
            let attributes: [String:Any] = [
                NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute : String.Encoding.utf8.rawValue,
                NSParagraphStyleAttributeName : SIParagraphStyle.left,
            ]
            
            let attributedText = try NSMutableAttributedString(data: roomName.data(using: String.Encoding.utf8)!, options: attributes, documentAttributes: nil)
            
            attributedText.addAttribute(NSFontAttributeName, value: UIFont.preferredFont(forTextStyle: .headline), range: attributedText.fullRange)
            
            attributedText.append(self.session.attributedSummary)
            
            let centerStyle = NSMutableParagraphStyle()
            centerStyle.alignment = .center
            
            let swipeAttributes:[String:Any] = [
                NSParagraphStyleAttributeName : SIParagraphStyle.center,
                NSForegroundColorAttributeName : UIColor.gray,
                NSFontAttributeName : UIFont.preferredFont(forTextStyle: .footnote)
            ]
            
            let swipeUpIndicator = NSMutableAttributedString(string: "\n\nTap To See Less...", attributes: swipeAttributes)
            
            attributedText.append(swipeUpIndicator)
            
            return attributedText
        } catch {
            return nil
        }
        
    }
    
}
