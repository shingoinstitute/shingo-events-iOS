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
    
    let shingoImage = ShingoIconImages()
    
    var menuBackgroundImage: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .whiteColor()
        return view
    }()
    
    let activitiyViewController = ActivityViewController(message: "Loading Data...")
    var appData:AppData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.appData == nil
        {
            self.presentViewController(self.activitiyViewController, animated: true, completion: nil)
            self.activitiyViewController.updateProgress(0.1)
            

            Alamofire.request(.GET, "https://shingo-events.herokuapp.com/api").response // Poke the server
            {
                _ in
                self.activitiyViewController.updateProgress(0.5)
                self.appData = AppData()
                self.appData.getUpcomingEvents() {
                    self.activitiyViewController.updateProgress(1.0)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }

        menuBackgroundImage.image = shingoImage.getShingoIconForDevice()
        view.addSubview(menuBackgroundImage)
        
        menuBackgroundImage.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
        menuBackgroundImage.autoPinEdge(.Left, toEdge: .Left, ofView: view)
        menuBackgroundImage.autoPinEdge(.Right, toEdge: .Right, ofView: view)
        menuBackgroundImage.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: view)
        
        let buttons:NSArray = [eventsBtn, shingoModelBtn, settingsBtn]
        
        for button in buttons
        {
            view.bringSubviewToFront(button as! UIView)
            button.layer.cornerRadius = 20.0 as CGFloat
            button.layer.borderColor = UIColor.grayColor().CGColor
            button.layer.borderWidth = 1
        }
        

    }
    
    override func didReceiveMemoryWarning() {
        print("Hey, yeah you, the one with the face. You got a memory warning.")
    }
    
    @IBAction func didTapEvents(sender: AnyObject) {
        self.performSegueWithIdentifier("EventsView", sender: self)
    }
    
    @IBAction func reloadEventData(sender: AnyObject) {
        appData = nil
        self.presentViewController(activitiyViewController, animated: true, completion: nil)
        appData = AppData()
        appData.getUpcomingEvents() {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
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
    
}
