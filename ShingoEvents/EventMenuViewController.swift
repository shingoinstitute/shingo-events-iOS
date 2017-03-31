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
    
    @IBOutlet weak var speakerButton: UIButton! {
        didSet {
            let size = CGSize(width: 33, height: 33)
            let speakerButtonImage = #imageLiteral(resourceName: "Speakers-Button").af_imageScaled(to: size)
            speakerButton.imageView?.image = speakerButtonImage
            speakerButton.imageView?.resizeImageViewToIntrinsicContentSize(thatFitsWidth: 33)
        }
    }
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var attendeesButton: UIButton!
    @IBOutlet weak var exhibitorsButton: UIButton!
    @IBOutlet weak var recipientsButton: UIButton!
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var sponsorsButton: UIButton!
    @IBOutlet weak var venuePhotosButton: UIButton!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var eventHeaderImageView: UIImageView! {
        didSet {
            eventHeaderImageView.contentMode = .scaleAspectFill
            eventHeaderImageView.backgroundColor = .clear
            eventHeaderImageView.clipsToBounds = true
        }
    }

    @IBOutlet weak var bannerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerView: BannerView! {
        didSet {
            bannerView.backgroundColor = .clear
            bannerView.bannerAds = event.getBannerAds()
        }
    }
    
    lazy var buttons: [UIButton] = [
        self.scheduleButton,
        self.venuePhotosButton,
        self.recipientsButton,
        self.exhibitorsButton,
        self.speakerButton,
        self.directionsButton,
        self.attendeesButton,
        self.sponsorsButton
    ]
    
    var didSetupConstraints = false
    
    override func loadView() {
        super.loadView()
        
        DispatchQueue.global(qos: .utility).async { [unowned self, weak event = self.event!] in
            
            guard let event = event else {
                return
            }
            
            // Load Agenda
            if !self.event.didLoadAgendas {
                //Note: requestAgendas will request session data under the hood
                self.event.requestAgendas() {
                    event.didLoadAgendas = true
                }
            }
            
            if !self.event.didLoadSpeakers {
                // Load Speakers for entire event
                self.event.requestSpeakers() {
                    event.didLoadSpeakers = true
                }
            }
            
            if !self.event.didLoadVenues {
                // Load venue photos
                self.event.requestVenues() {
                    event.didLoadVenues = true
                }
            }
            
            if !self.event.didLoadRecipients {
                // Load Recipient information
                self.event.requestRecipients() {
                    event.didLoadRecipients  = true
                }
            }
            
            if !self.event.didLoadAffiliates {
                // Load Affiliate information
                self.event.requestAffiliates() {
                    event.didLoadAffiliates = true
                }
            }
            
            if !self.event.didLoadExhibitors {
                // Load Exhibitor information
                self.event.requestExhibitors() {
                    event.didLoadExhibitors = true
                }
            }
            
            if !self.event.didLoadSponsors {
                // Load Sponsor information
                self.event.requestSponsors() {
                    event.didLoadSponsors = true
                }
            }
            
            if !self.event.didLoadAttendees {
                self.event.requestAttendees() {
                    event.didLoadAttendees = true
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = self.event.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        bannerView.start()
        
        if let bannerImage = event.image {
            eventHeaderImageView.image = bannerImage
        } else {
            event.getBannerImage() { image in
                if let image = image {
                    self.eventHeaderImageView.image = image
                    self.navigationItem.title = self.event.name
                } else {
                    self.navigationItem.title = ""
                }
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
        
        for button in buttons {
            button.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            button.imageView?.contentMode = .scaleAspectFit
            button.clipsToBounds = true
        }
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
        
        if let sponsor = self.event.sponsors.first {
            SIRequest().requestSponsor(sponsorId: sponsor.id, callback: { (sponsor) in
                if let sponsor = sponsor {
                    print(sponsor.attributedSummary)
                }
            })
        }
        
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
            destination.agendas = event.agendaItems.sorted { $1.date.isGreaterThanDate($0.date) }
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
            
            destination.keyNoteSpeakers = keynoteSpeakers.sorted { $0.getLastName() < $1.getLastName() }
            destination.concurrentSpeakers = concurrentSpeakers.sorted { $0.getLastName() < $1.getLastName() }
            destination.unknownSpeakers = unknownSpeakers.sorted { $0.getLastName() < $1.getLastName() }
            
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
                    if let character: String = getCharacterForSection(name: exhibitor.name) {
                        if sections[character] != nil {
                            sections[character]?.append(exhibitor)
                        } else {
                            sections[character] = [SIExhibitor]()
                            sections[character]?.append(exhibitor)
                        }
                    }
                }
                
                for letter in Alphabet.upperCasedAlphabet() {
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
                
                destination.attendees = attendees.sorted { $0.getLastName() < $1.getLastName() }
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

    /**
     This method parses a string and returns a character that can be used as a header in an alphabetically sorted list.
     
     - parameter name: A name, title, etc. that belongs to an item in a list that should be sorted alphabetically.
     
     - returns: A single `Character` as a `String`
     */
    func getCharacterForSection(name: String) -> String? {
        
        if let nameArray = name.split(" ") {
            for subName in nameArray {
                if subName.lowercased() == "the" {
                    continue
                } else {
                    let firstCharacter = subName.characters.first
                    if let letter: String = firstCharacter != nil ? String(describing: firstCharacter!).uppercased() : nil {
                        return Int(letter) != nil ? "#" : letter
                    }
                }
            }
        }
        return nil
    }

}


