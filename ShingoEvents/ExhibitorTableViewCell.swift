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
        let view = UIImageView.newAutoLayout()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()
    
    var nameLabel:UILabel = {
        let view = UILabel.newAutoLayout()
        view.numberOfLines = 4
        view.lineBreakMode = .byWordWrapping
        view.font = UIFont.boldSystemFont(ofSize: 14.0)
        return view
    }()
    
    var didSetupConstraints = false
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            self.accessoryType = .disclosureIndicator
            
            contentView.addSubview(logoImage)
            contentView.addSubview(nameLabel)
            
            NSLayoutConstraint.autoSetPriority(UILayoutPriorityRequired) {
                self.logoImage.autoSetContentCompressionResistancePriority(for: .vertical)
            }
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                logoImage.autoSetDimensions(to: CGSize(width: 300 - 16, height: 200 - 16))
            } else {
                logoImage.autoSetDimensions(to: CGSize(width: 150 - 16, height: 150 - 16))
            }
            
            logoImage.autoAlignAxis(.horizontal, toSameAxisOf: contentView)
            logoImage.autoPinEdge(.left, to: .left, of: contentView, withOffset: 8)
            
            nameLabel.autoPinEdge(toSuperviewEdge: .top)
            nameLabel.autoPinEdge(.left, to: .right, of: logoImage, withOffset: 8)
            nameLabel.autoPinEdge(.right, to: .right, of: contentView, withOffset: -10)
            nameLabel.autoPinEdge(toSuperviewEdge: .bottom)
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    fileprivate func updateCell() {
        if let exhibitor = exhibitor {
            nameLabel.text = exhibitor.name
            exhibitor.getLogoImage() { image in
                self.logoImage.image = image
                self.setNeedsDisplay()
            }
        }
    }
    
}
