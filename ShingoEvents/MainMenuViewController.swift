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
    
    // Activity view used for the loading screen
    var activityView : ActivityViewController = {
        let view = ActivityViewController()
        view.message = "Loading Upcoming Conferences..."
        return view
    }()
    var eventsDidLoad = false
    var timer : NSTimer!
    var time : Double = 0
    var events : [SIEvent]?
    
    // used to set inital placement of menu items off screen so they can later be animated
    var contentViewHeightConstraint: NSLayoutConstraint!
    
    // buttons
    @IBOutlet weak var eventsBtn: UIButton!
    @IBOutlet weak var shingoModelBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var reloadEventsBtn: UIButton!
    
    // Other views
    var menuBackgroundImage: UIImageView = {
        let view = UIImageView.newAutoLayoutView()
        view.backgroundColor = .whiteColor()
        view.image = SIImages().shingoIconForDevice()
        return view
    }()
    var shingoLogoImageView : UIImageView = {
        let view = UIImageView.newAutoLayoutView()
        if let image = UIImage(named: "shingo_icon_with_home_Large") {
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
    
    var didSetupConstraints = false
    var didAnimateLayout = false
    
    // MARK: - class methods
    
    override func loadView() {
        super.loadView()
        
        SIRequest().requestEvents({ events in
            self.events = events
            self.eventsDidLoad = true
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            
            eventsBtn.removeFromSuperview()
            shingoModelBtn.removeFromSuperview()
            settingsBtn.removeFromSuperview()
            reloadEventsBtn.removeFromSuperview()
            
            contentView.addSubview(eventsBtn)
            contentView.addSubview(shingoModelBtn)
            contentView.addSubview(settingsBtn)
            contentView.addSubview(reloadEventsBtn)

            view.addSubview(menuBackgroundImage)
            view.addSubview(contentView)
            view.bringSubviewToFront(contentView)
            view.addSubview(shingoLogoImageView)
            view.bringSubviewToFront(shingoLogoImageView)
            
            menuBackgroundImage.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
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
            shingoModelBtn.autoPinEdge(.Top, toEdge: .Bottom, ofView: eventsBtn, withOffset: 5)
            shingoModelBtn.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 5)
            shingoModelBtn.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -5)
            
            settingsBtn.autoSetDimension(.Height, toSize: 60)
            settingsBtn.autoPinEdge(.Top, toEdge: .Bottom, ofView: shingoModelBtn, withOffset: 5)
            settingsBtn.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 5)
            settingsBtn.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -5)
            
            reloadEventsBtn.autoSetDimension(.Height, toSize: 60)
            reloadEventsBtn.autoPinEdge(.Top, toEdge: .Bottom, ofView: settingsBtn, withOffset: 5)
            reloadEventsBtn.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 5)
            reloadEventsBtn.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -5)
            
            shingoLogoImageView.autoSetDimension(.Height, toSize: 125)
            shingoLogoImageView.autoPinToTopLayoutGuideOfViewController(self, withInset: 8)
            shingoLogoImageView.autoPinEdgeToSuperviewEdge(.Left, withInset: 8)
            shingoLogoImageView.autoPinEdgeToSuperviewEdge(.Right, withInset: 8)
            
            let buttons:NSArray = [eventsBtn, shingoModelBtn, settingsBtn, reloadEventsBtn]
            for button in buttons as! [UIButton] {
                contentView.bringSubviewToFront(button)
                button.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.75)
                button.layer.cornerRadius = 5
                button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                
                let arrow = UILabel.newAutoLayoutView()
                arrow.text = ">"
                arrow.font = UIFont(name: "Helvetica", size: 18)
                arrow.textColor = .whiteColor()
                button.addSubview(arrow)
                
                arrow.autoSetDimension(.Width, toSize: 20)
                arrow.autoPinEdge(.Right, toEdge: .Right, ofView: button, withOffset: -5)
                arrow.autoPinEdge(.Top, toEdge: .Top, ofView: button, withOffset: 0)
                arrow.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: button, withOffset: 0)
            }
            
//            for button in buttons as! [UIButton] {
//                contentView.bringSubviewToFront(button)
//                button.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
//                button.layer.cornerRadius = 5
//                button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
//            }
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    func displayInternetAlert() {
        let alert = UIAlertController(
            title: "No Internet Connection Detected",
            message: "Your device must be connected to the internet to use this app.",
            preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel) { _ in
            self.animateLayout()
        }
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func animateLayout() {
        if !didAnimateLayout {
            
            // Sets new constraint constant to make the menu appear onscreen in an appropriate position depending on the screen size.
            switch Int(UIDevice.currentDevice().deviceType.rawValue) {
            case 1 ..< 3:
                contentViewHeightConstraint.constant = -50
            case 3 ..< 4:
                contentViewHeightConstraint.constant = -60
            case 4 ..< 6:
                contentViewHeightConstraint.constant = -80
            case 6 ..< 8:
                contentViewHeightConstraint.constant = -view.frame.height / 3
            default:
                contentViewHeightConstraint.constant = -80
            }
            
            // @deployment
            // Uncomment lines below to use animated constraints
            /*        
                    UIView.animateWithDuration(1.5,
                                               delay: 0.2,
                                               usingSpringWithDamping: 0.5,
                                               initialSpringVelocity: 0,
                                               options: UIViewAnimationOptions(),
                                               animations: { self.view.layoutIfNeeded() },
                                               completion: nil)
            */
 
            // @production
            // Uncomment line below to make the menu (contentView) appear instantly (non animated)
            view.layoutIfNeeded()
            
            didAnimateLayout = true
        }
    }
    
    @IBAction func didTapEvents(sender: AnyObject) {
        loadUpcomingEvents()
    }
    
    @IBAction func reloadEventData(sender: AnyObject) {
        presentViewController(activityView, animated: true) {
            SIRequest().requestEvents({ events in
                self.dismissViewControllerAnimated(true, completion: nil)
                self.events = events
                self.eventsDidLoad = true
            })
        }
        
    }
    @IBAction func didTapShingoModel(sender: AnyObject) {
        self.performSegueWithIdentifier("ShingoModel", sender: self)
    }
    
    @IBAction func didTapSupport(sender: AnyObject) {
        self.performSegueWithIdentifier("Support", sender: self)
    }

    func loadUpcomingEvents() {

        if eventsDidLoad {
            performSegueWithIdentifier("EventsView", sender: self.events)
        } else if !Reach().checkForInternetConnection() {
            displayBadRequestNotification()
        } else {
            presentViewController(activityView, animated: false, completion: {
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
        time += 0.1
        
        if eventsDidLoad {
            timer.invalidate()
            time = 0
            self.dismissViewControllerAnimated(true, completion: {
                self.performSegueWithIdentifier("EventsView", sender: self.events)
            });
        }
        
        if time > 12.0 {
            timer.invalidate()
            time = 0
            self.dismissViewControllerAnimated(true, completion: { 
                self.displayBadRequestNotification()
            });
        }
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EventsView" {
            let destination = segue.destinationViewController as! EventsTableViewController
            if let events = sender as? [SIEvent] {
                destination.events = events
            }
        }
        
    }
    
}
