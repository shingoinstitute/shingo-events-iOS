//
//  SIObject.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 3/21/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
import Crashlytics

class SIObject : AnyObject {
    
    var image: UIImage?
    
    var name: String
    var id: String
    var attributedSummary: NSAttributedString
    var didLoadImage: Bool
    var isSelected: Bool
    
    init() {
        image = nil
        name = ""
        id = ""
        attributedSummary = NSAttributedString()
        didLoadImage = false
        isSelected = false
    }
    
    func requestImage(URLString: String, callback: @escaping (UIImage?) -> Void) {
        
        let urlRequest = URLRequest(url: URL(string: URLString)!)
        
        Alamofire.request(urlRequest).responseImage { (response) in
            guard var image = response.result.value else {
                return callback(nil)
            }
            
            if (image.size.width > 321) {
                let newHeight = (image.size.height / image.size.width) * 321
                let size = CGSize(width: 321, height: newHeight)
                image = image.af_imageScaled(to: size)
            } else if (image.scale > 1) {
                let size = CGSize(width: image.size.width * image.scale, height: image.size.height * image.scale)
                image = image.af_imageScaled(to: size)
            }
            
            debugPrint("Image Downloaded for Object: \(Mirror(reflecting: self).subjectType), \(image)")
            return callback(image)
        }
    }
    
}
