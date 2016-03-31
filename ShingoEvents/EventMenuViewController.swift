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
    
    var appData:AppData!
    var sectionHeaders:[(Character, [Exhibitor])]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // do some sorting! Yay!
        sortResearchRecipientsByName()
        sortPrizeRecipientsByName()
        sortSpeakersByFirstName()
        sortAffiliatesByName()
        
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
        
        // height and width constraints for buttons
        for button in buttonViews
        {
            button.autoSetDimension(.Height, toSize: 110)
            button.autoSetDimension(.Width, toSize: 110)
        }
        
        // constraints for view
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
        scheduleButton.addTarget(self, action: #selector(EventMenuViewController.didTapSchedule(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        venuePhotosButton.addTarget(self, action: #selector(EventMenuViewController.didTapVenue(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        recipientsButton.addTarget(self, action: #selector(EventMenuViewController.didTapRecipients(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        exhibitorsButton.addTarget(self, action: #selector(EventMenuViewController.didTapExhibitors(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        speakerButton.addTarget(self, action: #selector(EventMenuViewController.didTapSpeakers(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        directionsButton.addTarget(self, action: #selector(EventMenuViewController.didTapDirections(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        affiliatesButton.addTarget(self, action: #selector(EventMenuViewController.didTapAffiliates(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        sponsorsButton.addTarget(self, action: #selector(EventMenuViewController.didTapSponsors(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        setButtonConstraints()
        
    }
    
    // constraints for UIButtons
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
        // Ensure each exhibitor has an image assigned to it
//        if sectionHeaders == nil
//        {
            sectionHeaders = [(Character, [Exhibitor])]()
            
            for exhibitor in self.appData.exhibitors
            {
                if exhibitor.logo_image == nil
                {
                    exhibitor.logo_image = UIImage(named: "sponsor_banner_pl")
                }
            }
            
            // Alphabetically sort exhibitors by company name
            for i in 0 ..< appData.exhibitors.count - 1
            {
                for j in 0 ..< appData.exhibitors.count - i - 1
                {
                    if appData.exhibitors[j].name > appData.exhibitors[j+1].name
                    {
                        let temp = appData.exhibitors[j]
                        appData.exhibitors[j] = appData.exhibitors[j+1]
                        appData.exhibitors[j+1] = temp
                    }
                }
            }
            

            // Create dictionary to set section headers in ExhibitorTableViewController
            if var char = appData.exhibitors[0].name.characters.first {
                var exhibitorList = [Exhibitor]()
                exhibitorList.append(appData.exhibitors[0])
                sectionHeaders.append((char, exhibitorList))
                var count = 0
                for i in 1 ..< appData.exhibitors.count
                {
                    char = appData.exhibitors[i].name.characters.first!
                    if char == sectionHeaders[count].0
                    {
                        sectionHeaders[count].1.append(appData.exhibitors[i])
                    }
                    else
                    {
                        var nextList = [Exhibitor]()
                        nextList.append(appData.exhibitors[i])
                        sectionHeaders.append((char, nextList))
                        count += 1
                    }
                }
            }
            
//        }
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
            destination.sectionInformation = self.sectionHeaders
            destination.exhibitors = self.appData.exhibitors
        }
        
        if segue.identifier == "AffiliatesListView" {
            var sectionInfo = [(String, [Affiliate])]()
            
            if var char:String = String(appData.affiliates[0].name.characters.first!) {
                var affiliateList = [Affiliate]()
                affiliateList.append(appData.affiliates[0])
                sectionInfo.append((char, affiliateList))
                var count = 0
                for i in 1 ..< appData.affiliates.count
                {
                    let affiliate = appData.affiliates[i]
                    char = String(affiliate.name.characters.first!)
                    if char == sectionInfo[count].0
                    {
                        sectionInfo[count].1.append(appData.affiliates[i])
                    }
                    else
                    {
                        var nextList = [Affiliate]()
                        nextList.append(appData.affiliates[i])
                        sectionInfo.append((char, nextList))
                        count += 1
                    }
                }
            }
            
            let destination = segue.destinationViewController as! AffiliateListTableViewController
            destination.affiliates = self.appData.affiliates
            destination.sectionInfo = sectionInfo
            
        }
        
        if segue.identifier == "VenueView" {
            let destination = segue.destinationViewController as! VenueMapsViewController
            destination.event = appData.event
            
        }
        
        if segue.identifier == "SponsorsView" {
            let destination = segue.destinationViewController as! SponsorsTableViewController
//            let sponsors_array = self.numberOfEachSponsorType(self.appData!.sponsors!)
            destination.friends = appData.friendSponsors//sponsors_array[0]
            destination.supporters = appData.supportersSponsors //sponsors_array[1]
            destination.benefactors = appData.benefactorsSponsors //sponsors_array[2]
            destination.champions = appData.championsSponsors //sponsors_array[3]
            destination.presidents = appData.presidentsSponsors //sponsors_array[4]
        }
        
    }
    
    // MARK: - Custom Functions
    
    func sortWeekByDay(week:[EventDay]) -> [EventDay] {
        var days = week
        for i in 0 ..< days.count - 1
        {
            for j in 0 ..< (days.count - i - 1)
            {
                if valueOfDay(days[j].dayOfWeek) > valueOfDay(days[j+1].dayOfWeek)
                {
                    let temp = days[j]
                    days[j] = days[j+1]
                    days[j+1] = temp
                }
            }
        }
        return days
    }
    
    func valueOfDay(day:String) -> Int {
        let day = day.lowercaseString
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
    
//    func numberOfEachSponsorType(sponsors:[Sponsor]) -> [[Sponsor]] {
//        
//        var sponsors_array = [[Sponsor](), [Sponsor](), [Sponsor](), [Sponsor](), [Sponsor]()]
//        
//        for item in sponsors {
//            if item.sponsor_type == .Friend {
//                sponsors_array[0].append(item)
//            }
//            else if item.sponsor_type == .Supporter {
//                sponsors_array[1].append(item)
//            }
//            else if item.sponsor_type == .Benefactor {
//                sponsors_array[2].append(item)
//            }
//            else if item.sponsor_type == .Champion {
//                sponsors_array[3].append(item)
//            }
//            else if item.sponsor_type == .President {
//                sponsors_array[4].append(item)
//            }
//        }
//        return sponsors_array
//    }
    
    // Some simple bubble sorting functions
    func sortSpeakersByFirstName() {
        var speakers = appData.event.speakers
        for i in 0 ..< speakers.count - 1
        {
            for j in 0 ..< speakers.count - i - 1
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
    
    func sortResearchRecipientsByName() {
        var researchRecipients = appData.researchRecipients
        for i in 0 ..< researchRecipients.count - 1
        {
            for j in 0 ..< researchRecipients.count - i - 1
            {
                if researchRecipients[j].name > researchRecipients[j+1].name
                {
                    let temp = researchRecipients[j]
                    researchRecipients[j] = researchRecipients[j+1]
                    researchRecipients[j+1] = temp
                }
            }
        }
        appData.researchRecipients = researchRecipients
    }
    
    func sortPrizeRecipientsByName() {
        var prizeRecipients = appData.shingoPrizeRecipients
        for i in 0 ..< prizeRecipients.count - 1
        {
            for j in 0 ..< prizeRecipients.count - i - 1
            {
                if prizeRecipients[j].name > prizeRecipients[j+1].name
                {
                    let temp = prizeRecipients[j]
                    prizeRecipients[j] = prizeRecipients[j+1]
                    prizeRecipients[j+1] = temp
                }
            }
        }
        appData.shingoPrizeRecipients = prizeRecipients
    }
 
    func sortAffiliatesByName() {
        var affiliates = appData.affiliates
        for i in 0 ..< affiliates.count - 1
        {
            for j in 0 ..< affiliates.count - i - 1
            {
                if affiliates[j].name > affiliates[j+1].name
                {
                    let temp = affiliates[j]
                    affiliates[j] = affiliates[j+1]
                    affiliates[j+1] = temp
                }
            }
        }
        appData.affiliates = affiliates
    }
}

























