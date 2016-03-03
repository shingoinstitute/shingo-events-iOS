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
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var speakerButton: UIButton!
//    @IBOutlet weak var scheduleButton: UIButton!
//    @IBOutlet weak var affiliatesButton: UIButton!
//    @IBOutlet weak var exhibitorsButton: UIButton!
//    @IBOutlet weak var recipientsButton: UIButton!
//    @IBOutlet weak var directionsButton: UIButton!
//    @IBOutlet weak var sponsorsButton: UIButton!
//    @IBOutlet weak var venuePhotosButton: UIButton!
//    
//    let eventNameLabel:UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
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
        view.image = ShingoIconImages().getShingoIconForDevice()
        return view
    }()
    
    var appData:AppData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.backgroundColor = .clearColor()
        
        eventNameLabel.text = appData.event.name
        contentView.addSubview(eventNameLabel)
        
        let buttonViews:NSArray = [
            scheduleButton,
            venuePhotosButton,
            recipientsButton,
            exhibitorsButton,
            speakerButton,
            directionsButton,
            affiliatesButton,
            sponsorsButton
        ]
        
        // add custom built UIButtons to contentView
        for button in buttonViews
        {
            contentView.addSubview(button as! UIButton)
        }
        
        // Set height and width constraints for buttons
        for button in buttonViews
        {
            button.autoSetDimension(.Height, toSize: 110)
            button.autoSetDimension(.Width, toSize: 110)
        }
        
        contentView.addSubview(backgroundImage)
        
        backgroundImage.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
        backgroundImage.autoPinEdge(.Left, toEdge: .Left, ofView: view)
        backgroundImage.autoPinEdge(.Right, toEdge: .Right, ofView: view)
        backgroundImage.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: view)
        
        contentView.bringSubviewToFront(eventNameLabel)
        contentView.bringSubviewToFront(scheduleButton)
        contentView.bringSubviewToFront(venuePhotosButton)
        contentView.bringSubviewToFront(recipientsButton)
        contentView.bringSubviewToFront(exhibitorsButton)
        contentView.bringSubviewToFront(speakerButton)
        contentView.bringSubviewToFront(directionsButton)
        contentView.bringSubviewToFront(affiliatesButton)
        contentView.bringSubviewToFront(sponsorsButton)
        
        // Add targets to all buttons
        scheduleButton.addTarget(self, action: "didTapSchedule:", forControlEvents: UIControlEvents.TouchUpInside)
        venuePhotosButton.addTarget(self, action: "didTapVenue:", forControlEvents: UIControlEvents.TouchUpInside)
        recipientsButton.addTarget(self, action: "didTapRecipients:", forControlEvents: UIControlEvents.TouchUpInside)
        exhibitorsButton.addTarget(self, action: "didTapExhibitors:", forControlEvents: UIControlEvents.TouchUpInside)
        speakerButton.addTarget(self, action: "didTapSpeakers:", forControlEvents: UIControlEvents.TouchUpInside)
        directionsButton.addTarget(self, action: "didTapDirections:", forControlEvents: UIControlEvents.TouchUpInside)
        affiliatesButton.addTarget(self, action: "didTapAffiliates:", forControlEvents: UIControlEvents.TouchUpInside)
        sponsorsButton.addTarget(self, action: "didTapSponsors:", forControlEvents: UIControlEvents.TouchUpInside)
        
        setButtonConstraints()
        
    }
    
    func setButtonConstraints() {
        
        let leftButtons:NSArray = [
            scheduleButton,
            venuePhotosButton,
            recipientsButton,
            exhibitorsButton,
        ]
        
        let rightButtons:NSArray = [
            speakerButton,
            directionsButton,
            affiliatesButton,
            sponsorsButton
        ]
        
        let quarter = self.view.frame.width * 0.25 // calculate 1/4 width of parent view

        var horizontalConstraint = NSLayoutConstraint(
            item: leftButtons.firstObject as! UIButton,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: contentView,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1,
            constant: quarter * -1 + 10.0)
        contentView.addConstraint(horizontalConstraint)
        
        var verticalConstraint = NSLayoutConstraint(
            item: leftButtons.firstObject as! UIButton,
            attribute: NSLayoutAttribute.Top,
            relatedBy: .Equal,
            toItem: eventNameLabel,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: 10.0)
        scrollView.addConstraint(verticalConstraint)
        
        var previousButton:UIButton!
        for item in leftButtons
        {
            if let previousButton = previousButton
            {
                let verticalConstraint = NSLayoutConstraint(
                    item: item,
                    attribute: NSLayoutAttribute.Top,
                    relatedBy: .Equal,
                    toItem: previousButton,
                    attribute: NSLayoutAttribute.Bottom,
                    multiplier: 1,
                    constant: 0)
                contentView.addConstraint(verticalConstraint)
                
                // Even numbered indecies get offset from center of contentView by (quarter * -1 + 10)
                let horizontalConstraint = NSLayoutConstraint(
                    item: item,
                    attribute: NSLayoutAttribute.CenterX,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: contentView,
                    attribute: NSLayoutAttribute.CenterX,
                    multiplier: 1,
                    constant: quarter * -1 + 10)
                contentView.addConstraint(horizontalConstraint)
            }
            previousButton = item as! UIButton
        }
        
        horizontalConstraint = NSLayoutConstraint(
            item: rightButtons.firstObject as! UIButton,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: contentView,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1,
            constant: quarter - 10)
        contentView.addConstraint(horizontalConstraint)
        
        verticalConstraint = NSLayoutConstraint(
            item: rightButtons.firstObject as! UIButton,
            attribute: NSLayoutAttribute.Top,
            relatedBy: .Equal,
            toItem: eventNameLabel,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: 10.0)
        contentView.addConstraint(verticalConstraint)
        
        previousButton = nil
        for item in rightButtons
        {
            if let previousButton = previousButton
            {
                let verticalConstraint = NSLayoutConstraint(
                    item: item,
                    attribute: NSLayoutAttribute.Top,
                    relatedBy: .Equal,
                    toItem: previousButton,
                    attribute: NSLayoutAttribute.Bottom,
                    multiplier: 1,
                    constant: 0)
                contentView.addConstraint(verticalConstraint)
                
                let horizontalConstraint = NSLayoutConstraint(
                    item: item,
                    attribute: NSLayoutAttribute.CenterX,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: contentView,
                    attribute: NSLayoutAttribute.CenterX,
                    multiplier: 1,
                    constant: quarter - 10)
                contentView.addConstraint(horizontalConstraint)
            }
            previousButton = item as! UIButton
        }
        
    }
    
    func didTapSchedule(sender: AnyObject) {
        self.performSegueWithIdentifier("SchedulesView", sender: self)
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
        for exhibitor in self.appData.exhibitors
        {
            if exhibitor.logo_image == nil
            {
                exhibitor.logo_image = UIImage(named: "sponsor_banner_pl")
            }
        }
        
        for (var i = 0; i < appData.exhibitors.count - 1; i++)
        {
            for (var j = 0; j < appData.exhibitors.count - i - 1; j++)
            {
                if appData.exhibitors[j].name > appData.exhibitors[j+1].name
                {
                    let temp = appData.exhibitors[j]
                    appData.exhibitors[j] = appData.exhibitors[j+1]
                    appData.exhibitors[j+1] = temp
                }
            }
        }
        
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SchedulesView" {
            let dest_vc = segue.destinationViewController as! SchedulesTableViewController
            self.appData.event?.eventAgenda.days_array = sortWeekByDay(self.appData!.event!.eventAgenda.days_array)
            dest_vc.event = self.appData!.event!
        }
        
        if segue.identifier == "SpeakerList" {
            sortSpeakersByFirstName()
            let dest_vc = segue.destinationViewController as! SpeakerListTableViewController
            dest_vc.speakers = appData.event.speakers
        }
        
        if segue.identifier == "RecipientsView" {
            let dest_vc = segue.destinationViewController as! RecipientsTableViewController
            dest_vc.appData = self.appData
        }
        
        if segue.identifier == "MapView" {
            let destination = segue.destinationViewController as! MapViewController
            destination.location = appData.event?.location
        }
        
        if segue.identifier == "ExhibitorsListView" {
            let destination = segue.destinationViewController as! ExhibitorTableViewController
            
            destination.exhibitors = self.appData.exhibitors
        }
        
        if segue.identifier == "AffiliatesListView" {
            let destination = segue.destinationViewController as! AffiliateListTableViewController
            destination.affiliates = self.appData.affiliates
            
        }
        
        if segue.identifier == "VenueView" {
            let destination = segue.destinationViewController as! VenueMapsViewController
            destination.event = appData.event
            
        }
        
        if segue.identifier == "SponsorsView" {
            let destination = segue.destinationViewController as! SponsorsTableViewController
            let sponsors_array = self.getAmountOfEachSponsorType(self.appData!.sponsors!)
            destination.friends = sponsors_array[0]
            destination.supporters = sponsors_array[1]
            destination.benefactors = sponsors_array[2]
            destination.champions = sponsors_array[3]
            destination.presidents = sponsors_array[4]
        }
        
    }
    
    // MARK: - Custom Functions
    
    func sortWeekByDay(var days_of_week:[EventDay]) -> [EventDay] {
        for(var i = 0; i < days_of_week.count - 1; i++)
        {
            for(var j = 0; j < days_of_week.count - i - 1; j++)
            {
                if valueOfDay(days_of_week[j].dayOfWeek) > valueOfDay(days_of_week[j+1].dayOfWeek)
                {
                    let temp = days_of_week[j]
                    days_of_week[j] = days_of_week[j+1]
                    days_of_week[j+1] = temp
                }
            }
        }
        return days_of_week
    }
    
    func valueOfDay(var day:String) -> Int {
        day = day.lowercaseString
        switch day {
        case "monday":
            return 1
        case "tuesday":
            return 2
        case "wednesday":
            return 3
        case "thursday":
            return 4
        case "friday":
            return 5
        case "saturday":
            return 6
        case "sunday":
            return 7
        default:
            print("ERROR: EventMenuViewController::valueOfDay, invalid string passed into parameter!")
            return 0
        }
    }
    
    func getAmountOfEachSponsorType(sponsors:[Sponsor]) -> [[Sponsor]] {
        var sponsors_array = [[Sponsor](),[Sponsor](),[Sponsor()],[Sponsor()],[Sponsor()]]
        var friends = [Sponsor]()
        var supporters = [Sponsor]()
        var benefactors = [Sponsor]()
        var champions = [Sponsor]()
        var presidents = [Sponsor]()
        
        for item in sponsors {
            if item.sponsor_type == .Friend {
                friends.append(item)
            }
            if item.sponsor_type == .Supporter {
                supporters.append(item)
            }
            if item.sponsor_type == .Benefactor {
                benefactors.append(item)
            }
            if item.sponsor_type == .Champion {
                champions.append(item)
            }
            if item.sponsor_type == .President {
                presidents.append(item)
            }
        }
        
        sponsors_array[0] = friends
        sponsors_array[1] = supporters
        sponsors_array[2] = benefactors
        sponsors_array[3] = champions
        sponsors_array[4] = presidents
        
        return sponsors_array
    }
    
    func sortSpeakersByFirstName()
    {
        var speakers = appData!.event!.speakers
        
        for (var i = 0; i < speakers.count - 1; i++)
        {
            for (var j = 0; j < speakers.count - i - 1; j++)
            {
                if speakers[j].display_name > speakers[j+1].display_name
                {
                    let temp = speakers[j]
                    speakers[j] = speakers[j+1]
                    speakers[j+1] = temp
                }
            }
        }
        appData.event.speakers = speakers
    }
    
}

























