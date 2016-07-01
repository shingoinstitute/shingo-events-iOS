//
//  EventDetailsViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/8/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import MapKit
import PureLayout

class EventMenuViewController: UIViewController {
    
    var event : SIEvent!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let speakerButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Speaker_Button"), forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let scheduleButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Schedule_Button"), forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let affiliatesButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Affiliates_Button"), forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let exhibitorsButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Exhibitors_Button"), forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let recipientsButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Recipients_Button"), forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let directionsButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Directions_Button"), forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let sponsorsButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Sponsors_Button"), forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let venuePhotosButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Venue_Pictures_Button"), forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var backgroundImage: UIImageView = {
        let view = UIImageView.newAutoLayoutView()
        view.image = ShingoIconImages().shingoIconForDevice()
        return view
    }()
    
    let BUTTON_WIDTH: CGFloat = 110.0
    let BUTTON_HEIGHT: CGFloat = 110.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if event == nil {
            fatalError()
        }
        
        // do some sorting
        sortResearchRecipientsByName()
        sortPrizeRecipientsByName()
        sortSpeakersByLastName()
        sortAffiliatesByName()
        
        contentView.backgroundColor = .clearColor()
        eventNameLabel.backgroundColor = SIColor().prussianBlueColor.colorWithAlphaComponent(0.5)
        eventNameLabel.textColor = UIColor.whiteColor()
        
        eventNameLabel.text = event.name
        contentView.addSubview(eventNameLabel)
        contentView.addSubview(backgroundImage)
        
        let buttonViews = [
            scheduleButton,
            venuePhotosButton,
            recipientsButton,
            exhibitorsButton,
            speakerButton,
            directionsButton,
            affiliatesButton,
            sponsorsButton
        ]
        
        // add label and custom built UIButtons to contentView
        contentView.bringSubviewToFront(eventNameLabel)
        for button in buttonViews {
            contentView.addSubview(button)
            contentView.bringSubviewToFront(button)
            
            // set dimensions of buttons
            button.autoSetDimension(.Height, toSize: BUTTON_WIDTH)
            button.autoSetDimension(.Width, toSize: BUTTON_HEIGHT)
        }

        // constraints for view
        backgroundImage.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
        backgroundImage.autoPinEdge(.Left, toEdge: .Left, ofView: view)
        backgroundImage.autoPinEdge(.Right, toEdge: .Right, ofView: view)
        backgroundImage.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: view)
        
        // Add targets to all buttons
        scheduleButton.addTarget(self, action: #selector(EventMenuViewController.didTapSchedule(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        venuePhotosButton.addTarget(self, action: #selector(EventMenuViewController.didTapVenue(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        recipientsButton.addTarget(self, action: #selector(EventMenuViewController.didTapRecipients(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        exhibitorsButton.addTarget(self, action: #selector(EventMenuViewController.didTapExhibitors(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        speakerButton.addTarget(self, action: #selector(EventMenuViewController.didTapSpeakers(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        directionsButton.addTarget(self, action: #selector(EventMenuViewController.didTapDirections(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        affiliatesButton.addTarget(self, action: #selector(EventMenuViewController.didTapAffiliates(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        sponsorsButton.addTarget(self, action: #selector(EventMenuViewController.didTapSponsors(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        setButtonConstraintsToBottomOfView()
        eventNameLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: scheduleButton, withOffset: -12)
        
    }
    
    func displayBadRequestNotification() {
        let alert = UIAlertController(title: "Oops!",
                                      message: "We were unable to fetch any data for you. Please make sure you have an internet connection.",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // constraints for UIButtons
    func setButtonConstraintsToBottomOfView() {
        
        // calculate button spacing from edge
        let edgeSpacing = (view.frame.width * (1/4)) - (BUTTON_WIDTH / 2) + 10
        let verticalButtonSpacing: CGFloat = -10
        
        // Set up constraints from bottom left to top right
        exhibitorsButton.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: contentView, withOffset: verticalButtonSpacing)
        exhibitorsButton.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: edgeSpacing)
        
        sponsorsButton.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: contentView, withOffset: verticalButtonSpacing)
        sponsorsButton.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -edgeSpacing)
        
        recipientsButton.autoPinEdge(.Bottom, toEdge: .Top, ofView: exhibitorsButton, withOffset: verticalButtonSpacing)
        recipientsButton.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: edgeSpacing)
        
        affiliatesButton.autoPinEdge(.Bottom, toEdge: .Top, ofView: sponsorsButton, withOffset: verticalButtonSpacing)
        affiliatesButton.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -edgeSpacing)
        
        venuePhotosButton.autoPinEdge(.Bottom, toEdge: .Top, ofView: recipientsButton, withOffset: verticalButtonSpacing)
        venuePhotosButton.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: edgeSpacing)
        
        directionsButton.autoPinEdge(.Bottom, toEdge: .Top, ofView: affiliatesButton, withOffset: verticalButtonSpacing)
        directionsButton.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -edgeSpacing)
        
        scheduleButton.autoPinEdge(.Bottom, toEdge: .Top, ofView: venuePhotosButton, withOffset: verticalButtonSpacing)
        scheduleButton.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: edgeSpacing)
        
        speakerButton.autoPinEdge(.Bottom, toEdge: .Top, ofView: directionsButton, withOffset: verticalButtonSpacing)
        speakerButton.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -edgeSpacing)
    }
    
    func didTapSchedule(sender: AnyObject) {
        
        SIRequest().requestDays(eventId: event.id, callback: { agenda in
          
            guard let agenda = agenda else {
                self.displayBadRequestNotification()
                return
            }
            
            self.performSegueWithIdentifier("SchedulesView", sender: agenda)
            
        })

    }
    
    func didTapSpeakers(sender: AnyObject) {
        self.performSegueWithIdentifier("SpeakerList", sender: self)
    }
    
    func didTapRecipients(sender: AnyObject) {
        self.performSegueWithIdentifier("RecipientsView", sender: self)
    }
    
    func didTapDirections(sender: AnyObject) {
        self.performSegueWithIdentifier("MapView", sender: self)
    }
    
    func didTapExhibitors(sender: AnyObject) {
        self.performSegueWithIdentifier("ExhibitorsListView", sender: self)
    }
    
    func didTapAffiliates(sender: AnyObject) {
        self.performSegueWithIdentifier("AffiliatesListView", sender: self)
    }
    
    func didTapVenue(sender: AnyObject) {
        self.performSegueWithIdentifier("VenueView", sender: self)
    }
    
    func didTapSponsors(sender: AnyObject) {
        self.performSegueWithIdentifier("SponsorsView", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SchedulesView" {
            let destination = segue.destinationViewController as! SchedulesTableViewController
            destination.agenda = sender as! [SIAgenda]
            destination.eventName = self.event.name
        }
        
        if segue.identifier == "SpeakerList" {
            let destination = segue.destinationViewController as! SpeakerListTableViewController
            // send something
        }
        
        if segue.identifier == "RecipientsView" {
            let destination = segue.destinationViewController as! RecipientsTableViewController
            // send something
        }
        
        if segue.identifier == "MapView" {
            let destination = segue.destinationViewController as! MapViewController
            // send something
        }
        
        if segue.identifier == "ExhibitorsListView" {
            let destination = segue.destinationViewController as! ExhibitorTableViewController
            // do stuff...
        }
        
        if segue.identifier == "AffiliatesListView" {
            let destination = segue.destinationViewController as! AffiliateListTableViewController
            // do stuff...
        }
        
        if segue.identifier == "VenueView" {
            let destination = segue.destinationViewController as! VenueMapsCollectionView
            // Send something
        }
        
        if segue.identifier == "SponsorsView" {
            let destination = segue.destinationViewController as! SponsorsTableViewController
        }
        
    }
    
    // MARK: - Custom Functions
    
    func sortWeekByDay(eventDayList:[SIAgenda]) -> [SIAgenda] {
        
        var days = eventDayList
        
        for i in 0 ..< days.count - 1 {
            
            for j in 0 ..< (days.count - i - 1) {
            
                if days[j].isOnLaterDay(days[j+1]) {
                    let temp = days[j]
                    days[j] = days[j+1]
                    days[j+1] = temp
                }
            }
        }
        
        return days
    }
    
    
    // Some simple bubble sorting functions
    func sortSpeakersByLastName() {
        
    }
    
    func sortResearchRecipientsByName() {

    }
    
    func sortPrizeRecipientsByName() {
        
    }
 
    func sortAffiliatesByName() {

    }
}


