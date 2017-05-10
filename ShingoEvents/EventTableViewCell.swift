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
    
    var event: SIEvent! { didSet { updateCell() } }
    
    var delegate: SICellDelegate?
    
    func updateCell() {
        
        event.tableViewCellDelegate = self
        
        eventNameLabel.text = event.name
        
        let dates = event.startDate.toString() + " - " + event.endDate.toString()
        eventDateRangeLabel.text = dates
        
        if eventImageView.image == nil || eventImageView.image == #imageLiteral(resourceName: "FlameOnly-100") {
            event.getImage({ (image) in
                if let image = image {
                    self.event.image = image
                }
            })
        }
        
        onEventDetailCompletion()
        
    }
}

extension EventTableViewCell: SIEventDelegate {
    
    func onEventDetailCompletion() {
        DispatchQueue.main.async {
            self.eventDescriptionLabel.attributedText = SIRequest.parseHTMLStringUsingPreferredFont(string: self.event.salesText, forTextStyle: .subheadline)
            if let delegate = self.delegate {
                delegate.cellDidUpdate()
            }
        }
        
    }
}







