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

    var eventSpeakers = [String : SISpeaker]()
    
    var activityVC : ActivityViewController = {
        let view = ActivityViewController()
        view.modalPresentationStyle = .OverCurrentContext
        return view
    }()
    
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
    
    override func loadView() {
        super.loadView()
        
        // Load Agenda
        // Note: requestAgendas will request session data underneath
        event.requestAgendas() {self.event.didLoadAgendas = true}
        
        // Load Speakers for entire event
        event.requestSpeakers() {self.event.didLoadSpeakers = true}
        
        // Load venue photos
        event.requestVenues() {self.event.didLoadVenues = true}
        
        // Load Recipient information
        event.requestRecipients() {self.event.didLoadRecipients  = true}
        
        // Load Affiliate information
        event.requestAffiliates() {self.event.didLoadAffiliates = true}
        
        // Load Exhibitor information
        event.requestExhibitors() {self.event.didLoadExhibitors = true}
        
        // Load Sponsor information
        event.requestSponsors() {
            self.event.didLoadSponsors = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        definesPresentationContext = true
        providesPresentationContextTransitionStyle = true
        
        // Sorting
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
    
    
}

extension EventMenuViewController {
    
    // MARK: - Button Outlet functions
    func didTapSchedule(sender: AnyObject) {
        if event.didLoadAgendas {
            self.performSegueWithIdentifier("SchedulesView", sender: self.event.agendaItems)
        } else {
            self.presentViewController(activityVC, animated: false, completion: { 
                self.event.requestAgendas() {
                    self.dismissViewControllerAnimated(true, completion: { 
                        self.performSegueWithIdentifier("SchedulesView", sender: self.event.agendaItems)
                    });
                }
            });
        }
    }
    
    func didTapSpeakers(sender: AnyObject) {
        if event.didLoadSpeakers  {
            self.performSegueWithIdentifier("SpeakerList", sender: self.eventSpeakers)
        } else {
            self.presentViewController(activityVC, animated: false, completion: { 
                self.event.requestSpeakers() {
                    self.dismissViewControllerAnimated(true, completion: { 
                        self.performSegueWithIdentifier("SpeakerList", sender: self.eventSpeakers)
                    });
                }
            });
        }
    }
    
    func didTapRecipients(sender: AnyObject) {
        if event.didLoadRecipients {
            self.performSegueWithIdentifier("RecipientsView", sender: self.event.recipients)
        } else {
            self.presentViewController(activityVC, animated: false, completion: {
                self.event.requestRecipients() {
                    self.dismissViewControllerAnimated(true, completion: { 
                        self.performSegueWithIdentifier("RecipientsView", sender: self.event.recipients)
                    });
                }
            });
        }
    }
    
    //TODO: Create screen on segue that shows more than the first potentially available venue
    func didTapDirections(sender: AnyObject) {
        if event.didLoadVenues {
            if let venue = self.event.venues.first {
                self.performSegueWithIdentifier("MapView", sender: venue)
            }
        } else {
            self.presentViewController(activityVC, animated: false, completion: { 
                self.event.requestVenues({
                    self.dismissViewControllerAnimated(true, completion: {
                        if let venue = self.event.venues.first {
                            self.performSegueWithIdentifier("MapView", sender: venue)
                        }
                    });
                });
            });
        }
    }
    
    func didTapExhibitors(sender: AnyObject) {
        if event.didLoadExhibitors {
            self.performSegueWithIdentifier("ExhibitorsListView", sender: self.event.exhibitors)
        } else {
            self.presentViewController(activityVC, animated: false, completion: {
                self.event.requestExhibitors({
                    self.dismissViewControllerAnimated(true, completion: {
                        self.performSegueWithIdentifier("ExhibitorsListView", sender: self.event.exhibitors)
                    })
                });
            });
        }
    }
    
    func didTapAffiliates(sender: AnyObject) {
        
        if event.didLoadAffiliates {
            self.performSegueWithIdentifier("AffiliatesListView", sender: self.event.affiliates)
        } else {
            self.presentViewController(activityVC, animated: false, completion: {
                self.event.requestAffiliates() {
                    self.dismissViewControllerAnimated(true, completion: {
                        self.performSegueWithIdentifier("AffiliatesListView", sender: self.event.affiliates)
                    });
                }
            });
        }
    }
    
    func didTapVenue(sender: AnyObject) {
        
        if event.didLoadVenues {
            self.performSegueWithIdentifier("VenueView", sender: self.event.venues)
        } else {
            self.presentViewController(activityVC, animated: false, completion: {
                self.event.requestVenues() {
                    self.dismissViewControllerAnimated(true, completion: {
                        self.performSegueWithIdentifier("VenueView", sender: self.event.venues)
                    });
                }
            });
        }
    }
    
    func didTapSponsors(sender: AnyObject) {
        
        if event.didLoadSponsors {
            self.performSegueWithIdentifier("SponsorsView", sender: self.event.sponsors)
        } else {
            self.presentViewController(activityVC, animated: false, completion: {
                self.event.requestSponsors {
                    self.dismissViewControllerAnimated(true, completion: {
                        self.performSegueWithIdentifier("SponsorsView", sender: self.event.sponsors)
                    });
                }
            });
        }
    }
    
}

extension EventMenuViewController {
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SchedulesView" {
            let destination = segue.destinationViewController as! SchedulesTableViewController
            sortAgendaDays()
            destination.agendas = event.agendaItems
            destination.eventName = event.name
        }
        
        if segue.identifier == "SpeakerList" {
            let destination = segue.destinationViewController as! SpeakerListTableViewController
            destination.speakers = self.sortSpeakersByLastName()
        }
        
        if segue.identifier == "RecipientsView" {
            let destination = segue.destinationViewController as! RecipientsTableViewController
            if let recipients = sender as? [SIRecipient] {
                destination.recipients = recipients
            }
        }
        
        if segue.identifier == "MapView" {
            let destination = segue.destinationViewController as! MapViewController
            if let venue = sender as? SIVenue {
                if let location = venue.location {
                    destination.location = location
                }
            }
        }
        
        if segue.identifier == "ExhibitorsListView" {
            let destination = segue.destinationViewController as! ExhibitorTableViewController
            if let exhibitors = sender as? [SIExhibitor] {
                destination.exhibitors = exhibitors
            }
        }
        
        if segue.identifier == "AffiliatesListView" {
            let destination = segue.destinationViewController as! AffiliateListTableViewController
            if let affiliates = sender as? [SIAffiliate] {
                
                // Populate section headers so affiliates can be presented alphabetically in seperate tableView sections
                var sections = [String : [SIAffiliate]]()
                
                for affiliate in affiliates {
                    
                    // Get first letter of affiliate name
                    
                    let fullName : [String?] = affiliate.name.split(" ")
                    var name = ""
                    if let first = fullName[0] {
                        if first.lowercaseString == "the" {
                            if let second = fullName[1] {
                                name = second
                            }
                        } else {
                            name = first
                        }
                    }
                    
                    let char : Character = name.characters.first!
                    var value : String = String(char).uppercaseString
                    // If affiliate name begins with a number, change to the # character
                    if Int(value) != nil {
                        value = "#"
                    }
                    
                    // Add to dictionary
                    if var section = sections[value] {
                        section.append(affiliate)
                        sections[value] = section
                    } else {
                        sections[value] = [affiliate]
                    }
                }
                
                var affiliateSections = [(String, [SIAffiliate])]()
                
                if let section = sections["A"] {
                    affiliateSections.append(("A", section))
                }
                if let section = sections["B"] {
                    affiliateSections.append(("B", section))
                }
                if let section = sections["C"] {
                    affiliateSections.append(("C", section))
                }
                if let section = sections["D"] {
                    affiliateSections.append(("D", section))
                }
                if let section = sections["E"] {
                    affiliateSections.append(("E", section))
                }
                if let section = sections["F"] {
                    affiliateSections.append(("F", section))
                }
                if let section = sections["G"] {
                    affiliateSections.append(("G", section))
                }
                if let section = sections["H"] {
                    affiliateSections.append(("H", section))
                }
                if let section = sections["I"] {
                    affiliateSections.append(("I", section))
                }
                if let section = sections["J"] {
                    affiliateSections.append(("J", section))
                }
                if let section = sections["K"] {
                    affiliateSections.append(("K", section))
                }
                if let section = sections["L"] {
                    affiliateSections.append(("L", section))
                }
                if let section = sections["M"] {
                    affiliateSections.append(("M", section))
                }
                if let section = sections["N"] {
                    affiliateSections.append(("N", section))
                }
                if let section = sections["O"] {
                    affiliateSections.append(("O", section))
                }
                if let section = sections["P"] {
                    affiliateSections.append(("P", section))
                }
                if let section = sections["Q"] {
                    affiliateSections.append(("Q", section))
                }
                if let section = sections["R"] {
                    affiliateSections.append(("R", section))
                }
                if let section = sections["S"] {
                    affiliateSections.append(("S", section))
                }
                if let section = sections["T"] {
                    affiliateSections.append(("T", section))
                }
                if let section = sections["U"] {
                    affiliateSections.append(("U", section))
                }
                if let section = sections["V"] {
                    affiliateSections.append(("V", section))
                }
                if let section = sections["W"] {
                    affiliateSections.append(("W", section))
                }
                if let section = sections["X"] {
                    affiliateSections.append(("X", section))
                }
                if let section = sections["Y"] {
                    affiliateSections.append(("Y", section))
                }
                if let section = sections["Z"] {
                    affiliateSections.append(("Z", section))
                }
                if let section = sections["#"] {
                    affiliateSections.append(("#", section))
                }
                
                destination.affiliateSections = affiliateSections
            }
        }
        
        
        
        if segue.identifier == "VenueView" {
            let destination = segue.destinationViewController as! VenueMapsCollectionView
            destination.venue = self.event.venues[0]
        }
        
        if segue.identifier == "SponsorsView" {
            let destination = segue.destinationViewController as! SponsorsTableViewController
            if let sponsors = sender as? [SISponsor] {
                
                var sponsorTypes = [
                    [SISponsor](),
                    [SISponsor](),
                    [SISponsor](),
                    [SISponsor](),
                    [SISponsor]()
                ]
                
                for s in sponsors {
                    if s.sponsorType == .Friend {
                        sponsorTypes[0].append(s)
                    } else if s.sponsorType == .Supporter {
                        sponsorTypes[1].append(s)
                    } else if s.sponsorType == .Benefactor {
                        sponsorTypes[2].append(s)
                    } else if s.sponsorType == .Champion {
                        sponsorTypes[3].append(s)
                    } else if s.sponsorType == .President {
                        sponsorTypes[4].append(s)
                    }
                }
                
                destination.friends = sponsorTypes[0]
                destination.supporters = sponsorTypes[1]
                destination.benefactors = sponsorTypes[2]
                destination.champions = sponsorTypes[3]
                destination.presidents = sponsorTypes[4]
            }
        }
        
    }
}

extension EventMenuViewController {

    // MARK: - Custom Class Functions
    func sortAgendaDays() {
        
        for i in 0 ..< event.agendaItems.count - 1 {
            
            for n in 0 ..< event.agendaItems.count - i - 1 {
                
                if event.agendaItems[n].date.isGreaterThanDate(event.agendaItems[n+1].date) {
                    let day = event.agendaItems[n]
                    event.agendaItems[n] = event.agendaItems[n+1]
                    event.agendaItems[n+1] = day
                }
            }
        }
    }
    
    func sortSpeakersByLastName() -> [SISpeaker]{
        var speakers = Array(event.speakers.values)
        if speakers.isEmpty { return [SISpeaker]() }
        for i in 0 ..< speakers.count - 1 {
            
            for n in 0 ..< speakers.count - i - 1 {
                
                if speakers[n].getLastName() > speakers[n+1].getLastName() {
                    let speaker = speakers[n]
                    speakers[n] = speakers[n+1]
                    speakers[n+1] = speaker
                }
                
            }
            
        }
        
        return speakers
    }
    
    //TO-DO: Needs implementation
    func sortResearchRecipientsByName() {
    }
    
    //TO-DO: Needs implementation
    func sortPrizeRecipientsByName() {
    }
 
    //TO-DO: Needs implementation
    func sortAffiliatesByName() {
    }
}


