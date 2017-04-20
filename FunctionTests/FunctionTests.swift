//
//  FunctionTests.swift
//  FunctionTests
//
//  Created by Craig Blackburn on 4/20/17.
//  Copyright © 2017 Shingo Institute. All rights reserved.
//

import XCTest

extension String {
    func split(_ character: Character) -> [String]? {
        return self.characters.split{$0 == character}.map(String.init)
    }
}

class FunctionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStringSplit() {
        let testString = "I like cats"
        let split = testString.split(" ")
        
        XCTAssertNotNil(split)
        XCTAssertEqual(split!, ["I", "like", "cats"])
        
    }
    
}
