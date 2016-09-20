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
protocol SISpeakerDelegate { func performActionOnSpeakers(_ data: [SISpeaker]) }
protocol SIRequestDelegate { func cancelRequest() }
protocol SIEventImageLoaderDelegate { func loadedImage(_ image: UIImage) }

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
    
    class func lightBlue() -> SIColor {
        return SIColor(netHex: 0x155c97)
    }
    
    class func shingoBlue() -> SIColor {
        return SIColor(netHex: 0x002f56)
    }
    
    class func prussianBlue() -> SIColor {
        return SIColor(netHex: 0x002F56)
    }
    
    class func shingoRed() -> SIColor {
        return SIColor(netHex: 0x650820)
    }
    
    class func darkShingoBlue() -> SIColor {
        return SIColor(netHex: 0x0e2145)
    }
    
    class func shingoGold() -> SIColor {
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
    case notAvailable = -1.0
    
    case iPhone2G     = 1.0
    case iPhone3G     = 1.1
    case iPhone3GS    = 1.2
    case iPhone4      = 2.0
    case iPhone4S     = 2.1
    case iPhone5      = 3.0
    case iPhone5C     = 3.1
    case iPhone5S     = 3.2
    case iPhone6Plus  = 5.0
    case iPhone6      = 4.0
    case iPhone6S     = 4.1
    case iPhone6SPlus = 5.1
    case iPhoneSE     = 3.3
    
    case iPodTouch1G = 1.3
    case iPodTouch2G = 1.4
    case iPodTouch3G = 1.5
    case iPodTouch4G = 2.2
    case iPodTouch5G = 3.4
    case iPodTouch6  = 3.5
    
    case iPad           = 6.0
    case iPad2          = 6.1
    case iPad3          = 6.2
    case iPad4          = 6.3
    case iPadMini       = 6.4
    case iPadMiniRetina = 7.0
    case iPadMini3      = 7.1
    case iPadMini4      = 7.2
    case iPadAir        = 7.3
    case iPadAir2       = 7.4
    case iPadPro        = 8.0
    
    case simulator = 0
}



extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machine = systemInfo.machine
        let mirror = Mirror(reflecting: machine)
        var identifier = ""
        
        for child in mirror.children {
            if let value = child.value as? Int8 , value != 0 {
                identifier.append(String(UnicodeScalar(UInt8(value))))
            }
        }
        return identifier
    }
    
    var deviceType: DeviceType {
        return parseDeviceType(modelName)
    }
    
    func parseDeviceType(_ identifier: String) -> DeviceType {
        
        if identifier == "i386" || identifier == "x86_64" {
            return .simulator
        }
        
        switch identifier {
        case "iPhone1,1": return .iPhone2G
        case "iPhone1,2": return .iPhone3G
        case "iPhone2,1": return .iPhone3GS
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return .iPhone4
        case "iPhone4,1": return .iPhone4S
        case "iPhone5,1", "iPhone5,2": return .iPhone5
        case "iPhone5,3", "iPhone5,4": return .iPhone5C
        case "iPhone6,1", "iPhone6,2": return .iPhone5S
        case "iPhone7,1": return .iPhone6Plus
        case "iPhone7,2": return .iPhone6
        case "iPhone8,2": return .iPhone6SPlus
        case "iPhone8,1": return .iPhone6S
        case "iPhone8,4": return .iPhoneSE
            
        case "iPod1,1": return .iPodTouch1G
        case "iPod2,1": return .iPodTouch2G
        case "iPod3,1": return .iPodTouch3G
        case "iPod4,1": return .iPodTouch4G
        case "iPod5,1": return .iPodTouch5G
        case "iPod7,1": return .iPodTouch6
            
        case "iPad1,1", "iPad1,2": return .iPad
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return .iPad2
        case "iPad2,5", "iPad2,6", "iPad2,7": return .iPadMini
        case "iPad3,1", "iPad3,2", "iPad3,3": return .iPad3
        case "iPad3,4", "iPad3,5", "iPad3,6": return .iPad4
        case "iPad4,1", "iPad4,2", "iPad4,3": return .iPadAir
        case "iPad4,4", "iPad4,5", "iPad4,6": return .iPadMiniRetina
        case "iPad4,7", "iPad4,8": return .iPadMini3
        case "iPad5,1", "iPad5,2": return .iPadMini4
        case "iPad5,3", "iPad5,4": return .iPadAir2
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8": return .iPadPro
            
        default: return .notAvailable
        }
    }
}

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func split(_ character: Character) -> [String]? {
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
    func next(_ after: String, delimiter: Character) -> String? {
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
    public func addSubviews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
    
    public func autoPinEdgesToSuperviewEdgesWithNavbar(_ viewController: UIViewController, withTopInset: CGFloat) {
        self.autoPin(toTopLayoutGuideOf: viewController, withInset: withTopInset)
        self.autoPinEdge(toSuperviewEdge: .left)
        self.autoPinEdge(toSuperviewEdge: .right)
        self.autoPinEdge(toSuperviewEdge: .bottom)
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
    class func helveticaOfFontSize(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Helvetica", size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    class func boldHelveticaOfFontSize(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Helvetica-Bold", size: size) {
            return font
        } else {
            return UIFont.boldSystemFont(ofSize: size)
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
        return self.advanced(by: 1.0)
    }
}

extension UIImageView {
    /// Returns a CGSize that fits inside the given view while maintaining the UIImageView aspect ratio.
    func sizeThatViewFits(view: UIView) -> CGSize {
        if let image = self.image {
            return CGSize(width: view.frame.width, height: image.size.height * (view.frame.width / image.size.width))
        }
        
        return CGSize.zero
    }
}

extension UIImage {
    func isEmpty() -> Bool {
        return cgImage == nil && ciImage == nil
    }
    
    /// Returns the filezise in KB of a UIImage in a PNG format.
    func fileSizeOfPNG() -> Int {
        if let representation = UIImagePNGRepresentation(self) {
            return (NSData(data: representation) as Data).count / 1024
        }
        return 0
    }
    
    /// Returns the filesize in KB of a UIImage in a JPEG format with a compression quality of 1.
    func fileSizeOfJPEG() -> Int {
        if let representation = UIImageJPEGRepresentation(self, 1) {
            return (NSData(data: representation) as Data).count / 1024
        }
        return 0
    }
    
    /// Returns the filesize in KB of a UIImage in a JPEG format with a given compression quality.
    func fileSizeOfJPEG(compressionQuality quality: CGFloat) -> Int {
        if let representation = UIImageJPEGRepresentation(self, quality) {
            return (NSData(data: representation) as Data).count / 1024
        }
        return 0
    }
}

// NSDate comparison operator
func > (left: Date, right: Date) -> Bool {
    if left.isGreaterThanDate(right) {
        return true
    } else {
        return false
    }
}

extension Date {
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        return (compare(dateToCompare) == ComparisonResult.orderedDescending)
    }
    
    func isLessThanDate(_ dateToCompare: Date) -> Bool {
        return (compare(dateToCompare) == ComparisonResult.orderedAscending)
    }
    
    func equalToDate(_ dateToCompare: Date) -> Bool {
        return (compare(dateToCompare) == ComparisonResult.orderedSame)
    }
    
    static func notionallyEmptyDate() -> Date {
        return Date.init(timeIntervalSince1970: 0)
    }
    
    var isNotionallyEmpty: Bool {
        get {
            if self == Date.notionallyEmptyDate() {
                return true
            } else {
                return false
            }
        }
    }
    
    /// Returns time frame between a start date and end date.
    func timeFrameBetweenDates(startDate start: Date, endDate end: Date) -> String {

        let calendar = Calendar.current
        let startComponents = (calendar as NSCalendar).components([.hour, .minute], from: start)
        let endComponents = (calendar as NSCalendar).components([.hour, .minute], from: end)
        
        return "\(timeStringFromComponents(hour: startComponents.hour!, minute: startComponents.minute!)) - \(timeStringFromComponents(hour: endComponents.hour!, minute: endComponents.minute!))"
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

extension DateFormatter {
    /// Returns an object initialized with a set locale, date format, and time zone.
    convenience init(locale: String, dateFormat: String) {
        self.init()
        self.locale = Locale(identifier: locale)
        self.dateFormat = dateFormat
        self.timeZone = TimeZone(abbreviation: "GMT")
    }
    
}

extension Array where Element:NSLayoutConstraint {
    var active: Bool {
        get {
            for i in self {
                if !i.isActive {
                    return false
                }
            }
            return true
        }
        set {
            for i in self {
                i.isActive = newValue
            }
        }
    }
    
    var height: CGFloat {
        get {
            var height: CGFloat = 0
            for i in self {
                if i.firstAttribute == .height {
                    height += i.constant
                }
            }
            return height
        }
        set {
            for i in self {
                if i.firstAttribute == .height {
                    i.constant = newValue
                }
            }
        }
    }
    
    var width: CGFloat {
        get {
            var width: CGFloat = 0
            for i in self {
                if i.firstAttribute == .width {
                    width += i.constant
                }
            }
            return width
        }
        set {
            for i in self {
                if i.firstAttribute == .width {
                    i.constant = newValue
                }
            }
        }
    }
}

func isValidEmail(_ testStr:String) -> Bool {
    print("validate emilId: \(testStr)")
    let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let result = emailTest.evaluate(with: testStr)
    return result
}





