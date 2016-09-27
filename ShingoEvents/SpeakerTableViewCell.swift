//
//  SpeakerTableViewCell.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 9/27/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class SpeakerTableViewCell: UITableViewCell {

    @IBOutlet weak var speakerNameLabel: UILabel! {
        didSet {
            speakerNameLabel.text = ""
            speakerNameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        }
    }
    @IBOutlet weak var speakerImageView: UIImageView! {
        didSet {
            speakerImageView.backgroundColor = .clear
            speakerImageView.layer.cornerRadius = 5
            speakerImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var aiv: UIActivityIndicatorView! {
        didSet {
            aiv.hidesWhenStopped = true
        }
    }
    @IBOutlet weak var summaryTextView: UITextView! {
        didSet {
            summaryTextView.textColor = UIColor.gray
            
            summaryTextView.layer.shadowColor = UIColor.gray.cgColor
            summaryTextView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            summaryTextView.layer.shadowOpacity = 1
            summaryTextView.layer.shadowRadius = 3
            summaryTextView.layer.masksToBounds = false
            summaryTextView.layer.cornerRadius = 3
        }
    }
    
    @IBOutlet weak var speakerImageWidthConstraint: NSLayoutConstraint!
    
    
    private var selectForMoreInfoText: NSAttributedString = {
        
        let attributes = [
            NSFontAttributeName : UIFont.preferredFont(forTextStyle: .footnote),
            NSForegroundColorAttributeName : UIColor.gray,
            NSParagraphStyleAttributeName : SIParagraphStyle.center
        ]
        
        return NSAttributedString(string: "Select For More Info >", attributes: attributes)
    }()
    
    
//    var delegate: SICellDelegate?
    
    var speaker: SISpeaker! {
        didSet {
            if !speaker.didLoadImage {
                speakerImageView.image = nil
                aiv.startAnimating()
            }
            updateCell()
        }
    }
    
    var isExpanded = false {
        didSet {
            if isExpanded {
                speaker.isSelected = true
                expandCell()
            } else {
                speaker.isSelected = false
                shrinkCell()
            }
        }
    }
    
    func updateCell() {
        
        selectionStyle = .none
        
        speakerNameLabel.text = "\(speaker.name)\n\(speaker.title)"
        
        speaker.getSpeakerImage() { image in
            self.speakerImageView.image = image
            self.speakerImageView.resizeImageViewToIntrinsicContentSize(thatFitsWidth: self.speakerImageWidthConstraint.constant)
            self.aiv.stopAnimating()
        }
    }
    
    private func expandCell() {

        let bioAttributes = [
            NSParagraphStyleAttributeName : SIParagraphStyle.left,
            NSForegroundColorAttributeName : UIColor.black,
            NSFontAttributeName : UIFont.preferredFont(forTextStyle: .body)
        ]
        
        let biography = NSMutableAttributedString(attributedString: speaker.attributedBiography)
        
        if biography.string.isEmpty {
            biography.append(NSAttributedString(string: "Check back later for more information."))
        }
        
        biography.addAttributes(bioAttributes, range: biography.fullRange)
        
        let tapAttributes = [
            NSFontAttributeName : UIFont.preferredFont(forTextStyle: .footnote),
            NSForegroundColorAttributeName : UIColor.gray,
            NSParagraphStyleAttributeName : SIParagraphStyle.center
        ]
        
        let tapToSeeLessText = NSAttributedString(string: "\n\nTap To See Less...", attributes: tapAttributes)
        
        biography.append(tapToSeeLessText)
        
        summaryTextView.attributedText = biography
    }
    
    private func shrinkCell() {
        summaryTextView.attributedText = selectForMoreInfoText
    }
    
}

extension UILabel {
    func alignTextToTop() {
        if let string = self.text {
            let stringText = string as NSString
            let labelStringSize = stringText.boundingRect(with: CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude) , options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: nil, context: nil).size
            super.draw(CGRect(x: 0, y: 0, width: self.frame.width, height: ceil(labelStringSize.height)))
        }
    }
}





