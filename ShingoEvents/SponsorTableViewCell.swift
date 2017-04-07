//
//  SponsorTableViewCell.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 11/9/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class SponsorTableViewCell: SITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView! { didSet { entityTextView = descriptionTextView } }
    
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    var sponsor: SISponsor! {
        didSet {
            entity = sponsor;
        }
    }
    
    var delegate: SICellDelegate?
    
    override func updateCell() {
        super.updateCell()
        
        if let _ = sponsor.image {
            sponsor.resizeIntrinsicContent(maximumAllowedWidth: frame.width)
            logoImageView = UIImageView(image: sponsor.image)
        } else {
            logoImageView = UIImageView(image: #imageLiteral(resourceName: "Handshake-100"))
            sponsor.requestBannerImage(callback: { 
                self.sponsor.resizeIntrinsicContent(maximumAllowedWidth: self.frame.width)
                self.logoImageView = UIImageView(image: self.sponsor.image)
            })
        }
        
        if sponsor.attributedSummary.string.isEmpty {
            descriptionTextView.removeFromSuperview()
            imageViewBottomConstraint = NSLayoutConstraint(item: logoImageView,
                                                           attribute: .bottom,
                                                           relatedBy: .equal,
                                                           toItem: contentView,
                                                           attribute: .bottomMargin,
                                                           multiplier: 1,
                                                           constant: 0)
            
            contentView.addConstraint(imageViewBottomConstraint)
            updateConstraints()
        }
        
        if let delegate = self.delegate {
            delegate.cellDidUpdate()
        }
        
    }
    
    override func expandCell() {
        if !entityTextView.isHidden {
            let summary = NSMutableAttributedString(attributedString: entity.attributedSummary)
            summary.append(tapToSeeLessText)
            entityTextView.attributedText = summary
        }
    }
    
    override func shrinkCell() {
        if !entityTextView.isHidden {
            entityTextView.attributedText = selectMoreInfoText
        }
    }
    
}








