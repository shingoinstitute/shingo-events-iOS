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

class MainMenuViewController: UIViewController {
    
    //Mark: - Properties
    var events : [SIEvent]?
    
    // Activity view used for the loading screen
    var activityView : ActivityViewController = {
        let view = ActivityViewController()
        view.message = "Loading Upcoming Conferences..."
        return view
    }()
    
    var timer : NSTimer!
    var time : Double!
    
    // Used to set inital placement of menu items off screen so they can later be animated
    var contentViewHeightConstraint: NSLayoutConstraint!
    
    // Menu buttons
    @IBOutlet weak var eventsBtn: UIButton!
    @IBOutlet weak var shingoModelBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    
    @IBOutlet weak var copyRightLabel: UILabel!
    
    
    // Other views
    var menuBackgroundImage: UIImageView = {
        let view = UIImageView.newAutoLayoutView()
        view.backgroundColor = .whiteColor()
        view.contentMode = .ScaleAspectFill
        view.image = UIImage(named: "Shingo Icon Fullscreen")
        return view
    }()
    var shingoLogoImageView : UIImageView = {
        let view = UIImageView.newAutoLayoutView()
        if let image = UIImage(named: "Shingo Title") {
            view.image = image
        }
        view.contentMode = .ScaleAspectFit
        return view
    }()
    var contentView: UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = .clearColor()
        return view
    }()
    
    var eventsDidLoad = false
    var didSetupConstraints = false
    var didAnimateLayout = false
    
    // MARK: - Setup
    
    override func loadView() {
        super.loadView()
        
        SIRequest().requestEvents({ events in
            if let events = events {
                self.events = events
                self.eventsDidLoad = true
            }
        });
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = ""
        
        if let nav = navigationController?.navigationBar {
            nav.barStyle = UIBarStyle.Black
            nav.tintColor = UIColor.yellowColor()
        }
        
        updateViewConstraints()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBarHidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.animateLayout()
    }

    override func updateViewConstraints() {
        if !didSetupConstraints {
            
            contentView.addSubviews([eventsBtn, shingoModelBtn, settingsBtn])

            view.addSubviews([menuBackgroundImage, contentView, shingoLogoImageView])
            
            view.bringSubviewToFront(copyRightLabel)
            
            menuBackgroundImage.autoPinEdgeToSuperviewEdge(.Top)
            menuBackgroundImage.autoPinEdge(.Left, toEdge: .Left, ofView: view)
            menuBackgroundImage.autoPinEdge(.Right, toEdge: .Right, ofView: view)
            menuBackgroundImage.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: view)
            
            contentView.autoSetDimension(.Height, toSize: 265)
            contentViewHeightConstraint = contentView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: view, withOffset: -view.frame.height)
            if UIDevice.currentDevice().deviceType.rawValue >= 6.0 {
                contentView.autoPinEdge(.Left, toEdge: .Left, ofView: view, withOffset: 200.0)
                contentView.autoPinEdge(.Right, toEdge: .Right, ofView: view, withOffset: -200.0)
            } else {
                contentView.autoPinEdge(.Left, toEdge: .Left, ofView: view, withOffset: 10.0)
                contentView.autoPinEdge(.Right, toEdge: .Right, ofView: view, withOffset: -10.0)
            }
        
            eventsBtn.autoSetDimension(.Height, toSize: 60)
            eventsBtn.autoPinEdge(.Top, toEdge: .Top, ofView: contentView, withOffset: 5)
            eventsBtn.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 5)
            eventsBtn.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -5)
            
            shingoModelBtn.autoSetDimension(.Height, toSize: 60)
            shingoModelBtn.autoPinEdge(.Top, toEdge: .Bottom, ofView: eventsBtn, withOffset: 8)
            shingoModelBtn.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 5)
            shingoModelBtn.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -5)
            
            settingsBtn.autoSetDimension(.Height, toSize: 60)
            settingsBtn.autoPinEdge(.Top, toEdge: .Bottom, ofView: shingoModelBtn, withOffset: 8)
            settingsBtn.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 5)
            settingsBtn.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -5)
            
            shingoLogoImageView.autoSetDimension(.Height, toSize: 125)
            shingoLogoImageView.autoPinToTopLayoutGuideOfViewController(self, withInset: 8)
            shingoLogoImageView.autoPinEdgeToSuperviewEdge(.Left, withInset: 8)
            shingoLogoImageView.autoPinEdgeToSuperviewEdge(.Right, withInset: 8)
            
            let buttons:NSArray = [eventsBtn, shingoModelBtn, settingsBtn]
            for button in buttons as! [UIButton] {
                contentView.bringSubviewToFront(button)
                button.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.75)
                button.layer.cornerRadius = 5
                button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                
                let arrow = UIImageView()
                arrow.image = UIImage(named: "right-arrow")
                arrow.contentMode = .ScaleAspectFit

                button.addSubview(arrow)
                
                arrow.autoSetDimensionsToSize(CGSizeMake(30, 30))
                arrow.autoPinEdge(.Right, toEdge: .Right, ofView: button, withOffset: -8)
                arrow.autoAlignAxis(.Horizontal, toSameAxisOfView: button)
            }
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    @IBAction func didTapEvents(sender: AnyObject) {
        loadUpcomingEvents()
    }
    
    @IBAction func didTapShingoModel(sender: AnyObject) {
        self.performSegueWithIdentifier("ShingoModel", sender: self)
    }
    
    @IBAction func didTapSupport(sender: AnyObject) {
        self.performSegueWithIdentifier("Support", sender: self)
    }
    
    //Mark: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EventsView" {
            let destination = segue.destinationViewController as! EventsTableViewController
            if let events = sender as? [SIEvent] {
                destination.events = events
            }
        }
        
        if segue.identifier == "Support" {
            let destination = segue.destinationViewController as! SettingsTableViewController
            destination.delegate = self
        }
        
    }
    
}

extension MainMenuViewController {
    
    //MARK: - Class Methods
    func displayInternetAlert() {
        let alert = UIAlertController(
            title: "Internet Connection Not Detected",
            message: "Your device must be connected to the internet to recieve data about conferences and events.",
            preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel) { _ in
            self.animateLayout()
        }
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func animateLayout() {
        if !didAnimateLayout {
            
            // Sets new constraint constant to make the menu appear onscreen in an appropriate position depending on screen size.
            switch UIDevice.currentDevice().deviceType.rawValue {
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
//            UIView.animateWithDuration(1.5,
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

    func loadUpcomingEvents() {
        if !Reach().checkForInternetConnection() {
            displayInternetAlert()
        } else if eventsDidLoad {
            performSegueWithIdentifier("EventsView", sender: self.events)
        } else {
            presentViewController(activityView, animated: false, completion: {
                self.time = 0
                self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1,
                                                                    target: self,
                                                                    selector: #selector(MainMenuViewController.checkOnRequestStatus), 
                                                                    userInfo: nil, 
                                                                    repeats: true)
            });
        }
    }
    
    func displayBadRequestNotification() {
        let alert = UIAlertController(title: "There seems to be a problem.",
                                      message: "We were unable to fetch any data for you. Please make sure you are connected to the internet.",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        dismissViewControllerAnimated(true, completion: {
            self.presentViewController(alert, animated: true, completion: nil)
        });
    }
    
    func checkOnRequestStatus() {
        time! += 0.1
        
        if eventsDidLoad {
            timer.invalidate()
            self.dismissViewControllerAnimated(true, completion: {
                self.performSegueWithIdentifier("EventsView", sender: self.events)
            });
        } else if time > 12.0 {
            timer.invalidate()
            self.dismissViewControllerAnimated(true, completion: { 
                self.displayBadRequestNotification()
            });
        }
    }
    
}

extension MainMenuViewController: UnwindToMainVCProtocol {
    // Protocal for passing data back from the Support 
    // page when the 'reload data' button is pressed
    func updateEvents(events: [SIEvent]?) {
        if let events = events {
            self.events = events
        }
    }
}





