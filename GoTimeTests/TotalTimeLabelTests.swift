//
//  TotalTimeLabelTests.swift
//  GoTime
//
//  Created by John Keith on 2/5/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import XCTest
@testable import GoTime

class TotalTimeLabelTests: XCTestCase {
    var label: TotalTimeLabel!
    
    override func setUp() {
        super.setUp()
        
        label = TotalTimeLabel()
    }
    
    func testSetText() {
        let time = "01:11.01"
        label.setText(time: time)

        XCTAssertEqual(time, label.text)
    }
}
