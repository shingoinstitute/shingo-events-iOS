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
    
    public func shingoIconForDevice() -> UIImage {
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
            "iPhone 6s",
            "iPod Touch 6":               return self.iPhone6!
            case "iPhone 5",
            "iPhone 5c",
            "iPhone 5s",
            "iPod Touch 5":  return self.iPhone5!
            case "iPhone 4",
            "iPhone 4s":               return self.iPhone4!
            case "Simulator":          return self.iPadPro!
        default:
            return iPhone6Plus!
        }
    }
}
