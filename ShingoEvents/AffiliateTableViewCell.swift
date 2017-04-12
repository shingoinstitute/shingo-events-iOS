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
    
    @IBOutlet weak var logoImageHeightConstraint: NSLayoutConstraint!
    
    override func updateCell() {
        
        super.updateCell()
        if let affiliate = entity as? SIAffiliate {

            if let image = affiliate.image {
                logoImageView.image = image
                logoImageHeightConstraint.constant = image.size.height
            } else {
                affiliate.getLogoImage() { image in
                    self.logoImageView.image = affiliate.image
                    self.logoImageHeightConstraint.constant = image.size.height
                }
            }
            
            
            
        }
    }

}

extension NSLayoutConstraint {
    
}
