//
//  RecipientTableViewCell.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 4/7/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class RecipientTableViewCell: SITableViewCell {
    
    @IBOutlet weak var recipientLabel: UILabel! { didSet { entityNameLabel = recipientLabel } }
    @IBOutlet weak var recipientImage: UIImageView! { didSet { entityImageView = recipientImage } }
    @IBOutlet weak var summaryTextView: UITextView! { didSet { entityTextView = summaryTextView } }

    override func updateCell() {
        super.updateCell()
        
        if let recipient = entity as? SIRecipient {
            recipient.getRecipientImage() { image in
                self.recipientImage.image = image
            }
        }
    }
    
}
