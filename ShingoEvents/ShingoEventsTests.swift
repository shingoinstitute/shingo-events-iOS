//
//  ShingoEventsTests.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 6/22/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import XCTest
//@testable import ShingoEvents

class ShingoEventsTests: XCTestCase {
    
    var sum : Int = 0
    
    override func setUp() {
        super.setUp()
        sum = 2
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        XCTAssert(sum + 2 == 4, "Something went wrong")
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
