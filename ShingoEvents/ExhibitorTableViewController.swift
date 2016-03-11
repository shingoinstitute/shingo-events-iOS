//
//  ExhibitorTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 1/27/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import AVFoundation
import PureLayout


class ExhibitorCell: UITableViewCell {
    
    var didSetupConstraints = false
    
    var exhibitorImage:UIImageView = UIImageView.newAutoLayoutView()
    var label:UILabel = UILabel.newAutoLayoutView()
    
    var exhibitor:Exhibitor!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .DisclosureIndicator
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.accessoryType = .DisclosureIndicator        
        setupViews()
    }
    
    
    func setupViews()
    {
        contentView.addSubview(exhibitorImage)
        contentView.addSubview(label)
    }
    
    override func updateConstraints() {
        if !didSetupConstraints
        {
            NSLayoutConstraint.autoSetPriority(UILayoutPriorityRequired) {
                self.exhibitorImage.autoSetContentCompressionResistancePriorityForAxis(.Vertical)
            }
            let cellMargin: CGFloat = 8.0
            var width:CGFloat = (exhibitorImage.image?.size.width)!
            var height:CGFloat = (exhibitorImage.image?.size.height)!
            let aspectRatio = height / width
            
            if exhibitorImage.image?.size.width > 200 {
                width = (contentView.frame.width / 2.0) - cellMargin
                height = width * aspectRatio
            }
            
            exhibitorImage.autoSetDimensionsToSize(CGSize(width: width, height: height))
            exhibitorImage.autoAlignAxis(.Horizontal, toSameAxisOfView: contentView)
            exhibitorImage.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: 8.0)
            
            label.text = exhibitor.name
            label.numberOfLines = 4
            label.lineBreakMode = .ByWordWrapping
            label.font = UIFont.boldSystemFontOfSize(14.0)
            
            label.autoPinEdgeToSuperviewEdge(.Top)
            label.autoPinEdge(.Left, toEdge: .Right, ofView: exhibitorImage, withOffset: 8.0)
            label.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -10.0)
            label.autoPinEdgeToSuperviewEdge(.Bottom)
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    
}

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////

class ExhibitorTableViewController: UITableViewController {

    var exhibitors:[Exhibitor]!
    var dataToSend:Exhibitor!
    var sectionInformation = [(Character, [Exhibitor])]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150.0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeCategoryChanged", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }

    func contentSizeCategoryChanged(notification: NSNotification) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionInformation.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionInformation[section].1.count
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(netHex: 0xbc7820)
        let header = UILabel()
        header.text = String(sectionInformation[section].0).uppercaseString
        header.textColor = .whiteColor()
        header.font = UIFont.boldSystemFontOfSize(16.0)
        header.backgroundColor = .clearColor()
        
        view.addSubview(header)
        header.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0))
        
        return view
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell :ExhibitorCell = ExhibitorCell()
        let exhibitor = sectionInformation[indexPath.section].1[indexPath.row]
        cell.exhibitor = exhibitor
        cell.exhibitorImage.image = exhibitor.logo_image
        cell.contentView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 150)
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }


    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ExhibitorCell
        dataToSend = cell.exhibitor
        performSegueWithIdentifier("ExhibitorInfoView", sender: self)
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150.0
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ExhibitorInfoView" {
            let destination = segue.destinationViewController as! ExhibitorInfoViewController
            destination.exhibitor = self.dataToSend
        }
    }
    
    func characterForSection(section: Int) -> Character {
        switch section {
        case 0: return "a"
        case 1: return "b"
        case 2: return "c"
        case 3: return "d"
        case 4: return "e"
        case 5: return "f"
        case 6: return "g"
        case 7: return "h"
        case 8: return "i"
        case 9: return "j"
        case 10: return "k"
        case 11: return "l"
        case 12: return "m"
        case 13: return "n"
        case 14: return "o"
        case 15: return "p"
        case 16: return "q"
        case 17: return "r"
        case 18: return "s"
        case 19: return "t"
        case 20: return "u"
        case 21: return "v"
        case 22: return "w"
        case 23: return "x"
        case 24: return "y"
        case 25: return "z"
        default: return "#"
        }
    }

}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
