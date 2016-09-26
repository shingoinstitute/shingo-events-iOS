//
//  EventTableViewCell.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 9/23/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventNameLabel: UILabel! {
        didSet {
            eventNameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        }
    }
    @IBOutlet weak var eventDateRangeLabel: UILabel! {
        didSet {
            eventDateRangeLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        }
    }
    @IBOutlet weak var eventImageView: UIImageView! {
        didSet {
            eventImageView.backgroundColor = .clear
            eventImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var cardView: UIView! {
        didSet {
            cardView.backgroundColor = SIColor.lightShingoBlue
            
            cardView.layer.cornerRadius = 3
            cardView.layer.shadowColor = SIColor.darkShingoBlue.cgColor
            cardView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cardView.layer.shadowOpacity = 1
            cardView.layer.shadowRadius = 3
            cardView.layer.masksToBounds = false
        }
    }
    
    @IBOutlet weak var leadingEventImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingEventImageViewConstraint: NSLayoutConstraint!
    private let rightArrowImageViewWidthConstraintConstant: CGFloat = 30
    private let totalCardViewMarginConstants: CGFloat = (2 * 8)
    
    var event: SIEvent! { didSet { updateCell() } }
    
    var delegate: SICellDelegate?
    
    func updateCell() {
        
        backgroundColor = .clear
        selectionStyle = .none
        
        eventNameLabel.text = event.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateStyle = .medium
        let dates = "\(dateFormatter.string(from: event.startDate as Date)) - \(dateFormatter.string(from: event.endDate as Date))"
        eventDateRangeLabel.text = dates
        
        event.getBannerImage() { image in
            
            guard let image = image else {
                return
            }
            
            self.eventImageView.image = image;
            
            let imageWidth: CGFloat = self.contentView.frame.width - (self.leadingEventImageViewConstraint.constant + self.trailingEventImageViewConstraint.constant + self.rightArrowImageViewWidthConstraintConstant + self.totalCardViewMarginConstants)
            
            self.eventImageView.resizeImageIntrinsicContentSize(toFitWidth: imageWidth)
            
            if let delegate = self.delegate {
                delegate.cellDidUpdate()
            }
        }
    }
    
}
