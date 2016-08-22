//
//  testCode.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 8/22/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import Foundation

class TestCode {
    
    // Sponsor Levels:
    //                President
    //                Champion
    //                Benefactor
    //                Supporter
    //                Friend
    
    class func generateTestCode() -> JSON {
        
        let attrsArray = ["type": "Shingo_Sponsor__c","url": "/services/data/v36.0/sobjects/Shingo_Sponsor__c/a1N120000020vxnEAA"]
        
        let s1 = [
            "attributes" : attrsArray,
            "Id": "a1N120000020vxnEAA",
            "Organization__r": [
                "attributes": attrsArray,
                "Name": "Arches Leadership LLC",
                "Logo__c": "http://res.cloudinary.com/shingo/image/upload/v1459542256/AL_logo_no-white_small_xxbl1e.png",
                "App_Abstract__c": "Arches Leadership, LLC is dedicated to the development of leaders and organizations based on the principles of enterprise excellence. President and Principal Consultant, Robert Miller, has successfully coached and advised leadership teams in many industries and countries, helping them to understand how principles inform the ideal behaviors that lead to ideal organizational results. In ancient Greek philosophy the word \"arche\" meant \"first principle\" or \"something that was in the beginning.\" The arch is a curved structure that creates a powerful support for everything that sits above it, just as a principle is the surest foundation upon which an organizational culture can be built. Arches Leadership is dedicated to helping leaders gain a deep understanding of the principles embodied in the <em>Shingo Model</em> and discovering the personal and organizational implications for ideal behavior required in a culture that consistently delivers ideal organizational results.\r\n<br><br>\r\nCertified Facilitator:<br>\r\nRobert Miller - President & Principal Consultant"
            ],
            "Banner_URL__c": "https://placehold.it/350x150",
            "Splash_Screen_URL__c": "https://placehold.it/350x600",
            "Sponsor_Level__c": "President"
        ]
        
        let s2 = [
            "attributes": attrsArray,
            "Id": "a1N120000020vxnEAA",
            "Organization__r": [
                "attributes": attrsArray,
                "Name": "Craig",
                "Logo__c": "http://res.cloudinary.com/shingo/image/upload/v1459542256/AL_logo_no-white_small_xxbl1e.png",
                "App_Abstract__c": "Arches Leadership, LLC is dedicated to the development of leaders and organizations based on the principles of enterprise excellence. President and Principal Consultant, Robert Miller, has successfully coached and advised leadership teams in many industries and countries, helping them to understand how principles inform the ideal behaviors that lead to ideal organizational results. In ancient Greek philosophy the word \"arche\" meant \"first principle\" or \"something that was in the beginning.\" The arch is a curved structure that creates a powerful support for everything that sits above it, just as a principle is the surest foundation upon which an organizational culture can be built. Arches Leadership is dedicated to helping leaders gain a deep understanding of the principles embodied in the <em>Shingo Model</em> and discovering the personal and organizational implications for ideal behavior required in a culture that consistently delivers ideal organizational results.\r\n<br><br>\r\nCertified Facilitator:<br>\r\nRobert Miller - President & Principal Consultant"
            ],
            "Banner_URL__c": "https://placehold.it/350x150",
            "Splash_Screen_URL__c": "https://placehold.it/350x600",
            "Sponsor_Level__c": "Champion"
        ]
        
        let s3 = [
            "attributes": attrsArray,
            "Id": "a1N120000020vxnEAA",
            "Organization__r": [
                "attributes": attrsArray,
                "Name": "Dustin",
                "Logo__c": "http://res.cloudinary.com/shingo/image/upload/v1459542256/AL_logo_no-white_small_xxbl1e.png",
                "App_Abstract__c": "Arches Leadership, LLC is dedicated to the development of leaders and organizations based on the principles of enterprise excellence. President and Principal Consultant, Robert Miller, has successfully coached and advised leadership teams in many industries and countries, helping them to understand how principles inform the ideal behaviors that lead to ideal organizational results. In ancient Greek philosophy the word \"arche\" meant \"first principle\" or \"something that was in the beginning.\" The arch is a curved structure that creates a powerful support for everything that sits above it, just as a principle is the surest foundation upon which an organizational culture can be built. Arches Leadership is dedicated to helping leaders gain a deep understanding of the principles embodied in the <em>Shingo Model</em> and discovering the personal and organizational implications for ideal behavior required in a culture that consistently delivers ideal organizational results.\r\n<br><br>\r\nCertified Facilitator:<br>\r\nRobert Miller - President & Principal Consultant"
            ],
            "Banner_URL__c": "https://placehold.it/350x150",
            "Splash_Screen_URL__c": "https://placehold.it/350x600",
            "Sponsor_Level__c": "Benefactor"
        ]
        
        let s4 = [
            "attributes": attrsArray,
            "Id": "a1N120000020vxnEAA",
            "Organization__r": [
                "attributes": attrsArray,
                "Name": "Tom",
                "Logo__c": "http://res.cloudinary.com/shingo/image/upload/v1459542256/AL_logo_no-white_small_xxbl1e.png",
                "App_Abstract__c": "Arches Leadership, LLC is dedicated to the development of leaders and organizations based on the principles of enterprise excellence. President and Principal Consultant, Robert Miller, has successfully coached and advised leadership teams in many industries and countries, helping them to understand how principles inform the ideal behaviors that lead to ideal organizational results. In ancient Greek philosophy the word \"arche\" meant \"first principle\" or \"something that was in the beginning.\" The arch is a curved structure that creates a powerful support for everything that sits above it, just as a principle is the surest foundation upon which an organizational culture can be built. Arches Leadership is dedicated to helping leaders gain a deep understanding of the principles embodied in the <em>Shingo Model</em> and discovering the personal and organizational implications for ideal behavior required in a culture that consistently delivers ideal organizational results.\r\n<br><br>\r\nCertified Facilitator:<br>\r\nRobert Miller - President & Principal Consultant"
            ],
            "Banner_URL__c": "https://placehold.it/350x150",
            "Splash_Screen_URL__c": "https://placehold.it/350x600",
            "Sponsor_Level__c": "Supporter"
        ]
        
        let s5 = [
            "attributes": attrsArray,
            "Id": "a1N120000020vxnEAA",
            "Organization__r": [
                "attributes": attrsArray,
                "Name": "Case",
                "Logo__c": "http://res.cloudinary.com/shingo/image/upload/v1459542256/AL_logo_no-white_small_xxbl1e.png",
                "App_Abstract__c": "Arches Leadership, LLC is dedicated to the development of leaders and organizations based on the principles of enterprise excellence. President and Principal Consultant, Robert Miller, has successfully coached and advised leadership teams in many industries and countries, helping them to understand how principles inform the ideal behaviors that lead to ideal organizational results. In ancient Greek philosophy the word \"arche\" meant \"first principle\" or \"something that was in the beginning.\" The arch is a curved structure that creates a powerful support for everything that sits above it, just as a principle is the surest foundation upon which an organizational culture can be built. Arches Leadership is dedicated to helping leaders gain a deep understanding of the principles embodied in the <em>Shingo Model</em> and discovering the personal and organizational implications for ideal behavior required in a culture that consistently delivers ideal organizational results.\r\n<br><br>\r\nCertified Facilitator:<br>\r\nRobert Miller - President & Principal Consultant"
            ],
            "Banner_URL__c": "https://placehold.it/350x150",
            "Splash_Screen_URL__c": "https://placehold.it/350x600",
            "Sponsor_Level__c": "Supporter"
        ]
        
        let s6 = [
            "attributes": attrsArray,
            "Id": "a1N120000020vxnEAA",
            "Organization__r": [
                "attributes": attrsArray,
                "Name": "Sarah",
                "Logo__c": "https://pbs.twimg.com/profile_images/446566229210181632/2IeTff-V.jpeg",
                "App_Abstract__c": "Arches Leadership, LLC is dedicated to the development of leaders and organizations based on the principles of enterprise excellence. President and Principal Consultant, Robert Miller, has successfully coached and advised leadership teams in many industries and countries, helping them to understand how principles inform the ideal behaviors that lead to ideal organizational results. In ancient Greek philosophy the word \"arche\" meant \"first principle\" or \"something that was in the beginning.\" The arch is a curved structure that creates a powerful support for everything that sits above it, just as a principle is the surest foundation upon which an organizational culture can be built. Arches Leadership is dedicated to helping leaders gain a deep understanding of the principles embodied in the <em>Shingo Model</em> and discovering the personal and organizational implications for ideal behavior required in a culture that consistently delivers ideal organizational results.\r\n<br><br>\r\nCertified Facilitator:<br>\r\nRobert Miller - President & Principal Consultant"
            ],
            "Banner_URL__c": "https://placehold.it/350x150",
            "Splash_Screen_URL__c": "https://placehold.it/350x600",
            "Sponsor_Level__c": "Friend"
        ]
        
        let dict = [
            "success": true,
            "sponsors": [
                s1,
                s2,
                s3,
                s4,
                s5,
                s6
            ],
            "total_size":13,
            "done": true,
            "timestamp":"2016-06-23T20:59:57.671Z"
        ]
        
        return JSON(dict)
    }
    
    
    
}

