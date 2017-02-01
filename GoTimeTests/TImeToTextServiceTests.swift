//
//  TImeToTextServiceTests.swift
//  GoTime
//
//  Created by John Keith on 1/29/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import XCTest
@testable import GoTime

class TimeToTextServiceTests: XCTestCase {
    var service: TimeToTextService!
    
    override func setUp() {
        super.setUp()
        
        service = TimeToTextService()
    }
    
    func testTimeAsSingleStringWithOneMinute() {
        let results = service.timeAsSingleString(inputTime: 60)
        XCTAssertEqual(results, "01:00.00")
    }
    
    func testTimeAsSingleStringWithOneHourAndTwentyMinutes() {
        let results = service.timeAsSingleString(inputTime: 3620)
        XCTAssertEqual(results, "60:20.00")
    }
    
    func testTimeAsSingleStringWithAnAbsurdlyLongTime() {
        let results = service.timeAsSingleString(inputTime: 20000)
        
        XCTAssertEqual(results, "333:20.00")
    }
    
    func testTimeAsMultipleStrings() {
        let (minutes, seconds, fraction) = service.timeAsMultipleStrings(inputTime: 3210.32412391239232932)
        
        XCTAssertEqual(minutes, "53")
        XCTAssertEqual(seconds, "30")
        XCTAssertEqual(fraction, "32")
    }
}
