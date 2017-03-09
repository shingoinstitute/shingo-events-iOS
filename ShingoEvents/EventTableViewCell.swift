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
        let dates = "\(dateFormatter.string(from: event.startDate as Date)) - \(dateFormatter.string(from: event.endDate as Date))"
        eventDateRangeLabel.text = dates
        
        
        if let image = event.image {
            eventImageView.image = image
        } else {
            event.getBannerImage() { image in
                guard let image = image else {
                    self.eventImageView.image = #imageLiteral(resourceName: "FlameOnly-100")
                    return
                }
                self.eventImageView.image = image
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
