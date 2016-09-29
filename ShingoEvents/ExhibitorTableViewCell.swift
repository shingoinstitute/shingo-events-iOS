//
//  ExhibitorTableViewCell.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 8/15/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class SITableViewCell: UITableViewCell {
    
    var entityNameLabel: UILabel!
    var entityImageView: UIImageView!
    var entityTextView: UITextView! {
        didSet {
            entityTextView.layer.shadowColor = UIColor.lightGray.cgColor
            entityTextView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
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
    
    private let summaryAttrs = [
        NSFontAttributeName : UIFont.preferredFont(forTextStyle: .body),
        NSParagraphStyleAttributeName : SIParagraphStyle.left,
        NSForegroundColorAttributeName : UIColor.black
    ]
    
    private var defaultText = NSAttributedString(string: "Check back later for more information")
    
    private let tapToSeeLessText = NSAttributedString(string: "\n\nTap To See Less...", attributes: [
        NSFontAttributeName : UIFont.preferredFont(forTextStyle: .footnote),
        NSForegroundColorAttributeName : UIColor.gray,
        NSParagraphStyleAttributeName : SIParagraphStyle.center
        ])
    
    private let selectMoreInfoText = NSAttributedString(string: "Select For More Info >", attributes: [
        NSFontAttributeName : UIFont.preferredFont(forTextStyle: .footnote),
        NSForegroundColorAttributeName : UIColor.gray,
        NSParagraphStyleAttributeName : SIParagraphStyle.center
        ])
    
    func updateCell() {
        selectionStyle = .none
        entityNameLabel.text = entity.name
    }
    
    func expandCell() {
        let summary = NSMutableAttributedString(attributedString: entity.attributedSummary)
        
        if summary.string.isEmpty {
            summary.append(defaultText)
        }
        
        summary.addAttributes(summaryAttrs, range: summary.fullRange)
        
        summary.append(tapToSeeLessText)
        
        entityTextView.attributedText = summary
    }
    
    func shrinkCell() {
        entityTextView.attributedText = selectMoreInfoText
    }
    
}

class ExhibitorTableViewCell: SITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel! { didSet { entityNameLabel = nameLabel } }
    @IBOutlet weak var exhibitorImageView: UIImageView! { didSet { entityImageView = exhibitorImageView } }
    @IBOutlet weak var textView: UITextView! { didSet { entityTextView = textView } }
    
//    var exhibitor: SIExhibitor! {
//        didSet {
//            updateCell()
//        }
//    }
    
    override func updateCell() {
        super.updateCell()
        if let exhibitor = entity as? SIExhibitor {
            exhibitor.getBannerImage({ (image) in
                self.exhibitorImageView.image = image
            })
        }
    }
    
    
    
}
