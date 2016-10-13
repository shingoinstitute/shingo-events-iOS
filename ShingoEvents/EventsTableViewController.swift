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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Upcoming Events"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = gradientBackgroundView
        gradientBackgroundView.backgroundColor = .lightShingoBlue
        
        let gradientLayer = RadialGradientLayer()
        gradientLayer.frame = gradientBackgroundView.bounds
        gradientBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
        
        tableView.estimatedRowHeight = 200;
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
        let alert = UIAlertController(title: "Oops!",
                                      message: "We were unable to fetch any data for you. Please make sure you have an internet connection.",
                                      preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension EventsTableViewController: SICellDelegate {

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Event Cell", for: indexPath) as! EventTableViewCell;

        cell.backgroundColor = .clear
        cell.cardView.backgroundColor = .white
        
        cell.event = events[indexPath.row]
        
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let event = events[(indexPath as NSIndexPath).row]
        
        if event.didLoadEventData {
            self.performSegue(withIdentifier: "EventMenu", sender: event)
            
        } else {
            let activityView = ActivityViewController(message: "Downloading Event Data...")
            present(activityView, animated: false, completion: {
                event.requestEvent() {
                    self.dismiss(animated: true, completion: {
                        if event.didLoadEventData {
                            self.performSegue(withIdentifier: "EventMenu", sender: self.events[(indexPath as NSIndexPath).row])
                        } else {
                            self.displayBadRequestNotification()
                        }
                    })
                }
            })
        }
    }
    
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
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}

class RadialGradientLayer: CALayer {
    
    override init(){
        
        super.init()
        
        needsDisplayOnBoundsChange = true
    }

    
    required init(coder aDecoder: NSCoder) {
        
        super.init()
        
    }
    
    override func draw(in ctx: CGContext) {
        
        ctx.saveGState()
        
        let locations:[CGFloat] = [0.0, 1.0]
        let gradColors: [CGFloat] = [0, 0, 0, 0, 0, 0 , 0, 0.5]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: gradColors, locations: locations, count: 2)!
        
        let gradCenter = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        let gradRadius = min(self.bounds.size.width, self.bounds.size.height)
        
        ctx.drawRadialGradient(gradient, startCenter: gradCenter, startRadius: 0, endCenter: gradCenter, endRadius: gradRadius, options: CGGradientDrawingOptions.drawsAfterEndLocation)

        
    }
    
}



