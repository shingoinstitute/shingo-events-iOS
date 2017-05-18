//
//  EventTableViewCell.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 9/23/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    var maxBannerImageWidth: CGFloat!
    
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    
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
            eventImageView.layer.cornerRadius = 5
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var event: SIEvent! { didSet { updateCell() } }
    
    var delegate: SICellDelegate?
    
    func updateCell() {
        
        eventNameLabel.text = event.name
        
        let dates = event.startDate.toDateString() + " - " + event.endDate.toDateString()
        eventDateRangeLabel.text = dates
        
    }
}







