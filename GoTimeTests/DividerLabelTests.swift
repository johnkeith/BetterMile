//
//  DividerLabelTests.swift
//  GoTime
//
//  Created by John Keith on 3/11/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import XCTest
@testable import GoTime

class DividerLabelTests: XCTestCase {
    var label: DividerLabel!
    
    override func setUp() {
        super.setUp()
        
        label = DividerLabel()
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
}
