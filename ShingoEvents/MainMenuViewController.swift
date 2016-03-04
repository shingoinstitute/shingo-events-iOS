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
    
    @IBOutlet weak var eventsBtn: UIButton!
    @IBOutlet weak var shingoModelBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    
    var menuBackgroundImage: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .whiteColor()
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = UIColor(red: 0, green: 47.0/255.0, blue: 86.0/255.0, alpha: 0.5)
        return view
    }()
    
    let activitiyViewController = ActivityViewController(message: "Loading Data...")
    var appData:AppData!
    
    var contentViewHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventsBtn.removeFromSuperview()
        shingoModelBtn.removeFromSuperview()
        settingsBtn.removeFromSuperview()
        
        contentView.addSubview(eventsBtn)
        contentView.addSubview(shingoModelBtn)
        contentView.addSubview(settingsBtn)
        
        menuBackgroundImage.image = ShingoIconImages().shingoIconForDevice()
        view.addSubview(menuBackgroundImage)
        view.addSubview(contentView)
        view.bringSubviewToFront(contentView)
        
        menuBackgroundImage.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
        menuBackgroundImage.autoPinEdge(.Left, toEdge: .Left, ofView: view)
        menuBackgroundImage.autoPinEdge(.Right, toEdge: .Right, ofView: view)
        menuBackgroundImage.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: view)
        
        contentView.autoSetDimension(.Height, toSize: 200)
        contentViewHeightConstraint = contentView.autoAlignAxis(.Horizontal, toSameAxisOfView: view, withOffset: view.frame.height)
        contentView.autoPinEdge(.Left, toEdge: .Left, ofView: view, withOffset: 5.0)
        contentView.autoPinEdge(.Right, toEdge: .Right, ofView: view, withOffset: -5.0)

        eventsBtn.autoSetDimension(.Height, toSize: 60)
        eventsBtn.autoPinEdge(.Top, toEdge: .Top, ofView: contentView, withOffset: 5)
        eventsBtn.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 5)
        eventsBtn.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -5)
        
        shingoModelBtn.autoSetDimension(.Height, toSize: 60)
        shingoModelBtn.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 5)
        shingoModelBtn.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -5)
        shingoModelBtn.autoAlignAxis(.Horizontal, toSameAxisOfView: contentView)
        
        settingsBtn.autoSetDimension(.Height, toSize: 60)
        settingsBtn.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 5)
        settingsBtn.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -5)
        settingsBtn.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: contentView, withOffset: -5)
        
        
        let buttons:NSArray = [eventsBtn, shingoModelBtn, settingsBtn]
        for button in buttons
        {
            contentView.bringSubviewToFront(button as! UIView)
            (button as! UIButton).backgroundColor = UIColor(white: 0.9, alpha: 0.9)
        }
        
        loadUpcomingEvents()

    }
    
    func animateLayout() {
        contentViewHeightConstraint?.constant = view.frame.height * CGFloat(-0.1)
        UIView.animateWithDuration(1.5, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        print("Hey, yeah you, the one with the face. You got a memory warning.")
    }
    
    @IBAction func didTapEvents(sender: AnyObject) {
        self.performSegueWithIdentifier("EventsView", sender: self)
    }
    
    @IBAction func reloadEventData(sender: AnyObject) {
        appData = nil
        loadUpcomingEvents()
    }
    @IBAction func didTapShingoModel(sender: AnyObject) {
        self.performSegueWithIdentifier("ShingoModel", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "EventsView")
        {
            let dest_vc = segue.destinationViewController as! EventsTableViewController
            dest_vc.appData = self.appData
        }
        
    }
    
    func loadUpcomingEvents() {
        if self.appData == nil
        {
            self.presentViewController(self.activitiyViewController, animated: true, completion: nil)
            self.activitiyViewController.updateProgress(0.1)
            
            
            Alamofire.request(.GET, "https://shingo-events.herokuapp.com/api").response { // Poke the server
                    _ in
                    self.activitiyViewController.updateProgress(0.5)
                    self.appData = AppData()
                    self.appData.getUpcomingEvents() {
                        self.activitiyViewController.updateProgress(1.0)
                        self.dismissViewControllerAnimated(true, completion: nil)
                        self.animateLayout()
                    }
            }
        }
    }
    
}
