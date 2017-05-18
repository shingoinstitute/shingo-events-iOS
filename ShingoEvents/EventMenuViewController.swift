//
//  EventDetailsViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/8/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import PureLayout

class EventMenuViewController: UIViewController {
    
    var event: SIEvent!
    var eventSpeakers = [String : SISpeaker]()
    var activityVC: ActivityViewController = ActivityViewController(message: "Fetching Data...")
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var salesTextView: UITextView!
    
    @IBOutlet weak var eventHeaderImageView: UIImageView!
    @IBOutlet weak var speakerButton: UIButton!
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var attendeesButton: UIButton!
    @IBOutlet weak var exhibitorsButton: UIButton!
    @IBOutlet weak var recipientsButton: UIButton!
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var sponsorsButton: UIButton!
    @IBOutlet weak var venuePhotosButton: UIButton!
    
    lazy var menuButtons: [UIButton] = [
        self.speakerButton,
        self.scheduleButton,
        self.attendeesButton,
        self.exhibitorsButton,
        self.recipientsButton,
        self.directionsButton,
        self.sponsorsButton,
        self.venuePhotosButton
    ]
    
    @IBOutlet weak var bannerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerView: BannerView!
    
    var requestManager: SIRequestManager!
    var segueTypeOnRequestCompletion: SIRequestType = .none
    
    let sponsorBannerViewEnabledHeight: CGFloat = 64
    let sponsorBannerViewDisabledHeight: CGFloat = 8
    
    override func loadView() {
        super.loadView()
        requestEventData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = event.name
        
        if navigationController != nil {
            navigationController?.navigationBar.barTintColor = .shingoBlue
        }
        
        for button in menuButtons {
            button.imageView?.contentMode = .scaleAspectFit
            button.setImage(button.imageView?.image?.af_imageScaled(to: CGSize(width: 36, height: 36)), for: .normal)
        }
        
        salesTextView.attributedText = SIRequest.parseHTMLStringUsingPreferredFont(string: event.salesText, forTextStyle: .subheadline)
        
        setupSponsorBannerView()
        
        getEventBannerImage()
    }
    
    private func getEventBannerImage() {
        if let bannerImage = event.image {
            eventHeaderImageView.image = bannerImage
        } else {
            event.getImage() { image in
                if let image = image {
                    self.eventHeaderImageView.image = image
                }
            }
        }
    }
    
    private func setupSponsorBannerView() {
        bannerView.bannerAds = event.getBannerAds()
        
        if event.hasBannerAds {
            bannerView.start()
        } else {
            bannerViewHeightConstraint.constant = 0
            checkForBannerAdsOnInterval()
        }
    }
    
    private func checkForBannerAdsOnInterval() {
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            
            if self.event.hasBannerAds {
                timer.invalidate()
                UIView.animate(withDuration: 0.2, animations: {
                    self.bannerViewHeightConstraint.constant = self.sponsorBannerViewEnabledHeight
                    self.view.layoutIfNeeded()
                }, completion: { (_) in
                    self.bannerView.start()
                })
            }
        }
    }
    
    private func requestEventData() {
        requestManager = SIRequestManager(event: event, delegate: self)
        requestManager.requestAll()
    }
    
    func displayBadRequestNotification() {
        let alert = UIAlertController(title: "Oops!",
                                      message: "We were unable to fetch any data for you. Please make sure you have an internet connection.",
                                      preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didTapSchedule(_ sender: Any) {
        if event.didLoadAgendas {
            self.performSegue(withIdentifier: "SchedulesView", sender: self.event.agendas)
        } else {
            scheduleButton.isEnabled = false
            segueTypeOnRequestCompletion = .agenda
            present(activityVC, animated: false, completion: {
                self.requestManager.requestAgendas()
            });
        }
    }
    
    @IBAction func didTapSpeakers(_ sender: Any) {
        if event.didLoadSpeakers  {
            self.performSegue(withIdentifier: "SpeakerList", sender: self.eventSpeakers)
        } else {
            segueTypeOnRequestCompletion = .speaker
            present(activityVC, animated: false, completion: {
                self.requestManager.requestSpeakers()
            });
        }
    }
    
    @IBAction func didTapRecipients(_ sender: Any) {
        if event.didLoadRecipients {
            performSegue(withIdentifier: "RecipientsView", sender: self.event.recipients)
        } else {
            segueTypeOnRequestCompletion = .recipient
            present(activityVC, animated: false, completion: {
                self.requestManager.requestRecipients()
            });
        }
    }
    
    @IBAction func didTapDirections(_ sender: Any) {
        if event.didLoadVenues {
            if let venue = self.event.venues.first {
                performSegue(withIdentifier: "MapView", sender: venue)
            }
        } else {
            segueTypeOnRequestCompletion = .map
            present(activityVC, animated: false, completion: {
                self.requestManager.requestVenues()
            });
        }
    }
    
    @IBAction func didTapExhibitors(_ sender: Any) {
        if event.didLoadExhibitors {
            performSegue(withIdentifier: "ExhibitorsListView", sender: self.event.exhibitors)
        } else {
            segueTypeOnRequestCompletion = .exhibitor
            present(activityVC, animated: false, completion: { 
                self.requestManager.requestExhibitors()
            })
        }
    }
    
    @IBAction func didTapAttendess(_ sender: Any) {
        
        if event.didLoadAttendees {
            performSegue(withIdentifier: "AttendeesView", sender: self.event.attendees)
        } else {
            segueTypeOnRequestCompletion = .attendee
            present(activityVC, animated: false, completion: {
                self.requestManager.requestAttendees()
            });
        }
    }
    
    @IBAction func didTapVenue(_ sender: Any) {
        if event.didLoadVenues {
            self.performSegue(withIdentifier: "VenueView", sender: self.event.venues)
        } else {
            segueTypeOnRequestCompletion = .venue
            present(activityVC, animated: false, completion: {
                self.requestManager.requestVenues()
            })
        }
    }
    
    @IBAction func didTapSponsors(_ sender: Any) {
        
        if event.didLoadSponsors {
            performSegue(withIdentifier: "SponsorsView", sender: self.event.sponsors)
        } else {
            segueTypeOnRequestCompletion = .sponsor
            present(activityVC, animated: false, completion: {
                self.requestManager.requestSponsors()
            });
        }
    }
    
}

extension EventMenuViewController {
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
            
        case "SchedulesView":
            let destination = segue.destination as! SchedulesTableViewController
            event.agendas.sort { $1.date.regionDate > $0.date.regionDate }
            destination.event = event
            
            break
            
        case "SpeakerList":
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
            
            break
            
        case "RecipientsView":
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
            
            break
            
        case "MapView":
            let destination = segue.destination as! MapViewController
            if let venue = sender as? SIVenue {
                destination.venue = venue
            }
            
            break
            
        case "ExhibitorsListView":
            
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
            
            break
            
        case "AttendeesView":
            let destination = segue.destination as! AttendessTableViewController
            if let attendees = sender as? [SIAttendee] {
                destination.attendees = attendees.sorted { $0.getLastName() < $1.getLastName() }
            }
            
            break
            
        case "VenueView":
            let destination = segue.destination as! VenueMapsCollectionView
            destination.venue = self.event.venues[0]
            
            break
            
        case "SponsorsView":
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
            
            break
            
        default: break
            
        }
        
    }
}

extension EventMenuViewController: SIRequestManagerDelegate {
    func onRequestComplete(requestType type: SIRequestType) {
        
        let segueType: SIRequestType = segueTypeOnRequestCompletion == type ? type : .none
        
        dismiss(animated: false) { 
            switch segueType {
            case .speaker:
                self.performSegue(withIdentifier: "SpeakerList", sender: self.event.speakers)
                break
            case .agenda:
                self.performSegue(withIdentifier: "SchedulesView", sender: self.event.agendas)
                self.scheduleButton.isEnabled = true
                break
            case .attendee:
                self.performSegue(withIdentifier: "AttendeesView", sender: self.event.attendees)
                break
            case .exhibitor:
                self.performSegue(withIdentifier: "ExhibitorsListView", sender: self.event.exhibitors)
                break
            case .recipient:
                self.performSegue(withIdentifier: "RecipientsView", sender: self.event.recipients)
                break
            case .sponsor:
                self.performSegue(withIdentifier: "SponsorsView", sender: self.event.sponsors)
                break
            case .venue:
                self.performSegue(withIdentifier: "VenueView", sender: self.event.venues)
                break
            case .map:
                self.performSegue(withIdentifier: "MapView", sender: self.event.venues.first)
                break
            case .none, .event, .sessions, .affiliate:
                break
            }
        }
        
        segueTypeOnRequestCompletion = .none
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


