//
//  AffiliateTableViewCell.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 9/29/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class AffiliateTableViewCell: SITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel! { didSet { entityNameLabel = nameLabel } }
    @IBOutlet weak var logoImageView: UIImageView! { didSet { entityImageView = logoImageView } }
    @IBOutlet weak var summaryTextView: UITextView! { didSet { entityTextView = summaryTextView } }

    override func updateCell() {
        super.updateCell()
        if let affiliate = entity as? SIAffiliate {
            affiliate.getLogoImage() { image in
                self.logoImageView.image = image
                let maxWidth = self.contentView.frame.width - 16
                if image.size.width > maxWidth {
                    self.logoImageView.resizeImageViewToIntrinsicContentSize(thatFitsWidth: maxWidth)
                }
            }
        }
    }
}
