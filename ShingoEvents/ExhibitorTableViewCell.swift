//
//  ExhibitorTableViewCell.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 8/15/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit


class ExhibitorTableViewCell: UITableViewCell {
    
    var exhibitor: SIExhibitor! {
        didSet {
            updateCell()
        }
    }
    
    var logoImage : UIImageView = {
        let view = UIImageView.newAutoLayoutView()
        view.contentMode = .ScaleAspectFit
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()
    
    var nameLabel:UILabel = {
        let view = UILabel.newAutoLayoutView()
        view.numberOfLines = 4
        view.lineBreakMode = .ByWordWrapping
        view.font = UIFont.boldSystemFontOfSize(14.0)
        return view
    }()
    
    var didSetupConstraints = false
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            self.accessoryType = .DisclosureIndicator
            
            contentView.addSubview(logoImage)
            contentView.addSubview(nameLabel)
            
            NSLayoutConstraint.autoSetPriority(UILayoutPriorityRequired) {
                self.logoImage.autoSetContentCompressionResistancePriorityForAxis(.Vertical)
            }
            
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                logoImage.autoSetDimensionsToSize(CGSizeMake(300 - 16, 200 - 16))
            } else {
                logoImage.autoSetDimensionsToSize(CGSizeMake(150 - 16, 150 - 16))
            }
            
            logoImage.autoAlignAxis(.Horizontal, toSameAxisOfView: contentView)
            logoImage.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 8)
            
            nameLabel.autoPinEdgeToSuperviewEdge(.Top)
            nameLabel.autoPinEdge(.Left, toEdge: .Right, ofView: logoImage, withOffset: 8)
            nameLabel.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -10)
            nameLabel.autoPinEdgeToSuperviewEdge(.Bottom)
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    private func updateCell() {
        if let exhibitor = exhibitor {
            nameLabel.text = exhibitor.name
            exhibitor.getLogoImage() { image in
                self.logoImage.image = image
                self.setNeedsDisplay()
            }
        }
    }
    
}