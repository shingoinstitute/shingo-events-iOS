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
            
            // maxWidth is the width of the container view minus the margins, where total margin width is 16
            let maxWidth = self.contentView.frame.width - 16

            affiliate.getLogoImage() { image in
                
                if image.size.width > maxWidth {
                    self.logoImageView.image = image

                    self.logoImageView.resizeImageViewToIntrinsicContentSize(thatFitsWidth: maxWidth)
                    affiliate.image = self.logoImageView.image
                    self.logoImageView.image = affiliate.image
                    
                } else {
                    self.logoImageView.image = affiliate.image
                }
                
            }
        }
    }

}
