//
//  SpeakerTableViewCell.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 9/27/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class SpeakerTableViewCell: SITableViewCell {

    @IBOutlet weak var speakerNameLabel: UILabel! { didSet { entityNameLabel = speakerNameLabel } }
    @IBOutlet weak var aiv: UIActivityIndicatorView! { didSet { aiv.hidesWhenStopped = true } }
    @IBOutlet weak var summaryTextView: UITextView! { didSet { entityTextView = summaryTextView } }
    @IBOutlet weak var speakerImageView: UIImageView! {
        didSet {
            speakerImageView.layer.cornerRadius = 5
            entityImageView = speakerImageView
        }
    }
    
    @IBOutlet weak var speakerImageWidthConstraint: NSLayoutConstraint!
    
    override func updateCell() {
        super.updateCell()
        
        if let speaker = entity as? SISpeaker {
            speakerNameLabel.text = "\(speaker.name)\n\(speaker.title)"
            
            if speakerImageView.image == nil {
                aiv.startAnimating()
            }
            
            speaker.getSpeakerImage() { image in
                self.speakerImageView.image = image
                self.aiv.stopAnimating()
            }
        }
    }
}





