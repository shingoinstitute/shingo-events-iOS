//
//  SharedCode.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 6/23/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit

struct Alphabet {
    
    func alphabet() -> [String] {
        var alphabet = [String]()
        for char in Array("ABCDEFGHIJKLM‌​NOPQRSTUVWXYZ#".characters) {
            alphabet.append(String(char))
        }
        return alphabet
    }
    
}

extension Double {
    mutating func increment() -> Double {
        return self.advancedBy(1.0)
    }
}

extension UIImage {
    func isEmpty() -> Bool {
        return CGImage == nil && CIImage == nil
    }
    
    /// Returns the filezise in KB of a UIImage in a PNG format.
    func fileSizeOfPNG() -> Int {
        if let representation = UIImagePNGRepresentation(self) {
            return NSData(data: representation).length / 1024
        }
        return -9999
    }
    
    /// Returns the filesize in KB of a UIImage in a JPEG format with a compression quality of 1.
    func fileSizeOfJPEG() -> Int {
        if let representation = UIImageJPEGRepresentation(self, 1) {
            return NSData(data: representation).length / 1024
        }
        return -9999
    }
    
    /// Returns the filesize in KB of a UIImage in a JPEG format with a given compression quality.
    func fileSizeOfJPEG(compressionQuality quality: CGFloat) -> Int {
        if let representation = UIImageJPEGRepresentation(self, quality) {
            return NSData(data: representation).length / 1024
        }
        return -9999
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
    
    func split(character: Character) -> [String?]{
        return self.characters.split{$0 == character}.map(String.init)
    }
    
}

///////////////////////
// NSDate Extensions //
///////////////////////

func > (left: NSDate, right: NSDate) -> Bool {
    if left.isGreaterThanDate(right) {
        return true
    } else {
        return false
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
        return NSDate.init(timeIntervalSince1970: 0)
    }
    
}

// NSDateFormatter Extension

extension NSDateFormatter {
    
    /// Returns an object initialized with a set locale, date format, and time zone.
    convenience init(locale: String, dateFormat: String, timeZone: String) {
        self.init()
        self.locale = NSLocale(localeIdentifier: locale)
        self.dateFormat = dateFormat
        self.timeZone = NSTimeZone(abbreviation: timeZone)
    }
    
}











