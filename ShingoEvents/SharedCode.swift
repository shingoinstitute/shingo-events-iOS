//
//  SharedCode.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 6/23/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit

protocol SICellDelegate { func cellDidUpdate() }
protocol SISpeakerDelegate { func performActionOnSpeakers(data: [SISpeaker]) }

struct Alphabet {
    static var english: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#"]
}

struct SIParagraphStyle {
    
    public static var center: NSParagraphStyle {
        get {
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            return style
        }
    }
    
    public static var justified: NSParagraphStyle {
        get {
            let style = NSMutableParagraphStyle()
            style.alignment = .justified
            return style
        }
    }
    
    public static var left: NSParagraphStyle {
        get {
            let style = NSMutableParagraphStyle()
            style.alignment = .left
            return style
        }
    }
    
    public static var natural: NSParagraphStyle {
        get {
            let style = NSMutableParagraphStyle()
            style.alignment = .natural
            return style
        }
    }
    
    public static var right: NSParagraphStyle {
        get {
            let style = NSMutableParagraphStyle()
            style.alignment = .right
            return style
        }
    }
}

// Shingo IP Colors
extension UIColor {
    
    ///Red: 21, Green: 92, Blue: 151.
    static var lightShingoBlue: UIColor { get { return UIColor(netHex: 0x155c97) } }
    
    ///Red: 0, Green: 47, Blue: 86.
    static var shingoBlue: UIColor { get { return UIColor(netHex: 0x002f56) } }
    
    ///Red: 158, Green: 12, Blue: 50.
    static var lightShingoRed: UIColor { get { return UIColor(netHex: 0x9e0c32) } }
    
    ///Red: 101, Green: 8, Blue: 32.
    static var shingoRed: UIColor { get { return UIColor(netHex: 0x650820) } }
    
    ///Red: 63, Green: 19, Blue: 27.
    static var darkShingoRed: UIColor { get { return UIColor(netHex: 0x3f131b) } }
    
    ///Red: 14, Green: 33, Blue: 69.
    static var darkShingoBlue: UIColor { get { return UIColor(netHex: 0x0e2145) } }
    
    ///Red: 205, Green: 137, Blue: 49.
    static var shingoGold: UIColor { get { return UIColor(netHex: 0xcd8931) } }
    
    ///Red: 63, Green: 81, Blue: 36.
    static var shingoGreen: UIColor { get {return UIColor(netHex: 0x3F5124) } }
    
    static var raven: UIColor { get { return UIColor(netHex: 0x373D3F) } }
}

extension UIColor {
    
    convenience init(netHex: Int) {
        let red = (netHex >> 16) & 0xff
        let green = (netHex >> 8) & 0xff
        let blue = netHex & 0xff
        
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
//    convenience init(netHex:Int) {
//        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
//    }
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
    
    var length: Int { get { return self.characters.count } }
    
    mutating func trim() {
        self = self.trimmingCharacters(in: CharacterSet.whitespaces)
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
    public convenience init(text: String, font: UIFont! = UIFont.preferredFont(forTextStyle: .body)) {
        self.init()
        self.text = text
        self.font = font
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

    func resizeImageViewToIntrinsicContentSize(thatFitsWidth width: CGFloat) {
        
        guard let image = self.image else {
            return
        }
        
        let size = CGSize(width: width, height: (width * image.size.height) / image.size.width)
        
        UIGraphicsBeginImageContextWithOptions(size, self.isOpaque, 0.0)
        self.image?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
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
    
    class func transformIntrinsicContentSize(toFitWidth width: CGFloat, isOpaque opaque: Bool = true, forImage image: UIImage) -> UIImage? {
        
        let size = CGSize(width: width, height: (width * image.size.height) / image.size.width)
        
        UIGraphicsBeginImageContextWithOptions(size, opaque, 0.0)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
}

// Date comparison operator
func > (left: Date, right: Date) -> Bool {
    return left.isGreaterThanDate(right)
}

func < (left: Date, right: Date) -> Bool {
    return left.isLessThanDate(right)
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
    
    var isNotionallyEmpty: Bool { get { return self == Date.notionallyEmptyDate() } }
    

    
    
}

/// Initializer defaults to en_US locale.
extension DateFormatter {
    
    /// Important! Defaults time zone to MST.
    convenience init(dateFormat: String) {
        self.init()
        locale = Locale(identifier: "en_US")
        timeZone = TimeZone(abbreviation: "MST")
        self.dateFormat = dateFormat
    }
    
    static func time(from: Date, to: Date) -> String {

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.timeZone = TimeZone(abbreviation: "MST")
        timeFormatter.locale = Locale(identifier: "en_US")
        
        let timeZoneOffset = TimeInterval(timeFormatter.timeZone.secondsFromGMT()) - TimeInterval(NSTimeZone.local.secondsFromGMT())

        let startTime = timeFormatter.string(from: from.addingTimeInterval(timeZoneOffset))
        let endTime = timeFormatter.string(from: to.addingTimeInterval(timeZoneOffset))
        
        return "\(startTime) - \(endTime)"
        
    }
 
    static func attributedTime(from: Date, to: Date) -> NSAttributedString? {
        
        let timeFrame: String = DateFormatter.time(from: from, to: to)
        
        guard let stringComponents = timeFrame.split("-") else {
            return nil
        }
        
        guard let fromTime = stringComponents.first else {
            return nil
        }
        
        guard let toTime = stringComponents.last else {
            return nil
        }
        
        guard let startComponents = fromTime.split(" ") else {
            return nil
        }
        
        guard let endComponents = toTime.split(" ") else {
            return nil
        }
        
        guard let startTime = startComponents.first else {
            return nil
        }
        
        guard let startPeriod = startComponents.last else {
            return nil
        }
        
        guard let endTime = endComponents.first else {
            return nil
        }
        
        guard let endPeriod = endComponents.last else {
            return nil
        }
        
        let pointSize = UIFont.preferredFont(forTextStyle: .headline).pointSize
        let systemFontDesc = UIFont.systemFont(ofSize: pointSize, weight: UIFontWeightSemibold).fontDescriptor
        let smallCapsFontDesc = systemFontDesc.addingAttributes(
            [
                UIFontDescriptorFeatureSettingsAttribute: [
                    [
                        UIFontFeatureTypeIdentifierKey: kUpperCaseType,
                        UIFontFeatureSelectorIdentifierKey: kUpperCaseSmallCapsSelector,
                        ],
                ]
            ]
        )
        
        let smallCapsFont = UIFont(descriptor: smallCapsFontDesc, size: pointSize)
        
        let timeAttributes = [NSFontAttributeName:UIFont.preferredFont(forTextStyle: .headline)]
        let periodAttributes = [NSFontAttributeName:smallCapsFont]
        
        let attributedText = NSMutableAttributedString(string: startTime, attributes: timeAttributes)
        attributedText.append(NSAttributedString(string: startPeriod, attributes: periodAttributes))
        attributedText.append(NSAttributedString(string: " - ", attributes: timeAttributes))
        attributedText.append(NSAttributedString(string: endTime, attributes: timeAttributes))
        attributedText.append(NSAttributedString(string: endPeriod, attributes: periodAttributes))
        
        return attributedText
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

func isValidEmail(_ value:String) -> Bool {
    let regEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
    let email = NSPredicate(format:"SELF MATCHES %@", regEx)
    let result = email.evaluate(with: value)
    return result
}


extension NSMutableAttributedString {
    ///Maintains bold and italic traits while using dynamic font.
    func usePreferredFontWhileMaintainingAttributes(forTextStyle: UIFontTextStyle) {
        self.enumerateAttribute(NSFontAttributeName, in: fullRange, options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) {
            (_, range: NSRange, stop: UnsafeMutablePointer<ObjCBool>) in
            
            let stringInRange = self.attributedSubstring(from: range)
            let pointSize = UIFont.preferredFont(forTextStyle: forTextStyle).pointSize
            var updatedFont: UIFont!
            if stringInRange.isBold {
                updatedFont = UIFont.boldSystemFont(ofSize: pointSize)
            } else if stringInRange.isItalic {
                updatedFont = UIFont.italicSystemFont(ofSize: pointSize)
            } else {
                updatedFont = UIFont.systemFont(ofSize: pointSize)
            }
            
            self.addAttribute(NSFontAttributeName, value: updatedFont, range: range)
        }
    }
    
}

extension NSAttributedString {
    var fullRange: NSRange { get { return NSMakeRange(0, self.string.length) } }
    
    var isBold: Bool {
        get {
            var isBold = false
            self.enumerateAttribute(NSFontAttributeName, in: self.fullRange, options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) { (attribute: Any?, range: NSRange, stop: UnsafeMutablePointer<ObjCBool>) in
                if let font = attribute as? UIFont {
                    if font.fontName.lowercased().contains("bold") {
                        isBold = true
                    }
                }
            }
            return isBold
        }
    }
    
    var isItalic: Bool {
        get {
            var isItalic = false
            self.enumerateAttribute(NSFontAttributeName, in: self.fullRange, options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) { (attribute: Any?, range: NSRange, stop: UnsafeMutablePointer<ObjCBool>) in
                if let font = attribute as? UIFont {
                    if font.fontName.lowercased().contains("italic") {
                        isItalic = true
                    }
                }
            }
            return isItalic
        }
    }
}



