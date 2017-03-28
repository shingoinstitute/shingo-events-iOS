//
//  SIAffiliate.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/21/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit

class SIAffiliate: SIObject {
    
    var logoURL : String {
        didSet {
            requestAffiliateLogoImage(nil)
        }
    }
    var websiteURL : String
    var pagePath : String
    
    override init() {
        logoURL = ""
        websiteURL = ""
        pagePath = ""
        super.init()
    }
    
    func requestAffiliateLogoImage(_ callback: (() -> Void)?) {
        
        if logoURL.isEmpty || image != nil {
            if let cb = callback { cb() }
        }
        
        requestImage(URLString: logoURL) { (image) in
            if let image = image {
                self.image = image
                self.didLoadImage = true
            }
            
            if let cb = callback { cb() }
        }
    }
    
    func getLogoImage(_ callback: @escaping (UIImage) -> ()) {
        
        guard let image = self.image else {
            requestAffiliateLogoImage() {
                if let image = self.image {
                    callback(image)
                } else if let image = UIImage(named: "Shingo Icon Small") {
                    callback(image)
                } else {
                    callback(UIImage())
                }
            }
            return
        }
        
        callback(image)
    }
}
