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

class MainMenuViewController: UIViewController, SIRequestDelegate {
    
    //Mark: - Properties
    var events : [SIEvent]?
    var request: Alamofire.Request?
    
    // Activity view used for the loading screen
    var activityView : ActivityViewController!
    
    // Used to set inital placement of menu items off screen so they can later be animated
    var contentViewHeightConstraint: NSLayoutConstraint!
    
    // Menu buttons
    @IBOutlet weak var eventsBtn: UIButton!
    @IBOutlet weak var shingoModelBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    
    @IBOutlet weak var copyRightLabel: UILabel!
    
    
    // Shingo Logo background image
    var menuBackgroundImage: UIImageView = {
        let view = UIImageView.newAutoLayout()
        view.backgroundColor = .white
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Shingo Icon Fullscreen")
        return view
    }()
    
    // Shingo Institute Title
    var shingoLogoImageView : UIImageView = {
        let view = UIImageView.newAutoLayout()
        if let image = UIImage(named: "Shingo Title") {
            view.image = image
        }
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    // Container for menu items
    var contentView: UIView = {
        let view = UIView.newAutoLayout()
        view.backgroundColor = .clear
        return view
    }()
    
    var eventsDidLoad = false
    var didSetupConstraints = false
    var didAnimateLayout = false
    
    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityView = ActivityViewController(message: "Loading Upcoming Conferences...")
        activityView.delegate = self
        
        requestEvents()
        
        navigationItem.title = ""
        
        if let nav = navigationController?.navigationBar {
            nav.barStyle = UIBarStyle.black
            nav.tintColor = UIColor.yellow
        }
        
        updateViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateLayout()
    }

    override func updateViewConstraints() {
        if !didSetupConstraints {
            
            contentView.addSubviews([eventsBtn, shingoModelBtn, settingsBtn])

            view.addSubviews([menuBackgroundImage, contentView, shingoLogoImageView])
            
            view.bringSubview(toFront: copyRightLabel)
            
            menuBackgroundImage.autoPinEdge(toSuperviewEdge: .top)
            menuBackgroundImage.autoPinEdge(.left, to: .left, of: view)
            menuBackgroundImage.autoPinEdge(.right, to: .right, of: view)
            menuBackgroundImage.autoPinEdge(.bottom, to: .bottom, of: view)
            
            contentView.autoSetDimension(.height, toSize: 265)
            contentViewHeightConstraint = contentView.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: -view.frame.height)
            if UIDevice.current.deviceType.rawValue >= 6.0 {
                contentView.autoPinEdge(.left, to: .left, of: view, withOffset: 175.0)
                contentView.autoPinEdge(.right, to: .right, of: view, withOffset: -175.0)
            } else {
                contentView.autoPinEdge(.left, to: .left, of: view, withOffset: 10.0)
                contentView.autoPinEdge(.right, to: .right, of: view, withOffset: -10.0)
            }
        
            eventsBtn.autoSetDimension(.height, toSize: 60)
            eventsBtn.autoPinEdge(.top, to: .top, of: contentView, withOffset: 5)
            eventsBtn.autoPinEdge(.left, to: .left, of: contentView, withOffset: 5)
            eventsBtn.autoPinEdge(.right, to: .right, of: contentView, withOffset: -5)
            
            shingoModelBtn.autoSetDimension(.height, toSize: 60)
            shingoModelBtn.autoPinEdge(.top, to: .bottom, of: eventsBtn, withOffset: 8)
            shingoModelBtn.autoPinEdge(.left, to: .left, of: contentView, withOffset: 5)
            shingoModelBtn.autoPinEdge(.right, to: .right, of: contentView, withOffset: -5)
            
            settingsBtn.autoSetDimension(.height, toSize: 60)
            settingsBtn.autoPinEdge(.top, to: .bottom, of: shingoModelBtn, withOffset: 8)
            settingsBtn.autoPinEdge(.left, to: .left, of: contentView, withOffset: 5)
            settingsBtn.autoPinEdge(.right, to: .right, of: contentView, withOffset: -5)
            
            shingoLogoImageView.autoSetDimension(.height, toSize: 125)
            shingoLogoImageView.autoPin(toTopLayoutGuideOf: self, withInset: 8)
            shingoLogoImageView.autoPinEdge(toSuperviewEdge: .left, withInset: 8)
            shingoLogoImageView.autoPinEdge(toSuperviewEdge: .right, withInset: 8)
            
            let buttons:NSArray = [eventsBtn, shingoModelBtn, settingsBtn]
            for button in buttons as! [UIButton] {
                contentView.bringSubview(toFront: button)
                button.backgroundColor = UIColor.black.withAlphaComponent(0.75)
                button.layer.cornerRadius = 5
                button.setTitleColor(UIColor.white, for: UIControlState())
                
                let arrow = UIImageView()
                arrow.image = UIImage(named: "right-arrow")
                arrow.contentMode = .scaleAspectFit

                button.addSubview(arrow)
                
                arrow.autoSetDimensions(to: CGSize(width: 30, height: 30))
                arrow.autoPinEdge(.right, to: .right, of: button, withOffset: -8)
                arrow.autoAlignAxis(.horizontal, toSameAxisOf: button)
            }
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    func cancelRequest() {
        dismiss(animated: false, completion: {
            if let request = self.request {
                request.cancel()
            }
        })
    }
    
    fileprivate func requestEvents() {
        let _ = SIRequest().requestEvents({ events in
            if let events = events {
                self.events = events
                self.eventsDidLoad = true
            }
        })
    }
    
}

extension MainMenuViewController {
    
    // MARK: - Button Listeners
    
    @IBAction func didTapEvents(_ sender: AnyObject) {
        shouldPerformSegueToEvents()
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
    
    func shouldPerformSegueToEvents() {
        
        let reach = Reachability()!
        
        if reach.isReachable {
            if eventsDidLoad {
                performSegue(withIdentifier: "EventsView", sender: self.events)
            } else {
                present(activityView, animated: true, completion: {
                    self.request = SIRequest().requestEvents({ events in
                        self.dismiss(animated: false, completion: {
                            if let events = events {
                                self.events = events
                                self.eventsDidLoad = true
                                self.performSegue(withIdentifier: "EventsView", sender: self.events)
                            } else {
                                self.displayServerError()
                            }
                        })
                    })
                })
            }
        } else {
            SIRequest.displayInternetAlert(forViewController: self, completion: { _ in
                self.animateLayout()
            })
        }
        
        
    }
    
    @IBAction func unwindToLaunchMenu(_ segue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventsView" {
            let destination = segue.destination as! EventsTableViewController
            if let events = sender as? [SIEvent] {
                destination.events = events
            }
        }
        
        if segue.identifier == "Support" {
            let destination = segue.destination as! SettingsTableViewController
            destination.delegate = self
        }
        
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
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: { _ in
            self.animateLayout()
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func animateLayout() {
        if !didAnimateLayout {
            
            // Sets new constraint constant to make the menu appear onscreen in an appropriate position depending on screen size.
            switch UIDevice.current.deviceType.rawValue {
            case 1.0 ..< 3.0:
                //iPhone 2 - iPhone 4/SE
                contentViewHeightConstraint.constant = 15
            case 3.0 ..< 4.0:
                //iPhone 5 series
                contentViewHeightConstraint.constant = -20
            case 4.0 ..< 6.0:
                //iPhone 6 - iPhone 6+
                contentViewHeightConstraint.constant = -40
            case 6.0 ..< 8.0:
                //iPad series
                contentViewHeightConstraint.constant = -view.frame.height / 6
            default:
                contentViewHeightConstraint.constant = -40
            }
            
            // @deployment
            // Uncomment lines below to animate constraints
//            UIView.animate(withDuration: 1.5,
//                                       delay: 0.5,
//                                       usingSpringWithDamping: 0.5,
//                                       initialSpringVelocity: 0,
//                                       options: UIViewAnimationOptions(),
//                                       animations: { self.view.layoutIfNeeded() },
//                                       completion: nil)
 
 
            // @production
            // Uncomment line below for non-animated constraints
            view.layoutIfNeeded()
            
            didAnimateLayout = true
        }
    }
    
}






