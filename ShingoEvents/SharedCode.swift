//
//  SharedCode.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 6/23/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    mutating func increment() -> Double {
        return self.advancedBy(1.0)
    }
}

// Shingo IP Colors
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
        if self.isEqualToDate(NSDate().notionallyEmptyDate()) {
            return true
        } else {
            return false
        }
    }
    
    func notionallyEmptyDate() -> NSDate {
        return NSDate.init(timeIntervalSince1970: -9999999999.9)
    }
    
}

func ==(left: SIDateTuple, right: SIDateTuple) -> Bool {
    if left.first == right.first && left.last == right.last {
        return true
    } else {
        return false
    }
}

func !=(left: SIDateTuple, right: SIDateTuple) -> Bool {
    if left.first == right.first && left.last == right.last {
        return false
    } else {
        return true
    }
}

func >(left: SIDateTuple, right: SIDateTuple) -> Bool {
    if left.first.isGreaterThanDate(right.first) {return true}
    if left.first == right.first && left.last.isGreaterThanDate(right.last){return true}
    return false
}

func <(left: SIDateTuple, right: SIDateTuple) -> Bool {
    if left.first.isLessThanDate(right.first) {
        return true
    }
    
    if left.last.isLessThanDate(right.last) {
        return true
    }
    
    return false
}

class SIDateTuple {
    var dates : (NSDate, NSDate)
    
    var first : NSDate {
        get {
            return dates.0
        }
    }
    
    var last : NSDate {
        get {
            return dates.1
        }
    }
    
    init() {
        self.dates = (NSDate().notionallyEmptyDate(), NSDate().notionallyEmptyDate())
    }
    
    init(first: NSDate, last: NSDate) {
        dates.0 = first
        dates.1 = last
    }
    
    init(firstAndLast: (NSDate, NSDate)) {
        dates.0 = firstAndLast.0
        dates.1 = firstAndLast.1
    }
    
    func isNotionallyEmpty() -> Bool {
        if dates.0.isNotionallyEmpty() && dates.1.isNotionallyEmpty() {
            return true
        } else {
            return false
        }
    }
}










