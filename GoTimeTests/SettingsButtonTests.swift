//
//  SettingsButtonTests.swift
//  GoTime
//
//  Created by John Keith on 3/18/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import XCTest
@testable import GoTime

class SettingsButtonTests: XCTestCase {
    var button: SettingsButton!
    
    override func setUp() {
        super.setUp()
        
        button = SettingsButton()
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
