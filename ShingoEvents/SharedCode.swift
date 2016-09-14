//
//  SharedCode.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 6/23/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit

protocol SICellDelegate { func updateCell() }
protocol SISpeakerDelegate { func performActionOnSpeakers(data: [SISpeaker]) }
protocol SIRequestDelegate { func cancelRequest() }

// Shingo IP Colors
class SIColor: UIColor {
    
    convenience init(netHex: Int) {
        let red = (netHex >> 16) & 0xff
        let green = (netHex >> 8) & 0xff
        let blue = netHex & 0xff
        
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    class func lightBlueColor() -> SIColor {
        return SIColor(netHex: 0x155c97)
    }
    
    class func shingoBlueColor() -> SIColor {
        return SIColor(netHex: 0x002f56)
    }
    
    class func prussianBlueColor() -> SIColor {
        return SIColor(netHex: 0x002F56)
    }
    
    class func shingoRedColor() -> SIColor {
        return SIColor(netHex: 0x650820)
    }
    
    class func darkShingoBlueColor() -> SIColor {
        return SIColor(netHex: 0x0e2145)
    }
    
    class func shingoGoldColor() -> SIColor {
        return SIColor(netHex: 0xcd8931)
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

enum DeviceType: Double {
    case NotAvailable = -1.0
    
    case IPhone2G     = 1.0
    case IPhone3G     = 1.1
    case IPhone3GS    = 1.2
    case IPhone4      = 2.0
    case IPhone4S     = 2.1
    case IPhone5      = 3.0
    case IPhone5C     = 3.1
    case IPhone5S     = 3.2
    case IPhone6Plus  = 5.0
    case IPhone6      = 4.0
    case IPhone6S     = 4.1
    case IPhone6SPlus = 5.1
    case IPhoneSE     = 3.3
    
    case IPodTouch1G = 1.3
    case IPodTouch2G = 1.4
    case IPodTouch3G = 1.5
    case IPodTouch4G = 2.2
    case IPodTouch5G = 3.4
    case IPodTouch6  = 3.5
    
    case IPad           = 6.0
    case IPad2          = 6.1
    case IPad3          = 6.2
    case IPad4          = 6.3
    case IPadMini       = 6.4
    case IPadMiniRetina = 7.0
    case IPadMini3      = 7.1
    case IPadMini4      = 7.2
    case IPadAir        = 7.3
    case IPadAir2       = 7.4
    case IPadPro        = 8.0
    
    case Simulator = 0
}



extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machine = systemInfo.machine
        let mirror = Mirror(reflecting: machine)
        var identifier = ""
        
        for child in mirror.children {
            if let value = child.value as? Int8 where value != 0 {
                identifier.append(UnicodeScalar(UInt8(value)))
            }
        }
        return identifier
    }
    
    var deviceType: DeviceType {
        return parseDeviceType(modelName)
    }
    
    func parseDeviceType(identifier: String) -> DeviceType {
        
        if identifier == "i386" || identifier == "x86_64" {
            return .Simulator
        }
        
        switch identifier {
        case "iPhone1,1": return .IPhone2G
        case "iPhone1,2": return .IPhone3G
        case "iPhone2,1": return .IPhone3GS
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return .IPhone4
        case "iPhone4,1": return .IPhone4S
        case "iPhone5,1", "iPhone5,2": return .IPhone5
        case "iPhone5,3", "iPhone5,4": return .IPhone5C
        case "iPhone6,1", "iPhone6,2": return .IPhone5S
        case "iPhone7,1": return .IPhone6Plus
        case "iPhone7,2": return .IPhone6
        case "iPhone8,2": return .IPhone6SPlus
        case "iPhone8,1": return .IPhone6S
        case "iPhone8,4": return .IPhoneSE
            
        case "iPod1,1": return .IPodTouch1G
        case "iPod2,1": return .IPodTouch2G
        case "iPod3,1": return .IPodTouch3G
        case "iPod4,1": return .IPodTouch4G
        case "iPod5,1": return .IPodTouch5G
        case "iPod7,1": return .IPodTouch6
            
        case "iPad1,1", "iPad1,2": return .IPad
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return .IPad2
        case "iPad2,5", "iPad2,6", "iPad2,7": return .IPadMini
        case "iPad3,1", "iPad3,2", "iPad3,3": return .IPad3
        case "iPad3,4", "iPad3,5", "iPad3,6": return .IPad4
        case "iPad4,1", "iPad4,2", "iPad4,3": return .IPadAir
        case "iPad4,4", "iPad4,5", "iPad4,6": return .IPadMiniRetina
        case "iPad4,7", "iPad4,8": return .IPadMini3
        case "iPad5,1", "iPad5,2": return .IPadMini4
        case "iPad5,3", "iPad5,4": return .IPadAir2
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8": return .IPadPro
            
        default: return .NotAvailable
        }
    }
}

extension String {
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    func split(character: Character) -> [String]? {
        return self.characters.split{$0 == character}.map(String.init)
    }
    
    /// Is the last formation of characters
    var last: String? {
        get {
            if self.isEmpty {
                return nil
            } else if let array = self.split(" ") {
                if array.count == 1 {
                    return self
                } else {
                    return array[array.count - 1]
                }
            }
            return nil
        }
    }
    
    var first: String? {
        get {
            if self.isEmpty {
                return nil
            } else if let array = self.split(" ") {
                if let first = array.first {
                    return first
                } else {
                    return nil
                }
            }
            return nil
        }
    }
    
    ///Returns the next contiguous string of characters (i.e. the next "word") as a String, separated by the given delimiter, or nil if it does not exist.
    func next(after: String, delimiter: Character) -> String? {
        if let array = self.split(delimiter) {
            for i in 0 ..< array.count {
                if array[i] == after {
                    if array.indices.contains(i + 1) {
                        return array[i+1]
                    } else {
                        return nil
                    }
                }
            }
        }
        return nil
    }
    
}

extension UIBarButtonItem {
    convenience init(title: String) {
        self.init()
        self.title = title
    }
}

extension UIView {
    public func addSubviews(views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
    
    public func autoPinEdgesToSuperviewEdgesWithNavbar(viewController: UIViewController, withTopInset: CGFloat) {
        self.autoPinToTopLayoutGuideOfViewController(viewController, withInset: withTopInset)
        self.autoPinEdgeToSuperviewEdge(.Left)
        self.autoPinEdgeToSuperviewEdge(.Right)
        self.autoPinEdgeToSuperviewEdge(.Bottom)
    }
}

extension UILabel {
    public convenience init(text: String, font: UIFont!) {
        self.init()
        self.text = text
        self.font = font
    }
}

extension UIFont {
    class func helveticaOfFontSize(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Helvetica", size: size) {
            return font
        } else {
            return UIFont.systemFontOfSize(size)
        }
    }
}

struct Alphabet {
    
    static func alphabet() -> [String] {
        return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#"]
    }
    
}

extension Double {
    mutating func increment() -> Double {
        return self.advancedBy(1.0)
    }
}

extension UIImageView {
    /// Returns a CGSize that fits inside the given view while maintaining the UIImageView aspect ratio.
    func sizeThatViewFits(view view: UIView) -> CGSize {
        if let image = self.image {
            return CGSizeMake(view.frame.width, image.size.height * (view.frame.width / image.size.width))
        }
        
        return CGSizeZero
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
        return 0
    }
    
    /// Returns the filesize in KB of a UIImage in a JPEG format with a compression quality of 1.
    func fileSizeOfJPEG() -> Int {
        if let representation = UIImageJPEGRepresentation(self, 1) {
            return NSData(data: representation).length / 1024
        }
        return 0
    }
    
    /// Returns the filesize in KB of a UIImage in a JPEG format with a given compression quality.
    func fileSizeOfJPEG(compressionQuality quality: CGFloat) -> Int {
        if let representation = UIImageJPEGRepresentation(self, quality) {
            return NSData(data: representation).length / 1024
        }
        return 0
    }
}

// NSDate comparison operator
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
    
    class func notionallyEmptyDate() -> NSDate {
        return NSDate.init(timeIntervalSince1970: 0)
    }
    
    var isNotionallyEmpty: Bool {
        get {
            if self.isEqualToDate(NSDate.notionallyEmptyDate()) {
                return true
            } else {
                return false
            }
        }
    }
    
    /// Returns time frame between a start date and end date.
    func timeFrameBetweenDates(startDate start: NSDate, endDate end: NSDate) -> String {

        let calendar = NSCalendar.currentCalendar()
        let startComponents = calendar.components([.Hour, .Minute], fromDate: start)
        let endComponents = calendar.components([.Hour, .Minute], fromDate: end)
        
        return "\(timeStringFromComponents(hour: startComponents.hour, minute: startComponents.minute)) - \(timeStringFromComponents(hour: endComponents.hour, minute: endComponents.minute))"
    }
    
    func timeStringFromComponents(hour h: Int, minute: Int) -> String {
        var hour = h
        var am_pm = ""
        
        switch hour {
        case 0 ..< 12:
            am_pm = "am"
        case 13 ..< 25:
            hour = hour - 12
            am_pm = "pm"
        case 12:
            am_pm = "pm"
        default:
            break
        }
        
        if minute < 10 {
            return "\(hour):0\(minute) \(am_pm)"
        } else {
            return "\(hour):\(minute) \(am_pm)"
        }
    }
    
    
}

extension NSDateFormatter {
    /// Returns an object initialized with a set locale, date format, and time zone.
    convenience init(locale: String, dateFormat: String) {
        self.init()
        self.locale = NSLocale(localeIdentifier: locale)
        self.dateFormat = dateFormat
        self.timeZone = NSTimeZone(abbreviation: "GMT")
    }
    
}

extension Array where Element:NSLayoutConstraint {
    var active: Bool {
        get {
            for i in self {
                if !i.active {
                    return false
                }
            }
            return true
        }
        set {
            for i in self {
                i.active = newValue
            }
        }
    }
    
    var height: CGFloat {
        get {
            var height: CGFloat = 0
            for i in self {
                if i.firstAttribute == .Height {
                    height += i.constant
                }
            }
            return height
        }
        set {
            for i in self {
                if i.firstAttribute == .Height {
                    i.constant = newValue
                }
            }
        }
    }
    
    var width: CGFloat {
        get {
            var width: CGFloat = 0
            for i in self {
                if i.firstAttribute == .Width {
                    width += i.constant
                }
            }
            return width
        }
        set {
            for i in self {
                if i.firstAttribute == .Width {
                    i.constant = newValue
                }
            }
        }
    }
}

func isValidEmail(testStr:String) -> Bool {
    print("validate emilId: \(testStr)")
    let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let result = emailTest.evaluateWithObject(testStr)
    return result
}





