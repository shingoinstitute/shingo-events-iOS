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
    
    let BUTTON_WIDTH: CGFloat = 110.0
    let BUTTON_HEIGHT: CGFloat = 110.0
    var appData:AppData!
    var sectionHeaders:[(Character, [SIExhibitor])]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // do some sorting
        sortResearchRecipientsByName()
        sortPrizeRecipientsByName()
        sortSpeakersByLastName()
        sortAffiliatesByName()
        
        contentView.backgroundColor = .clearColor()
        eventNameLabel.backgroundColor = SIColor().prussianBlueColor.colorWithAlphaComponent(0.5)
        eventNameLabel.textColor = UIColor.whiteColor()
        
        eventNameLabel.text = appData.event.name
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
        if sectionHeaders == nil {
            sectionHeaders = [(Character, [SIExhibitor])]()
            
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
                var exhibitorList = [SIExhibitor]()
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
                        var nextList = [SIExhibitor]()
                        nextList.append(appData.exhibitors[i])
                        sectionHeaders.append((char, nextList))
                        count += 1
                    }
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SchedulesView" {
            let destination = segue.destinationViewController as! SchedulesTableViewController
            self.appData.event.eventAgenda.agendaArray = sortWeekByDay(self.appData.event.eventAgenda.agendaArray)
            destination.event = appData.event
        }
        
        if segue.identifier == "SpeakerList" {
            let destination = segue.destinationViewController as! SpeakerListTableViewController
            destination.speakers = appData.event.eventSpeakers
        }
        
        if segue.identifier == "RecipientsView" {
            let destination = segue.destinationViewController as! RecipientsTableViewController
            destination.appData = appData
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
            var sectionInfo = [(String, [SIAffiliate])]()
            
            if var char:String = String(appData.affiliates[0].name.characters.first!) {
                var affiliateList = [SIAffiliate]()
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
                        var nextList = [SIAffiliate]()
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
            let destination = segue.destinationViewController as! VenueMapsCollectionView
            destination.venueMaps = appData.event.venueMaps
        }
        
        if segue.identifier == "SponsorsView" {
            let destination = segue.destinationViewController as! SponsorsTableViewController
            destination.friends = appData.friendSponsors            //sponsorsArray[0]
            destination.supporters = appData.supportersSponsors     //sponsorsArray[1]
            destination.benefactors = appData.benefactorsSponsors   //sponsorsArray[2]
            destination.champions = appData.championsSponsors       //sponsorsArray[3]
            destination.presidents = appData.presidentsSponsors     //sponsorsArray[4]
        }
        
    }
    
    // MARK: - Custom Functions
    
    func sortWeekByDay(eventDayList:[SIEventDay]) -> [SIEventDay] {
        
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
        var speakers = appData.event.eventSpeakers
        if speakers.count > 1
        {
            for i in 0 ..< speakers.count - 1
            {
                for j in 0 ..< speakers.count - i - 1
                {
                    let name1 = speakers[j].name.characters.split{$0 == " "}.map(String.init);
                    let name2 = speakers[j+1].name.characters.split{$0 == " "}.map(String.init);
                    if name1.last > name2.last
                    {
                        let temp = speakers[j]
                        speakers[j] = speakers[j+1]
                        speakers[j+1] = temp
                    }
                }
            }
            appData.event.eventSpeakers = speakers
        }
        
    }
    
    func sortResearchRecipientsByName() {
        var researchRecipients = appData.researchRecipients
        if researchRecipients.count > 1
        {
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
        
    }
    
    func sortPrizeRecipientsByName() {
        var prizeRecipients = appData.shingoPrizeRecipients
        if prizeRecipients.count > 1
        {
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
        
    }
 
    func sortAffiliatesByName() {
        var affiliates = appData.affiliates
        if affiliates.count > 1
        {
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
}


