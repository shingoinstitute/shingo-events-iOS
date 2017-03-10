//
//  MainMenuViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/14/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import Crashlytics
import Fabric
import Alamofire

class MainMenuViewController: UIViewController {
    
    //Mark: - Properties
    var events : [SIEvent]?
    var request: Alamofire.Request?
    var affiliates: [SIAffiliate]?
    
    // Activity view used for the loading screen
    var activityView : ActivityViewController!
    
    // Menu buttons
    @IBOutlet weak var eventsButton: UIButton!
    @IBOutlet weak var affiliatesButton: UIButton!
    @IBOutlet weak var shingoModelButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var flameImageView: UIImageView!
    
    lazy var buttons: [UIButton] = {
        return [self.eventsButton, self.affiliatesButton, self.shingoModelButton, self.settingsButton]
    }()
    
    var eventsDidLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradColors:[CGFloat] = [
            0, 0, 0, 0,
            0, 0, 0, 0.116666,
            0, 0, 0, 0.233333,
            0, 0, 0, 0.35
        ]
        let colorLocations:[CGFloat] = [0, 0.75, 0.85, 1.0]
        let gradient = RadialGradientLayer(gradientColors: gradColors, gradientLocations: colorLocations)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
        
        activityView = ActivityViewController(message: "Loading Upcoming Conferences...")
        
        DispatchQueue.global(qos: .background).async { [unowned self] in
            self.requestEvents()
            self.requestAffiliates()
        }
        
        navigationItem.title = ""
        
        if let nav = navigationController?.navigationBar {
            nav.barStyle = UIBarStyle.black
            nav.tintColor = UIColor.yellow
        }
        
        for button in self.buttons {
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: -25)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -46, bottom: 0, right: 0)
            button.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            button.imageView?.contentMode = .scaleAspectFit
        }
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func requestEvents() {
        SIRequest().requestEvents({ events in
            if let events = events {
                self.events = events
                self.eventsDidLoad = true
            }
        })
    }
    
    private func requestAffiliates() {
        SIRequest.requestAffiliates { (affiliates) in
            if let affiliates = affiliates {
                self.affiliates = affiliates
            }
        }
    }
    
}

extension MainMenuViewController {
    
    // MARK: - Button Listeners
    
    @IBAction func didTapEvents(_ sender: AnyObject) {
        
//        let ssView = SplashScreenView(splashScreenImage: UIImage(named: "FlameOnly-100")!)
//        ssView.presentSplashScreen(parentViewController: self) {
//            if self.eventsDidLoad {
//                ssView.dismissSplashScreen(parentViewController: self, completion: {
//                    self.performSegue(withIdentifier: "EventsView", sender: self.events)
//                })
//            } else {
//                if Reachability()!.isReachable {
//                    self.request = SIRequest().requestEvents({ (events) in
//                        ssView.dismissSplashScreen(parentViewController: self, completion: {
//                            if let events = events {
//                                self.events = events
//                                self.eventsDidLoad = true
//                                self.performSegue(withIdentifier: "EventsView", sender: self.events)
//                            } else {
//                                self.displayServerError()
//                            }
//                        });
//                    });
//                }
//            }
//        }
        if Reachability()!.isReachable {
            if eventsDidLoad {
                performSegue(withIdentifier: "EventsView", sender: self.events)
            } else {
                
                present(activityView, animated: true, completion: {
                    
                    DispatchQueue.global(qos: .utility).async {
                        self.request = SIRequest().requestEvents({ events in
                            self.dismiss(animated: true, completion: {
                                if let events = events {
                                    self.events = events
                                    self.eventsDidLoad = true
                                    self.performSegue(withIdentifier: "EventsView", sender: self.events)
                                } else {
                                    self.displayServerError()
                                }
                            })
                        })
                    }
                })
            }
        } else {
            SIRequest.displayInternetAlert(forViewController: self, completion: nil)
        }
        
    }
    
    @IBAction func didTapAffiliates(_ sender: AnyObject) {
        if let affiliates = self.affiliates {
            performSegue(withIdentifier: "AffiliatesView", sender: affiliates)
        } else {
            
            if let reach = Reachability() {
                
                if reach.isReachable {
                    present(activityView, animated: true, completion: {
                        self.dismiss(animated: true, completion: {
                            SIRequest.requestAffiliates(callback: { (affiliates) in
                                if let affiliates = affiliates {
                                    self.affiliates = affiliates
                                    self.performSegue(withIdentifier: "AffiliatesView", sender: affiliates)
                                } else {
                                    self.displayServerError()
                                }
                            })
                        })
                    })
                }
            } else {
                SIRequest.displayInternetAlert(forViewController: self, completion: nil)
            }
        }
    }
    
    @IBAction func didTapShingoModel(_ sender: AnyObject) {
        performSegue(withIdentifier: "ShingoModel", sender: self)
    }
    
    @IBAction func didTapSupport(_ sender: AnyObject) {
        performSegue(withIdentifier: "Support", sender: self)
    }
    
}

extension MainMenuViewController: UnwindToMainVCProtocol {
    
    // Mark: - Navigation
    
    @IBAction func unwindToLaunchMenu(_ segue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
            
        case "EventsView":
            let destination = segue.destination as! EventsTableViewController
            if let events = sender as? [SIEvent] {
                self.events = events.sorted { $0.startDate.isGreaterThanDate($1.startDate) }
                destination.events = self.events
            }
        case "Support":
            let destination = segue.destination as! SettingsTableViewController
            destination.delegate = self
        case "AffiliatesView":
            
            let destination = segue.destination as! AffiliateListTableViewController
            if let affiliates = sender as? [SIAffiliate] {

                // Populate section headers so affiliates can be presented alphabetically in seperate tableView sections
                var sections = [String : [SIAffiliate]]()

                var affiliateSections = [(String, [SIAffiliate])]()

                for affiliate in affiliates {

                    // Get first letter of affiliate name
                    if let character = getCharacterForSection(name: affiliate.name) {
                        // Add to dictionary
                        if var section = sections[character] {
                            section.append(affiliate)
                            sections[character] = section
                        } else {
                            sections[character] = [affiliate]
                        }
                    }
                }

                for character in Alphabet.upperCasedAlphabet() {
                    if let section = sections[character] {
                        affiliateSections.append((character, section))
                    }
                }
                
                destination.affiliateSections = affiliateSections
            }
            
        default:
            break
        }
        
    }
    
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
    
    // Protocal for passing data back from the Support
    // page when the 'reload data' button is pressed
    func updateEvents(_ events: [SIEvent]?) {
        if let events = events {
            self.events = events
        }
    }
    
}

extension MainMenuViewController {
    
    //MARK: - Other
    fileprivate func displayServerError() {
        let alert = UIAlertController(title: "Server Error", message: "We're currently experiencing a problem with our server and are working on a solution to fix it as quickly as possible. We're sorry for any inconvenience this has caused.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    
}


