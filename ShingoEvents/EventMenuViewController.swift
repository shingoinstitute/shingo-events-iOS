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
    
    var event: SIEvent!

    var eventSpeakers = [String : SISpeaker]()
    
    var activityVC: ActivityViewController = ActivityViewController()
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let speakerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Speaker_Button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let scheduleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Schedule_Button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let attendeesButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Attendees-Button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let exhibitorsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Exhibitors_Button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let recipientsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Recipients_Button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let directionsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Directions_Button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let sponsorsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Sponsors-Button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let venuePhotosButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Venue_Pictures_Button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var backgroundImage: UIImageView = {
        let view = UIImageView.newAutoLayout()
        view.image = UIImage(named: "Shingo Icon Large")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    var eventHeaderImageView: UIImageView = {
        let view = UIImageView.newAutoLayout()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    lazy var buttonViews: [UIView] = [
        self.scheduleButton,
        self.venuePhotosButton,
        self.recipientsButton,
        self.exhibitorsButton,
        self.speakerButton,
        self.directionsButton,
        self.attendeesButton,
        self.sponsorsButton
    ]
    
    let BUTTON_WIDTH: CGFloat = 110.0
    let BUTTON_HEIGHT: CGFloat = 110.0
    
    var didSetupConstraints = false
    
    override func loadView() {
        super.loadView()
        
        DispatchQueue.global(qos: .utility).async { [unowned self] in
            // Load Agenda
            if !self.event.didLoadAgendas {
                //Note: requestAgendas will request session data under the hood
                self.event.requestAgendas() { self.event.didLoadAgendas = true }
            }
            
            if !self.event.didLoadSpeakers {
                // Load Speakers for entire event
                self.event.requestSpeakers() {self.event.didLoadSpeakers = true}
            }
            
            if !self.event.didLoadVenues {
                // Load venue photos
                self.event.requestVenues() {self.event.didLoadVenues = true}
            }
            
            if !self.event.didLoadRecipients {
                // Load Recipient information
                self.event.requestRecipients() {self.event.didLoadRecipients  = true}
            }
            
            if !self.event.didLoadAffiliates {
                // Load Affiliate information
                self.event.requestAffiliates() {self.event.didLoadAffiliates = true}
            }
            
            if !self.event.didLoadExhibitors {
                // Load Exhibitor information
                self.event.requestExhibitors() {self.event.didLoadExhibitors = true}
            }
            
            if !self.event.didLoadSponsors {
                // Load Sponsor information
                self.event.requestSponsors() {self.event.didLoadSponsors = true}
            }
            
            if !self.event.didLoadAttendees {
                self.event.requestAttendees() { self.event.didLoadAttendees = true }
            }
            
        }
        
        
        // Setup views
        contentView.backgroundColor = .clear
        
        eventNameLabel.text = event.name
        eventNameLabel.backgroundColor = UIColor.shingoBlue.withAlphaComponent(0.5)
        eventNameLabel.textColor = UIColor.white
        
        contentView.addSubviews([backgroundImage, eventNameLabel, eventHeaderImageView])
        contentView.addSubviews(buttonViews)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if event.didLoadImage {
            navigationItem.title = self.event.name
        } else {
            navigationItem.title = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        event.getBannerImage() { image in
            if let image = image {
                self.eventHeaderImageView.image = image
                self.navigationItem.title = self.event.name
            } else {
                self.navigationItem.title = ""
            }
        }

        // Add targets to all buttons
        scheduleButton.addTarget(self, action: #selector(EventMenuViewController.didTapSchedule(_:)), for: UIControlEvents.touchUpInside)
        venuePhotosButton.addTarget(self, action: #selector(EventMenuViewController.didTapVenue(_:)), for: UIControlEvents.touchUpInside)
        recipientsButton.addTarget(self, action: #selector(EventMenuViewController.didTapRecipients(_:)), for: UIControlEvents.touchUpInside)
        exhibitorsButton.addTarget(self, action: #selector(EventMenuViewController.didTapExhibitors(_:)), for: UIControlEvents.touchUpInside)
        speakerButton.addTarget(self, action: #selector(EventMenuViewController.didTapSpeakers(_:)), for: UIControlEvents.touchUpInside)
        directionsButton.addTarget(self, action: #selector(EventMenuViewController.didTapDirections(_:)), for: UIControlEvents.touchUpInside)
        attendeesButton.addTarget(self, action: #selector(EventMenuViewController.didTapAttendess(_:)), for: UIControlEvents.touchUpInside)
        sponsorsButton.addTarget(self, action: #selector(EventMenuViewController.didTapSponsors(_:)), for: UIControlEvents.touchUpInside)
        
        updateViewConstraints()
        
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            
            // set dimensions of buttons
            for button in buttonViews {
                button.autoSetDimension(.height, toSize: BUTTON_WIDTH)
                button.autoSetDimension(.width, toSize: BUTTON_HEIGHT)
            }
            
            // calculate button spacing from edge
            let edgeSpacing = (view.frame.width * (1/4)) - (BUTTON_WIDTH / 2) + 10
            let verticalButtonSpacing: CGFloat = -10
            
            // Set up constraints from bottom left to top right
            exhibitorsButton.autoPinEdge(.bottom, to: .bottom, of: contentView, withOffset: verticalButtonSpacing)
            exhibitorsButton.autoPinEdge(.left, to: .left, of: contentView, withOffset: edgeSpacing)
            
            sponsorsButton.autoPinEdge(.bottom, to: .bottom, of: contentView, withOffset: verticalButtonSpacing)
            sponsorsButton.autoPinEdge(.right, to: .right, of: contentView, withOffset: -edgeSpacing)
            
            recipientsButton.autoPinEdge(.bottom, to: .top, of: exhibitorsButton, withOffset: verticalButtonSpacing)
            recipientsButton.autoPinEdge(.left, to: .left, of: contentView, withOffset: edgeSpacing)
            
            attendeesButton.autoPinEdge(.bottom, to: .top, of: sponsorsButton, withOffset: verticalButtonSpacing)
            attendeesButton.autoPinEdge(.right, to: .right, of: contentView, withOffset: -edgeSpacing)
            
            venuePhotosButton.autoPinEdge(.bottom, to: .top, of: recipientsButton, withOffset: verticalButtonSpacing)
            venuePhotosButton.autoPinEdge(.left, to: .left, of: contentView, withOffset: edgeSpacing)
            
            directionsButton.autoPinEdge(.bottom, to: .top, of: attendeesButton, withOffset: verticalButtonSpacing)
            directionsButton.autoPinEdge(.right, to: .right, of: contentView, withOffset: -edgeSpacing)
            
            scheduleButton.autoPinEdge(.bottom, to: .top, of: venuePhotosButton, withOffset: verticalButtonSpacing)
            scheduleButton.autoPinEdge(.left, to: .left, of: contentView, withOffset: edgeSpacing)
            
            speakerButton.autoPinEdge(.bottom, to: .top, of: directionsButton, withOffset: verticalButtonSpacing)
            speakerButton.autoPinEdge(.right, to: .right, of: contentView, withOffset: -edgeSpacing)
            
            //Note: eventNameLabel's top, left, and right constraints are set in Main.storyboard
            eventNameLabel.autoPinEdge(.bottom, to: .top, of: scheduleButton, withOffset: -12)
            
            // Constraints for event banner image (same as eventNameLabel.constraints)
            eventHeaderImageView.autoPinEdge(.top, to: .top, of: eventNameLabel)
            eventHeaderImageView.autoPinEdge(.left, to: .left, of: eventNameLabel)
            eventHeaderImageView.autoPinEdge(.right, to: .right, of: eventNameLabel)
            eventHeaderImageView.autoPinEdge(.bottom, to: .bottom, of: eventNameLabel)
            
            // constraints for backgroundImage
            backgroundImage.autoPinEdge(.top, to: .bottom, of: eventNameLabel)
            backgroundImage.autoPinEdge(.left, to: .left, of: view)
            backgroundImage.autoPinEdge(.right, to: .right, of: view)
            backgroundImage.autoPinEdge(.bottom, to: .bottom, of: view)
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    func displayBadRequestNotification() {
        let alert = UIAlertController(title: "Oops!",
                                      message: "We were unable to fetch any data for you. Please make sure you have an internet connection.",
                                      preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}

extension EventMenuViewController {
    
    // MARK: - Button Outlet functions
    func didTapSchedule(_ sender: AnyObject) {
        (sender as! UIButton).isEnabled = false
        if event.didLoadAgendas {
            self.performSegue(withIdentifier: "SchedulesView", sender: self.event.agendaItems)
            (sender as! UIButton).isEnabled = true
        } else {
            self.present(activityVC, animated: false, completion: { 
                self.event.requestAgendas() {
                    self.dismiss(animated: true, completion: { 
                        self.performSegue(withIdentifier: "SchedulesView", sender: self.event.agendaItems)
                        (sender as! UIButton).isEnabled = true
                    });
                }
            });
        }
    }
    
    func didTapSpeakers(_ sender: AnyObject) {
        if event.didLoadSpeakers  {
            self.performSegue(withIdentifier: "SpeakerList", sender: self.eventSpeakers)
        } else {
            self.present(activityVC, animated: false, completion: { 
                self.event.requestSpeakers() {
                    self.dismiss(animated: true, completion: { 
                        self.performSegue(withIdentifier: "SpeakerList", sender: self.eventSpeakers)
                    });
                }
            });
        }
    }
    
    func didTapRecipients(_ sender: AnyObject) {
        if event.didLoadRecipients {
            self.performSegue(withIdentifier: "RecipientsView", sender: self.event.recipients)
        } else {
            self.present(activityVC, animated: false, completion: {
                self.event.requestRecipients() {
                    self.dismiss(animated: true, completion: { 
                        self.performSegue(withIdentifier: "RecipientsView", sender: self.event.recipients)
                    });
                }
            });
        }
    }
    
    //TODO: Create screen on segue that shows more than the first potentially available venue
    func didTapDirections(_ sender: AnyObject) {
        if event.didLoadVenues {
            if let venue = self.event.venues.first {
                self.performSegue(withIdentifier: "MapView", sender: venue)
            }
        } else {
            self.present(activityVC, animated: false, completion: { 
                self.event.requestVenues({
                    self.dismiss(animated: true, completion: {
                        if let venue = self.event.venues.first {
                            self.performSegue(withIdentifier: "MapView", sender: venue)
                        }
                    });
                });
            });
        }
    }
    
    func didTapExhibitors(_ sender: AnyObject) {
        if event.didLoadExhibitors {
            self.performSegue(withIdentifier: "ExhibitorsListView", sender: self.event.exhibitors)
        } else {
            self.present(activityVC, animated: false, completion: {
                self.event.requestExhibitors({
                    self.dismiss(animated: true, completion: {
                        self.performSegue(withIdentifier: "ExhibitorsListView", sender: self.event.exhibitors)
                    })
                });
            });
        }
    }
    
    func didTapAttendess(_ sender: AnyObject) {
        
        if event.didLoadAttendees {
            self.performSegue(withIdentifier: "AttendeesView", sender: self.event.attendees)
        } else {
            self.present(activityVC, animated: false, completion: {
                self.event.requestAttendees() {
                    self.dismiss(animated: true, completion: {
                        self.performSegue(withIdentifier: "AttendeesView", sender: self.event.attendees)
                    });
                }
            });
        }
    }
    
    func didTapVenue(_ sender: AnyObject) {
        
        if event.didLoadVenues {
            self.performSegue(withIdentifier: "VenueView", sender: self.event.venues)
        } else {
            self.present(activityVC, animated: false, completion: {
                self.event.requestVenues() {
                    self.dismiss(animated: true, completion: {
                        self.performSegue(withIdentifier: "VenueView", sender: self.event.venues)
                    });
                }
            });
        }
    }
    
    func didTapSponsors(_ sender: AnyObject) {
        
        if event.didLoadSponsors {
            self.performSegue(withIdentifier: "SponsorsView", sender: self.event.sponsors)
        } else {
            self.present(activityVC, animated: false, completion: {
                self.event.requestSponsors {
                    self.dismiss(animated: true, completion: {
                        self.performSegue(withIdentifier: "SponsorsView", sender: self.event.sponsors)
                    });
                }
            });
        }
    }
    
}

extension EventMenuViewController {
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        navigationItem.title = ""
        
        if segue.identifier == "SchedulesView" {
            let destination = segue.destination as! SchedulesTableViewController
            destination.agendas = event.agendaItems.sorted { $0.date.isGreaterThanDate($1.date) }
            destination.eventName = event.name
        }
        
        if segue.identifier == "SpeakerList" {
            let destination = segue.destination as! SpeakerListTableViewController
            
            var keynoteSpeakers = [SISpeaker]()
            var concurrentSpeakers = [SISpeaker]()
            var unknownSpeakers = [SISpeaker]()
            
            let speakers: [SISpeaker] = Array(event.speakers.values)
            
            for speaker in speakers {
                
                switch speaker.speakerType {
                case .keynote:
                    keynoteSpeakers.append(speaker)
                case .concurrent:
                    concurrentSpeakers.append(speaker)
                default:
                    unknownSpeakers.append(speaker)
                }
                
            }
            
            destination.keyNoteSpeakers = keynoteSpeakers.sorted { $0.getFormattedName() > $1.getFormattedName() }
            destination.concurrentSpeakers = concurrentSpeakers.sorted { $0.getFormattedName() > $1.getFormattedName() }
            destination.unknownSpeakers = unknownSpeakers.sorted { $0.getFormattedName() > $1.getFormattedName() }
            
        }
        
        if segue.identifier == "RecipientsView" {
            let destination = segue.destination as! RecipientsTableViewController
            if let recipients = sender as? [SIRecipient] {
                
                var spRecipients = [SIRecipient]()
                var silverRecipients = [SIRecipient]()
                var bronzeRecipients = [SIRecipient]()
                var researchRecipients = [SIRecipient]()
                var publicationRecipients = [SIRecipient]()
                
                for r in recipients {
                    if r.awardType == .shingoPrize {
                        spRecipients.append(r)
                    } else if r.awardType == .silver {
                        silverRecipients.append(r)
                    } else if r.awardType == .bronze {
                        bronzeRecipients.append(r)
                    } else if r.awardType == .research {
                        researchRecipients.append(r)
                    } else if r.awardType == .publication {
                        publicationRecipients.append(r)
                    }
                }
                
                destination.spRecipients = spRecipients
                destination.silverRecipients = silverRecipients
                destination.bronzeRecipients = bronzeRecipients
                destination.researchRecipients = researchRecipients
                destination.publicationRecipients = publicationRecipients
                
            }
        }
        
        if segue.identifier == "MapView" {
            let destination = segue.destination as! MapViewController
            if let venue = sender as? SIVenue {
                destination.venue = venue
            }
        }
        
        if segue.identifier == "ExhibitorsListView" {
            
            let destination = segue.destination as! ExhibitorTableViewController
            if let exhibitors = sender as? [SIExhibitor] {
                
                var sections = [String : [SIExhibitor]]()
                
                var exhibitorSections = [(String, [SIExhibitor])]()
                
                for exhibitor in exhibitors {
                    let character = getCharacterForSection(exhibitor.name)
                    
                    if sections[character] != nil {
                        sections[character]?.append(exhibitor)
                    } else {
                        sections[character] = [exhibitor]
                    }
                }
                
                for letter in Alphabet.english {
                    if let section = sections[letter] {
                        exhibitorSections.append((letter, section))
                    }
                }
                
                destination.sectionInformation = exhibitorSections
                
            }
        }
        
        if segue.identifier == "AttendeesView" {
            let destination = segue.destination as! AttendessTableViewController
            if let attendees = sender as? [SIAttendee] {
                
                destination.attendees = attendees.sorted(by: { $0.getLastName() < $1.getLastName() })
            }
        }
        
        if segue.identifier == "VenueView" {
            let destination = segue.destination as! VenueMapsCollectionView
            destination.venue = self.event.venues[0]
        }
        
        if segue.identifier == "SponsorsView" {
            let destination = segue.destination as! SponsorsTableViewController
            if let sponsors = sender as? [SISponsor] {
                
                var sponsorTypes = [
                    [SISponsor](),
                    [SISponsor](),
                    [SISponsor](),
                    [SISponsor](),
                    [SISponsor](),
                    [SISponsor]()
                ]
                
                for s in sponsors {
                    if s.sponsorType == .friend {
                        sponsorTypes[0].append(s)
                    } else if s.sponsorType == .supporter {
                        sponsorTypes[1].append(s)
                    } else if s.sponsorType == .benefactor {
                        sponsorTypes[2].append(s)
                    } else if s.sponsorType == .champion {
                        sponsorTypes[3].append(s)
                    } else if s.sponsorType == .president {
                        sponsorTypes[4].append(s)
                    } else {
                        sponsorTypes[5].append(s)
                    }
                }
                
                destination.friends = sponsorTypes[0]
                destination.supporters = sponsorTypes[1]
                destination.benefactors = sponsorTypes[2]
                destination.champions = sponsorTypes[3]
                destination.presidents = sponsorTypes[4]
                destination.other = sponsorTypes[5]
            }
        }
        
    }
}

extension EventMenuViewController {

    // MARK: - Custom Class Functions
    func getCharacterForSection(_ name: String) -> String {
        
        guard let fullname = name.split(" ") else {
            return ""
        }
        
        var usedName = ""

        // Check that the first word in the name is not "the", and if so, use the next word in name.
        if let first = fullname.first {
            if first.lowercased() == "the" {
                usedName = name.next(first, delimiter: " ")!
            } else {
                usedName = first
            }
        }
        
        let sectionCharacter = String(usedName.characters.first!).uppercased()
        
        // If name begins with a number, change to the '#' character.
        guard let _ = Int(sectionCharacter) else {
            return sectionCharacter
        }
        
        return "#"
    }

}


