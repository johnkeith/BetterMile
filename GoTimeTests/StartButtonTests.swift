//
//  StartButtonTests.swift
//  GoTime
//
//  Created by John Keith on 1/26/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import XCTest
@testable import GoTime

class StartButtonTests: XCTestCase {
    var button: StartButton!
    
    override func setUp() {
        super.setUp()
        
        button = StartButton()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testHide() {
        button.hide()
        XCTAssertTrue(button.isHidden)
    }
    
    func testShow() {
        button.show()
        XCTAssertFalse(button.isHidden)
    }
}
