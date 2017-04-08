//
//  SettingsOverlayTests.swift
//  GoTime
//
//  Created by John Keith on 3/20/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import XCTest
@testable import GoTime

class SettingsOverlayTests: XCTestCase {
    var overlay: SettingsOverlay!
    
    override func setUp() {
        super.setUp()
        
        overlay = SettingsOverlay()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func skipped_testHide() {
        overlay.hide()
        XCTAssertTrue(overlay.isHidden)
    }
    
    func testShow() {
        overlay.show()
        XCTAssertFalse(overlay.isHidden)
    }
}
