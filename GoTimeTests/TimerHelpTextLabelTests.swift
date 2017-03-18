//
//  TimerHelpTextLabelTests.swift
//  GoTime
//
//  Created by John Keith on 3/18/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import XCTest
@testable import GoTime

class TimerHelpTextLabelTests: XCTestCase {
    var label: TimerHelpTextLabel!
    
    override func setUp() {
        super.setUp()
        
        label = TimerHelpTextLabel()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testHide() {
        label.hide()
        XCTAssertTrue(label.isHidden)
    }
    
    func testShow() {
        label.show()
        XCTAssertFalse(label.isHidden)
    }
    
    func testShowBriefly() {
        label.showBriefly()
        XCTAssertFalse(label.isHidden)
    }
}
