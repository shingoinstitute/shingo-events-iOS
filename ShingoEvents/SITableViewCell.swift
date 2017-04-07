//
//  SITableViewCell.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 9/29/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class SITableViewCell: UITableViewCell {
    
    var entityTimeLabel: UILabel!
    var entityNameLabel: UILabel!
    var entityImageView: UIImageView!
    var entityTextView: UITextView! {
        didSet {
            entityTextView.isUserInteractionEnabled = false
            entityTextView.isSelectable = false
            entityTextView.layer.shadowColor = UIColor.lightGray.cgColor
            entityTextView.layer.shadowOffset = CGSize(width: 0, height: 0)
            entityTextView.layer.shadowOpacity = 1
            entityTextView.layer.shadowRadius = 3
            entityTextView.layer.masksToBounds = false
            entityTextView.layer.cornerRadius = 3
        }
    }
    
    var entity: SIObject! {
        didSet {
            updateCell()
        }
    }
    
    var isExpanded = false {
        didSet {
            entity.isSelected = isExpanded
            if isExpanded {
                expandCell()
            } else {
                shrinkCell()
            }
        }
    }
    
    let tapToSeeLessText = NSAttributedString(string: "\n\nTap To See Less...", attributes: [
        NSFontAttributeName : UIFont.preferredFont(forTextStyle: .footnote),
        NSForegroundColorAttributeName : UIColor.gray,
        NSParagraphStyleAttributeName : SIParagraphStyle.center
    ])
    
    let selectMoreInfoText = NSAttributedString(string: "Select For More Info >", attributes: [
        NSFontAttributeName : UIFont.preferredFont(forTextStyle: .footnote),
        NSForegroundColorAttributeName : UIColor.gray,
        NSParagraphStyleAttributeName : SIParagraphStyle.center
    ])
    
    func updateCell() {
        selectionStyle = .none
        
        if entityNameLabel != nil {
            entityNameLabel.text = entity.name
        }
        
        if entityTextView != nil {
            entityTextView.isHidden = entity.attributedSummary.string.isEmpty
        }
    }

    func expandCell() {
        if !entityTextView.isHidden {
            let summary = NSMutableAttributedString(attributedString: entity.attributedSummary)
            summary.append(tapToSeeLessText)
            entityTextView.attributedText = summary
        }
    }
    
    func shrinkCell() {
        if !entityTextView.isHidden {
            entityTextView.attributedText = selectMoreInfoText
        }
    }
    
}




