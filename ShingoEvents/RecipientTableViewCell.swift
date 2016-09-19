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
    
    var didSetupConstraints = false
    
    @IBOutlet weak var recipientLabel: UILabel!
    @IBOutlet weak var recipientImage: UIImageView!

    var logoImage : UIImageView = {
        let view = UIImageView.newAutoLayout()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()
    
    var nameLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.lineBreakMode = NSLineBreakMode.byWordWrapping
        return view
    }()
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            recipientLabel.removeFromSuperview()
            recipientImage.removeFromSuperview()
            
            contentView.addSubview(logoImage)
            contentView.addSubview(nameLabel)
            
            logoImage.autoSetDimensions(to: CGSize(width: 115, height: 115))
            logoImage.autoPinEdge(.top, to: .top, of: contentView, withOffset: 8)
            logoImage.autoPinEdge(.left, to: .left, of: contentView, withOffset: 8)
            
            nameLabel.autoPinEdge(.top, to: .top, of: contentView)
            nameLabel.autoPinEdge(.left, to: .right, of: logoImage, withOffset: 5)
            nameLabel.autoPinEdge(.right, to: .right, of: contentView)
            nameLabel.autoPinEdge(.bottom, to: .bottom, of: contentView)
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    fileprivate func updateCell() {
        if let recipient = recipient {
            
            nameLabel.text = recipient.name
            
            recipient.getRecipientImage() { image in
                self.logoImage.image = image
            }
            
        }
    }
    
}
