//
//  SponsorTableViewCell.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 11/9/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class SponsorTableViewCell: SITableViewCell {

    @IBOutlet weak var nameLabel: UILabel! { didSet { entityNameLabel = nameLabel } }
    @IBOutlet weak var descriptionTextView: UITextView! { didSet { entityTextView = descriptionTextView } }
    @IBOutlet weak var logoImageView: UIImageView!
    
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
        guard let sponsor = sponsor else {
            return
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
        
        nameLabel.text = sponsor.name
        
        setLogoImage(sponsor: sponsor)
    
        
    }
    
//    override func expandCell() {
//        if !entityTextView.isHidden {
//            let summary = NSMutableAttributedString(attributedString: entity.attributedSummary)
//            summary.append(tapToSeeLessText)
//            entityTextView.attributedText = summary
//        }
//    }
//    
//    override func shrinkCell() {
//        if !entityTextView.isHidden {
//            entityTextView.attributedText = selectMoreInfoText
//        }
//    }
    
    func setLogoImage(sponsor: SISponsor) {
        sponsor.getLogoImage() { image in
            
            if image.size.width > self.contentView.frame.width {
                let imageView = UIImageView()
                imageView.image = image
                imageView.resizeImageViewToIntrinsicContentSize(thatFitsWidth: self.contentView.frame.width)
                if let image = imageView.image {
                    self.logoImageView.image = image
                }
                if let delegate = self.delegate {
                    delegate.cellDidUpdate()
                }
            } else {
                self.logoImageView.image = image
                if let delegate = self.delegate {
                    delegate.cellDidUpdate()
                }
            }
        }
    }
    
}
