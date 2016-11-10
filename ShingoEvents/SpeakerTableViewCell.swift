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
    
    @IBOutlet weak var speakerImageBottomConstraint: NSLayoutConstraint!
    
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
    
    func addSummaryTextField() {
        
        if entityTextView.superview != nil {
            return
        }
        
        contentView.addSubview(entityTextView)
        
        for constraint in entityNameLabel.constraints {
            if constraint.firstAttribute == NSLayoutAttribute.bottom {
                constraint.autoRemove()
                break
            }
        }
        
        entityNameLabel.autoPinEdge(.bottom, to: .top, of: entityTextView, withOffset: -8)
        
        entityTextView.autoPinEdge(.leading, to: .leading, of: contentView, withOffset: 8).priority = 1000
        entityTextView.autoPinEdge(.trailing, to: .trailing, of: contentView, withOffset: -8).priority = 1000
        entityTextView.autoPinEdge(.bottom, to: .bottom, of: contentView, withOffset: -8).priority = 750
        
        contentView.layoutSubviews()
    }
    
    func removeSummaryTextField() {
        entityTextView.removeFromSuperview()
        
        entityNameLabel.autoPinEdge(.bottom,
                                    to: .bottom,
                                    of: contentView,
                                    withOffset: 30,
                                    relation: .greaterThanOrEqual).priority = 1000
        
        NSLayoutConstraint.autoCreateConstraintsWithoutInstalling {
            let constraint = self.entityImageView.autoPinEdge(.bottom,
                                                              to: .bottom,
                                                              of: contentView,
                                                              withOffset: -30)
            constraint.priority = 750
            constraint.autoInstall()
            contentView.layoutSubviews()
        }
        
    }
    
}





