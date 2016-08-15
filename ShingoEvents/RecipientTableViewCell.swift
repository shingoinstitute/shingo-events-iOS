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
        let view = UIImageView.newAutoLayoutView()
        view.contentMode = .ScaleAspectFit
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()
    
    var nameLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.lineBreakMode = NSLineBreakMode.ByWordWrapping
        return view
    }()
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            recipientLabel.removeFromSuperview()
            recipientImage.removeFromSuperview()
            
            contentView.addSubview(logoImage)
            contentView.addSubview(nameLabel)
            
            logoImage.autoSetDimensionsToSize(CGSizeMake(115, 115))
            logoImage.autoPinEdge(.Top, toEdge: .Top, ofView: contentView, withOffset: 8)
            logoImage.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 8)
            
            nameLabel.autoPinEdge(.Top, toEdge: .Top, ofView: contentView)
            nameLabel.autoPinEdge(.Left, toEdge: .Right, ofView: logoImage, withOffset: 5)
            nameLabel.autoPinEdge(.Right, toEdge: .Right, ofView: contentView)
            nameLabel.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: contentView)
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    private func updateCell() {
        if let recipient = recipient {
            nameLabel.text = recipient.name
            if let image = recipient.getRecipientImage() {
                logoImage.image = image
            } else {
                self.accessoryType = .None
            }
        }
    }
    
}
