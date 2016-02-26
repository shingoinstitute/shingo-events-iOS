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
        view.image = UIImage(named: "shingo_icon_skinny")
        return view
    }()
    
    var appData:AppData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        for button in buttonViews
        {
            contentView.addSubview(button as! UIButton)
        }
        
        // Set height and width constraints for buttons
        for button in buttonViews
        {
            let widthConstraint = NSLayoutConstraint(
                item: button,
                attribute: NSLayoutAttribute.Width,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1,
                constant: 110)
            
            let heightConstraint = NSLayoutConstraint(
                item: button,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1,
                constant: 110)
            
            contentView.addConstraint(widthConstraint)
            contentView.addConstraint(heightConstraint)
        }
        
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
        
        let quarter = contentView.frame.width * 0.25 // calculate 1/4 width of parent view

        var horizontalConstraint = NSLayoutConstraint(
            item: leftButtons.firstObject as! UIButton,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: contentView,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1,
            constant: quarter * -1 + 10)
        contentView.addConstraint(horizontalConstraint)
        
        var verticalConstraint = NSLayoutConstraint(
            item: leftButtons.firstObject as! UIButton,
            attribute: NSLayoutAttribute.Top,
            relatedBy: .Equal,
            toItem: eventNameLabel,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: 10.0)
        contentView.addConstraint(verticalConstraint)
        
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
    
    @IBAction func didTapSchedule(sender: AnyObject) {
        self.performSegueWithIdentifier("SchedulesView", sender: self)
    }
    
    @IBAction func didTapSpeakers(sender: AnyObject) {
        self.performSegueWithIdentifier("SpeakerList", sender: self)
    }
    
    @IBAction func didTapRecipients(sender: AnyObject) {
        self.performSegueWithIdentifier("RecipientsView", sender: self)
    }
    
    @IBAction func didTapCityMap(sender: AnyObject) {
        self.performSegueWithIdentifier("MapView", sender: self)
    }
    
    @IBAction func didTapExhibitors(sender: AnyObject) {
        let activity = ActivityViewController(message: "Getting info")
        presentViewController(activity, animated: true, completion: nil)
        
        var imageFetchNotComplete = false
        
        // Super complicated way to calculate 2.0 seconds for a timeout timer
        let stopTime:NSTimeInterval = abs(NSTimeIntervalSince1970.distanceTo(2.0)) - NSTimeIntervalSince1970
        var counter = 0.0
        var timer = NSTimer()
        timer = NSTimer.every(0.1) {
            
            counter += timer.timeInterval
            imageFetchNotComplete = false
            for exhibitor in (self.appData.exhibitors)!
            {
                if exhibitor.logo_image == nil
                {
                    if exhibitor.logo_url != nil
                    {
                        print(exhibitor.logo_url)
                    }
                    else
                    {
                        print("NULL Exhibitor url found.")
                    }
                    imageFetchNotComplete = true
                }
            }
            
            // segues if imageFetchNotComplete is false (meaning all exhibitors have an image assigned)
            // or if more than 2 seconds have elapsed. During the loop caused by this closure, async
            // calls are working in the background that are attempting to fetch images for each exhibitor.
            // If the http request for each exhibitor fails to return an image OR if more than 2 seconds
            // have elapsed then their image will be assigned a placeholder image.
            if !imageFetchNotComplete || counter > abs(stopTime) {
                timer.invalidate()
                
                for exhibitor in (self.appData.exhibitors)!
                {
                    if exhibitor.logo_image == nil
                    {
                        exhibitor.logo_image = UIImage(named: "sponsor_banner_pl")
                    }
                }
                self.dismissViewControllerAnimated(true, completion: nil)
                self.performSegueWithIdentifier("ExhibitorsListView", sender: self)
            }
        }
        
    }
    
    @IBAction func didTapAffiliates(sender: AnyObject) {
        self.performSegueWithIdentifier("AffiliatesListView", sender: self)
    }
    
    @IBAction func didTapVenue(sender: AnyObject) {
        self.performSegueWithIdentifier("VenueView", sender: self)
    }
    
    @IBAction func didTapSponsors(sender: AnyObject) {
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

























