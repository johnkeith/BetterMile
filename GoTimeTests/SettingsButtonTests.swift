//
//  SettingsButtonTests.swift
//  GoTime
//
//  Created by John Keith on 3/18/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import XCTest
@testable import GoTime

class OpenSettingsButtonTests: XCTestCase {
    var button: OpenSettingsButton!
    
    override func setUp() {
        super.setUp()
        
        button = OpenSettingsButton()
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
