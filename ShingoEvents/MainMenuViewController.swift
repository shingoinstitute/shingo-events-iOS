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
    
    // Activity view used for loading screen
    let activityView = ActivityView()
    var eventsDidLoad = false
    var timer : NSTimer!
    var time : Double = 0
    var events : [SIEvent]?
    
    // used to set inital placement of menu items off screen so they can later be animated
    var contentViewHeightConstraint: NSLayoutConstraint?
    
    // buttons
    @IBOutlet weak var eventsBtn: UIButton!
    @IBOutlet weak var shingoModelBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var reloadEventsBtn: UIButton!
    
    // Other views
    var menuBackgroundImage: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .whiteColor()
        return view
    }()
    var shingoLogoImageView : UIImageView = UIImageView.newAutoLayoutView()
    var contentView: UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = SIColor().prussianBlueColor.colorWithAlphaComponent(0.5)
        return view
    }()

    
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
        setupView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBarHidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        self.animateLayout()
    }

    func setupView() {
        eventsBtn.removeFromSuperview()
        shingoModelBtn.removeFromSuperview()
        settingsBtn.removeFromSuperview()
        reloadEventsBtn.removeFromSuperview()
        
        contentView.addSubview(eventsBtn)
        contentView.addSubview(shingoModelBtn)
        contentView.addSubview(settingsBtn)
        contentView.addSubview(reloadEventsBtn)
        
        menuBackgroundImage.image = ShingoIconImages().shingoIconForDevice()
        
        view.addSubview(menuBackgroundImage)
        view.addSubview(contentView)
        view.bringSubviewToFront(contentView)
        view.addSubview(self.shingoLogoImageView)
        view.bringSubviewToFront(self.shingoLogoImageView)
        
        shingoLogoImageView.image = UIImage(named: "Shingo logo with Home BIG")
        shingoLogoImageView.contentMode = .ScaleAspectFit
        
        menuBackgroundImage.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
        menuBackgroundImage.autoPinEdge(.Left, toEdge: .Left, ofView: view)
        menuBackgroundImage.autoPinEdge(.Right, toEdge: .Right, ofView: view)
        menuBackgroundImage.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: view)
        
        contentView.autoSetDimension(.Height, toSize: 265)
        contentViewHeightConstraint = contentView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: view, withOffset: -view.frame.height)
        contentView.autoPinEdge(.Left, toEdge: .Left, ofView: view, withOffset: 5.0)
        contentView.autoPinEdge(.Right, toEdge: .Right, ofView: view, withOffset: -5.0)
        
        eventsBtn.autoSetDimension(.Height, toSize: 60)
        eventsBtn.autoPinEdge(.Top, toEdge: .Top, ofView: contentView, withOffset: 5)
        eventsBtn.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 5)
        eventsBtn.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -5)
        
        shingoModelBtn.autoSetDimension(.Height, toSize: 60)
        shingoModelBtn.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 5)
        shingoModelBtn.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -5)
        shingoModelBtn.autoPinEdge(.Top, toEdge: .Bottom, ofView: eventsBtn, withOffset: 5)
        
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
            button.backgroundColor = UIColor(white: 0.9, alpha: 0.9)
            button.setTitleColor(SIColor().darkShingoBlueColor, forState: .Normal)
        }
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
        contentViewHeightConstraint?.constant = -80
        
//        Uncomment the line below to make constraints appear animated (for deployment)
//        UIView.animateWithDuration(1.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
        
//        Uncomment the line below to make menu options appear instantly (for production)
        UIView.animateWithDuration(0.01, delay: 0,
                                   usingSpringWithDamping: 0.01,
                                   initialSpringVelocity: 0, 
                                   options: UIViewAnimationOptions(), 
                                   animations: { self.view.layoutIfNeeded() },
                                   completion: nil)
    }
    
    @IBAction func didTapEvents(sender: AnyObject) {
        loadUpcomingEvents()
    }
    
    @IBAction func reloadEventData(sender: AnyObject) {
//        activityView.progressIndicator.progress = 0
//        activityView.animateProgress(0.9)
        activityView.displayActivityView(message: "Loading Upcoming Conferences", forView: self.view)
        SIRequest().requestEvents({ events in
            self.activityView.removeActivityViewFromDisplay()
            self.events = events
            self.eventsDidLoad = true
        })
    }
    @IBAction func didTapShingoModel(sender: AnyObject) {
        self.performSegueWithIdentifier("ShingoModel", sender: self)
    }
    
    @IBAction func didTapSupport(sender: AnyObject) {
        self.performSegueWithIdentifier("Support", sender: self)
    }

    func loadUpcomingEvents() {
        activityView.displayActivityView(message: "Loading Upcoming Conferences...", forView: self.view)
        if !SIRequest().checkForInternetConnection() {
            print("No internet connection detected")
            displayBadRequestNotification()
        } else if eventsDidLoad {
            self.performSegueWithIdentifier("EventsView", sender: self.events)
        } else {
            // Make buttons non clickable while loading indicator is present
            disableButtons(shouldDisable: true)
            // Show loading indicator, make request to server for upcoming events
            activityView.displayActivityView(message: "Loading Upcoming Conferences...", forView: self.view)
//            activityView.animateProgress(0.9)
            
            time = 0
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(MainMenuViewController.checkOnRequestStatus), userInfo: nil, repeats: true)
        }
    }
    
    func displayBadRequestNotification() {
        let alert = UIAlertController(title: "There seems to be a problem.",
                                      message: "We were unable to fetch any data for you. Please make sure you are connected to the internet.",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func checkOnRequestStatus() {
        time += 0.1
        
        if eventsDidLoad {
            timer.invalidate()
            activityView.removeActivityViewFromDisplay()
            performSegueWithIdentifier("EventsView", sender: self.events)
        }
        
        if time > 12.0 {
            timer.invalidate()
            activityView.removeActivityViewFromDisplay()
            displayBadRequestNotification()
        }
    }
    
    func disableButtons(shouldDisable disable:Bool){
        eventsBtn.enabled = !disable
        shingoModelBtn.enabled = !disable
        settingsBtn.enabled = !disable
        reloadEventsBtn.enabled = !disable
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "EventsView") {
            let destination = segue.destinationViewController as! EventsTableViewController
            activityView.removeActivityViewFromDisplay()
            if let events = sender as? [SIEvent] {
                destination.events = events
            }
        }
        
    }
    
}
