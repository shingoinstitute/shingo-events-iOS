//
//  ShingoIconImages.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/3/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit

class SIImages: UIImage {
    func shingoIconForDevice() -> UIImage {
        switch UIDevice.currentDevice().deviceType {
            case .IPadPro:       return UIImage(named: "shingoIcon_iPadPro_Res")!
            case .IPad2,
            .IPad3,
            .IPad4,
            .IPadAir,
            .IPadAir2,
            .IPadMini,
            .IPadMiniRetina,
            .IPadMini3,
            .IPadMini4:          return UIImage(named: "shingoIcon_iPadAir_Mini_Res")!
            case .IPhone6Plus,
            .IPhone6SPlus:       return UIImage(named: "shingo_icon_iPhone6plus_Res")!
            case .IPhone6,
            .IPhone6S,
            .IPodTouch6:         return UIImage(named: "shingo_icon_iPhone6_Res")!
            case .IPhone5,
            .IPhone5C,
            .IPhone5S,
            .IPodTouch5G:        return UIImage(named: "shingoIcon_iPhone5_Res")!
            case .IPhone4,
            .IPhone4S:           return UIImage(named: "shingoIcon_iPhone4_Res")!
            case .Simulator:     return UIImage(named: "shingo_icon_iPhone6_Res")!
            default:
                                 return UIImage(named: "shingo_icon_iPhone6plus_Res")!
        }
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
    
}