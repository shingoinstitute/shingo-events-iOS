//
//  testCode.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 8/22/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import Foundation
import SwiftyJSON

class TestCode {

    /*
     Sponsor Levels:
        President
        Champion
        Benefactor
        Supporter
        Friend
    */
    
    static let null = NSNull()
    
    class func generateTestJSONforSponsor() -> JSON {
        return JSON([
            "success": true,
            "sponsors":
            [
                [
                    "attributes": [
                        "type": "Shingo_Sponsor__c",
                        "url": "/services/data/v36.0/sobjects/Shingo_Sponsor__c/a1N1200000211KaEAI"
                    ],
                    "Id": "a1N1200000211KaEAI",
                    "Organization__r": [
                        "attributes": [
                            "type": "Account",
                            "url": "/services/data/v36.0/sobjects/Account/0011200001HlJN9AAN"
                        ],
                        "Name": "Universidad de Monterrey",
                        "Logo__c": "https://res.cloudinary.com/shingo/image/upload/c_scale,w_300/v1469742450/Summits/2016LatinSummit/UDEMLogo.jpg",
                        "App_Abstract__c": null
                    ],
                    "Banner_URL__c": "https://res.cloudinary.com/shingo/image/upload/c_scale,w_300/v1469742450/Summits/2016LatinSummit/UDEMLogo.jpg",
                    "Splash_Screen_URL__c": null,
                    "Sponsor_Level__c": "Benefactor"
                ],
                [
                    "attributes": [
                        "type": "Shingo_Sponsor__c",
                        "url": "/services/data/v36.0/sobjects/Shingo_Sponsor__c/a1N1200000211KpEAI"
                    ],
                    "Id": "a1N1200000211KpEAI",
                    "Organization__r": [
                        "attributes": [
                            "type": "Account",
                            "url": "/services/data/v36.0/sobjects/Account/0011200001HlJN9AAN"
                        ],
                        "Name": "Super Awesome Company",
                        "Logo__c": "http://res.cloudinary.com/shingo/image/upload/c_fill,g_north,h_250,w_250/v1469569537/StaffPhotos/_MG_0118.jpg",
                        "App_Abstract__c": null
                    ],
                    "Banner_URL__c": null,
                    "Splash_Screen_URL__c": null,
                    "Sponsor_Level__c": "President"
                ],
                [
                    "attributes": [
                        "type": "Shingo_Sponsor__c",
                        "url": "/services/data/v36.0/sobjects/Shingo_Sponsor__c/a1N12000000RMT1EAO"
                    ],
                    "Id": "a1N12000000RMT1EAO",
                    "Organization__r": [
                        "Name": "Dogs For Cupcakes inc.",
                        "Logo__c": "https://www.rover.com/blog/wp-content/uploads/2015/05/dog-candy-junk-food-599x340.jpg"
                    ],
                    "Banner_URL__c": "https://res.cloudinary.com/shingo/image/upload/c_scale,w_300/v1475014601/temp/Metalsa_Logo.jpg",
                    "Splash_Screen_URL__c": null,
                    "Sponsor_Level__c": null
                    ]
            ],
            "total_size": 3,
            "done": true
        ])
        
//        return JSON(dict)
    }
    
}






















































