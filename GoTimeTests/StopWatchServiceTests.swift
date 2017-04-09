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

        var currentTimePassed = 0.0
        var intervalElapsedWasCalled = false
        var stopWasCalled = false
        var numberOfIntervalsElapsed = 0
        var pauseWasCalled = false
        var restartWasCalled = false
        var lapWasCalled = false
        var timesLapWasCalled = 0
        
        init(service: StopWatchService) {
            stopWatchService = service
            
            super.init()
            
            stopWatchService.delegate = self;
            stopWatchService.delegates = [self, self]
        }
        
        func stopWatchIntervalElapsed(totalTimeElapsed: TimeInterval) {
            intervalElapsedWasCalled = true
            currentTimePassed = totalTimeElapsed
            numberOfIntervalsElapsed = numberOfIntervalsElapsed + 1
        }
        
        func stopWatchStarted() {
            
        }
        
        func stopWatchStopped() {
            stopWasCalled = true
        }
        
        func stopWatchPaused() {
            pauseWasCalled = true
        }
        
        func stopWatchRestarted() {
            restartWasCalled = true
        }
        
        func stopWatchLapStored() {
            lapWasCalled = true
            timesLapWasCalled += 1
        }
    }

    var service: StopWatchService!
    var fakeDelegate: FakeDelegate!
    var timeToRunUntil: Date!
    
    override func setUp() {
        super.setUp()
        
        service = StopWatchService()
        fakeDelegate = FakeDelegate(service: service)
        timeToRunUntil = getTimeToRunUntil()
    }
    
    override func tearDown() {
        super.tearDown()
        
        fakeDelegate.timesLapWasCalled = 0
    }
    
    func waitForTimer(until: Date?) {
        RunLoop.current.run(until: until ?? timeToRunUntil)
    }
    
    func getTimeToRunUntil(timeToWait: Double = 0.5) -> Date {
        return Date().addingTimeInterval(timeToWait)
    }
    
    func testStart() {
        service.start()
        
        waitForTimer(until: nil)
        
        XCTAssertTrue(fakeDelegate.intervalElapsedWasCalled)
        XCTAssertTrue(service.timerRunning)
        XCTAssertEqual(service.lapTimes.count, 1)
    }
    
    func testTimeIntervalElapsed() {
        service.start()
        
        waitForTimer(until: nil)
        
        XCTAssertTrue(fakeDelegate.intervalElapsedWasCalled)
        XCTAssertLessThan(fakeDelegate.currentTimePassed, 1)
    }
    
    func testCalculateTotalLapTime() {
        service.start()
        
        waitForTimer(until: nil)
        
        service.lap()
        
        let result = service.calculateTotalLapsTime(_lapTimes: service.lapTimes)
        
        XCTAssertGreaterThan(result, 0.0)
    }
    
    func testCalculateTimeBetweenPointAndNow() {
        let results = service.calculateTimeBetweenPointAndNow(initialTime: 0.0)
        
        XCTAssertGreaterThan(results, 0.0)
    }
    
    func testStop() {
        service.start()
        
        waitForTimer(until: nil)
        
        service.stop()
        
        let totalNumberOfTimesElapsedBeforeStop = fakeDelegate.numberOfIntervalsElapsed
        
        let newTimeToRunUntil = getTimeToRunUntil()

        waitForTimer(until: newTimeToRunUntil)
        
        XCTAssertEqual(totalNumberOfTimesElapsedBeforeStop, fakeDelegate.numberOfIntervalsElapsed)
        XCTAssertTrue(fakeDelegate.stopWasCalled)
    }
    
    func testResetInitialState() {
        service.start()
        
        service.stop()
        
        XCTAssertNil(service.startTime)
        XCTAssertNil(service.timer)
        XCTAssertFalse(service.timerRunning)
        XCTAssertEqual(service.elapsedTimeBeforePause, 0.0)
        XCTAssertEqual(service.lapTimes.count, 0)
    }
    
    func testPause() {
        service.start()
        
        waitForTimer(until: nil)
        
        service.pause()
        
        let totalNumberOfTimesElapsedBeforeStop = fakeDelegate.numberOfIntervalsElapsed
        
        let newTimeToRunUntil = getTimeToRunUntil()
        
        waitForTimer(until: newTimeToRunUntil)
        
        XCTAssertEqual(totalNumberOfTimesElapsedBeforeStop, fakeDelegate.numberOfIntervalsElapsed)
        XCTAssertTrue(fakeDelegate.pauseWasCalled)
    }
    
    func testRestart() {
        service.start()
        
        waitForTimer(until: nil)
        
        service.pause()
        
        waitForTimer(until: getTimeToRunUntil(timeToWait: 1.0))
        
        service.restart()
        
        // this tests that we are setting the start time for the restart to be 
        // before now, so that we preserve the amount of time that passed before
        
        XCTAssertLessThan(service.startTime, NSDate.timeIntervalSinceReferenceDate)
        XCTAssertTrue(fakeDelegate.restartWasCalled)
        XCTAssertEqual(service.lapTimes.count, 1)
    }
    
    func testLap() {
        service.start()
        
        service.lap()
        service.lap()
        
        let result = service.lapTimes.count
        
        XCTAssertEqual(result, 3)
        XCTAssertTrue(fakeDelegate.lapWasCalled)
    }
    
    func testDelegateToMultiple() {
        service.start()
        
        service.lap()

        XCTAssertEqual(fakeDelegate.timesLapWasCalled, 3)
    }
}
