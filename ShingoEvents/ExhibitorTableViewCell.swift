//
//  ExhibitorTableViewCell.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 8/15/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class ExhibitorTableViewCell: SITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel! { didSet { entityNameLabel = nameLabel } }
    @IBOutlet weak var exhibitorImageView: UIImageView! { didSet { entityImageView = exhibitorImageView } }
    @IBOutlet weak var textView: UITextView! { didSet { entityTextView = textView } }
    
    override func updateCell() {
        super.updateCell()
        if let exhibitor = entity as? SIExhibitor {
            exhibitor.getBannerImage({ (image) in
                self.exhibitorImageView.image = image
            })
        }
    }

}
