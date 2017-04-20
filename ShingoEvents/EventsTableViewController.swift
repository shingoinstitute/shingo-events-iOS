//
//  EventsViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/4/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import Foundation


class EventsTableViewController: UITableViewController {
    
    // MARK: - Properties
    var events: [SIEvent]!
    
    var gradientBackgroundView = UIView()
    
    var advertIsDonePresenting: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Upcoming Events"
        tableView.backgroundView = gradientBackgroundView
        gradientBackgroundView.backgroundColor = .lightShingoBlue
        
        let gradientLayer = RadialGradientLayer()
        gradientLayer.frame = gradientBackgroundView.bounds
        gradientBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
        
        tableView.estimatedRowHeight = 300;
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        // Begins API requests for each event.
        for event in events {
            if !event.didLoadEventData {
                event.requestEvent(nil)
                tableView.reloadData()
            }
        }
    }
    
    func displayBadRequestNotification() {
        let alert = UIAlertController(title: "Connection Not Detected",
                                      message: "We were unable to fetch any data for you, please make check your device's network connection.",
                                      preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension EventsTableViewController: SICellDelegate, SplashScreenViewDelegate {

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Event Cell", for: indexPath) as! EventTableViewCell;
        
        cell.event = events[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! EventTableViewCell
        cell.contentView.backgroundColor = .white
        
        let event = events[(indexPath as NSIndexPath).row]
        
        self.performSegue(withIdentifier: "EventMenu", sender: event)
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        
        guard let event = sender as? SIEvent else {
            return
        }
        
        let splashScreen = SplashScreenView(viewController: self, identifier: identifier, event: event)

        /**
         4 Cases to handle:
         
        | Event Did Load | Event Has Splash Ads | Outcome
        +----------------+----------------------+-------------------------------------------------------
        | Yes            | Yes                  | Display a splash ad
        | Yes            | No                   | Go straight to segue
        | No             | Yes                  | Load events, display a splash ad until complete
        | No             | No                   | Load events, display loading indicator until complete
        ------------------------------------------------------------------------------------------------
         */
        
        
        if event.didLoadEventData && event.hasSplashAds {
            present(splashScreen, animated: true) {
                self.onPresentSplashScreenComplete(identifier: identifier, event: event)
            }
            
        } else if event.didLoadEventData && !event.hasSplashAds {
            super.performSegue(withIdentifier: identifier, sender: event)
            
        } else if !event.didLoadEventData && event.hasSplashAds {
            present(splashScreen, animated: true) {
                event.requestEvent() {
                    self.onPresentSplashScreenComplete(identifier: identifier, event: event)
                }
            }
            
        } else {
            present(ActivityViewController(message: "Fetching Data"), animated: true) {
                event.requestEvent() {
                    self.dismiss(animated: false, completion: {
                        super.performSegue(withIdentifier: identifier, sender: event)
                    })
                }
            }
        }
        
    }
    
    /**
     onPresentSplashScreenComplete allows the view to dismiss a `SplashScreenView` and perform a segue at the correct time.
     The view will dismiss a `SplashScreenView` and let the view controller perform a segue when:
     
     a) An event has already loaded its data, but still needs to display a sponsor ad, or
     
     b) A sponsor ad has been displayed for a predetermined length of time but the event is still loading its data
     
     - parameter identifier: The identfier of the viewController to be segued to.
     - parameter event: The event object to be displayed on the following viewController.
     */
    func onPresentSplashScreenComplete(identifier: String, event: SIEvent) {
        if !event.hasSplashAds && event.didLoadEventData {
            dismiss(animated: false) {
                super.performSegue(withIdentifier: identifier, sender: event)
            }
        } else if event.didDisplaySponsorAd && event.didLoadEventData {
            dismiss(animated: false) {
                super.performSegue(withIdentifier: identifier, sender: event)
            }
            event.didDisplaySponsorAd = false
        }
    }
}

extension EventsTableViewController {
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EventMenu" {
            let destination = segue.destination as! EventMenuViewController
            if let event = sender as? SIEvent {
                destination.event = event
            }
            navigationItem.title = ""
        }
    }
    
    func cellDidUpdate() {
        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
}



