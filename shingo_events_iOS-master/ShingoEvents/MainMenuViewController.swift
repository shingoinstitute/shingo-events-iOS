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
    
    @IBOutlet weak var eventsBtn: UIButton!
    @IBOutlet weak var shingoModelBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var menuBackgroundImage: UIImageView!

    var appData:AppData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let activitiyViewController = ActivityViewController(message: "Loading Data...")
        if appData == nil {
            appData = AppData()
            self.presentViewController(activitiyViewController, animated: true, completion: nil)
            appData.getUpcomingEvents() {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        menuBackgroundImage.image = UIImage(named: "shingo_icon_skinny")
        view.bringSubviewToFront(eventsBtn)
        view.bringSubviewToFront(shingoModelBtn)
        view.bringSubviewToFront(settingsBtn)
        
        eventsBtn.layer.cornerRadius = 5.0
        shingoModelBtn.layer.cornerRadius = 5.0
        settingsBtn.layer.cornerRadius = 5.0
    }
    

    @IBAction func didTapEvents(sender: AnyObject) {
        self.performSegueWithIdentifier("EventsView", sender: self)
    }
    
    
    @IBAction func didTapShingoModel(sender: AnyObject) {
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "EventsView") {
            let dest_vc = segue.destinationViewController as! EventsTableViewController
            dest_vc.appData = self.appData
        }
    }
    
}
