//
//  EventTableViewCell.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 9/23/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateRangeLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    
    var event: SIEvent! { didSet { updateCell() } }
    
    var delegate: SICellDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        cardView = UIView.newAutoLayout()
        cardView.layer.cornerRadius = 10
        
        eventNameLabel = UILabel.newAutoLayout()
        eventNameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        
        eventDateRangeLabel = UILabel.newAutoLayout()
        eventDateRangeLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
        eventImageView = UIImageView.newAutoLayout()
        eventImageView.contentMode = .scaleAspectFit
        eventImageView.layer.cornerRadius = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    func updateCell() {
        
        backgroundColor = .clear
        selectionStyle = .none
        
        guard let event = event else {
            return
        }
        
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
            self.eventImageView.scaleImageIntrinsicContentSize(toFitWidth: self.imageViewWidthConstraint.constant);
            
            if let delegate = self.delegate {
                delegate.cellDidUpdate()
            }
        }
    }
    
}
