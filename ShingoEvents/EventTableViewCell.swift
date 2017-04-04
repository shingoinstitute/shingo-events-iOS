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
        
        eventNameLabel.text = event.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateStyle = .medium
        let dates = event.startDate.toString() + " - " + event.endDate.toString()
        eventDateRangeLabel.text = dates
        
        
        if let image = event.image {
            eventImageView.image = image
            if let del = self.delegate {
                del.cellDidUpdate()
            }
        } else {
            event.getBannerImage() { image in
                
                if let image = image {
                    self.eventImageView.image = image
                } else {
                    self.eventImageView.image = #imageLiteral(resourceName: "FlameOnly-100")
                }
                if let delegate = self.delegate {
                    delegate.cellDidUpdate()
                }
            }
        }

    }
    
    func resizeImageToMaxWidth() {
        if let width = maxBannerImageWidth {
            if let image = imageView!.image {
                if image.size.width > width {
                    let newHeight = (image.size.height / image.size.width) * width
                    let size = CGSize(width: width, height: newHeight)
                    let resizedImg = image.af_imageScaled(to: size)
                    imageView!.image = resizedImg
                }
            }
        }
    }
    
}
