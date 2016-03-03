//
//  ShingoIconImages.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/3/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit

public class ShingoIconImages: UIImage {
    let iPadPro = UIImage(named: "shingoIcon_iPadPro_Res")
    let iPadAirMini = UIImage(named: "shingoIcon_iPadAir_Mini_Res")
    let iPhone6Plus = UIImage(named: "shingo_icon_iPhone6plus_Res")
    let iPhone6 = UIImage(named: "shingo_icon_iPhone6_Res")
    let iPhone5 = UIImage(named: "shingoIcon_iPhone5_Res")
    let iPhone4 = UIImage(named: "shingoIcon_iPhone4_Res")
    
    public func getShingoIconForDevice() -> UIImage {

//        switch identifier {
//        case "iPod5,1":                                 return "iPod Touch 5"
//        case "iPod7,1":                                 return "iPod Touch 6"
//        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
//        case "iPhone4,1":                               return "iPhone 4s"
//        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
//        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
//        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
//        case "iPhone7,2":                               return "iPhone 6"
//        case "iPhone7,1":                               return "iPhone 6 Plus"
//        case "iPhone8,1":                               return "iPhone 6s"
//        case "iPhone8,2":                               return "iPhone 6s Plus"
//        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
//        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
//        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
//        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
//        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
//        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
//        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
//        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
//        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
//        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
//        case "AppleTV5,3":                              return "Apple TV"
//        case "i386", "x86_64":                          return "Simulator"
//        default:                                        return identifier
        
        switch UIDevice.currentDevice().modelName {
            case "iPad Pro":            return self.iPadPro!
            case "iPad 2",
            "iPad 3",
            "iPad 4",
            "iPad Air",
            "iPad Air 2",
            "iPad Mini",
            "iPad Mini 2",
            "iPad Mini 3",
            "iPad Mini 4":             return self.iPadAirMini!
            case "iPhone 6 Plus",
            "iPhone 6s Plus":          return self.iPhone6Plus!
            case "iPhone 6",
            "iPhone 6s":               return self.iPhone6!
            case "iPhone 5",
            "iPhone 5c", "iPhone 5s":  return self.iPhone5!
            case "iPhone 4",
            "iPhone 4s":               return self.iPhone4!
        default:
            return UIImage()
        }
        
    }
    
}
