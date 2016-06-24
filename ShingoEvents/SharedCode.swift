//
//  SharedCode.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 6/23/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit

struct SIColor {
    
    let lightBlueColor = UIColor(netHex: 0x155c97)
    let shingoBlueColor = UIColor(netHex: 0x002f56)
    let shingoRedColor = UIColor(netHex: 0x650820)
    let darkShingoBlueColor = UIColor(netHex: 0x0e2145)
    let shingoOrangeColor = UIColor(netHex: 0xcd8931)
    let prussianBlueColor = UIColor(netHex: 0x002F56)
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

extension String {
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
}

extension NSDate {
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        return (compare(dateToCompare) == NSComparisonResult.OrderedDescending)
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        return (compare(dateToCompare) == NSComparisonResult.OrderedAscending)
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        return (compare(dateToCompare) == NSComparisonResult.OrderedSame)
    }
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: NSTimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}

extension NSDate {
    func isNotionallyEmpty() -> Bool {
        if self.isEqualToDate(NSDate.init(timeIntervalSince1970: 0)) {
            return true
        } else {
            return false
        }
    }
}













