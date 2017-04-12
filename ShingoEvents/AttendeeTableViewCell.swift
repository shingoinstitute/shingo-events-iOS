//
//  AttendeeTableViewCell.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 10/10/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit

class AttendeeTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var organizationLabel: UILabel!
    
    @IBOutlet weak var attendeeImageView: UIImageView! {
        didSet {
            attendeeImageView.layer.cornerRadius = 3
        }
    }
    
    var attendee: SIAttendee! { didSet { updateCell() } }
    
    func updateCell() {
        
        
        
        if let attendee = attendee {
            nameLabel.text = attendee.name
            
            if !attendee.title.isEmpty && !attendee.organization.isEmpty {
                organizationLabel.text = "\(attendee.title), \(attendee.organization)"
            } else if attendee.title.isEmpty {
                organizationLabel.text = attendee.organization
            } else if attendee.organization.isEmpty {
                organizationLabel.text = attendee.title
            } else {
                organizationLabel.text = ""
            }
            
            attendee.getImage(callback: { (image) in
                self.attendeeImageView.image = image
            })
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
