//
//  RecipientTableViewCell.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 4/7/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class RecipientTableViewCell: UITableViewCell {

    var recipient: SIRecipient! {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet weak var recipientLabel: UILabel!
    @IBOutlet weak var recipientImage: UIImageView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

    }
    
    func updateCell() {
        recipientLabel.text = recipient.name
        
        recipientImage.contentMode = UIViewContentMode.ScaleAspectFit
        recipientImage.image = recipient.getRecipientImage()
        
    }
    
}
