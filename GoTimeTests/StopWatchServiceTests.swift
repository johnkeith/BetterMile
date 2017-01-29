//
//  StopWatchServiceTests.swift
//  GoTime
//
//  Created by John Keith on 1/28/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import XCTest
@testable import GoTime

class StopWatchServiceTests: XCTestCase {
    class FakeDelegate: NSObject, StopWatchServiceDelegate {
        var stopWatchService: StopWatchService

        var intervalElapsedWasCalled = false
        
        init(service: StopWatchService) {
            stopWatchService = service
            
            super.init()
            
            stopWatchService.delegate = self;
        }
        
        func stopWatchIntervalElapsed(totalTimeElapsed: TimeInterval) {
            intervalElapsedWasCalled = true
        }
        
        func stopWatchStopped() {
            
        }
        
        func stopWatchPaused() {
            
        }
        
        func stopWatchRestarted() {
            
        }
    }
    
    var service: StopWatchService!
    var fakeDelegate: FakeDelegate!
    
    override func setUp() {
        super.setUp()
        
        service = StopWatchService()
        fakeDelegate = FakeDelegate(service: service)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testStart() {
        let timeToRunUntil = Date().addingTimeInterval(0.5)

        service.start()
        
        RunLoop.current.run(until: timeToRunUntil)
        
        XCTAssertTrue(fakeDelegate.intervalElapsedWasCalled)
        XCTAssertTrue(service.timerRunning)
    }
}
