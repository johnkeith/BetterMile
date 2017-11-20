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
    let lapTimesMock = [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0]
    
    class FakeDelegate: NSObject, StopWatchServiceDelegate {
        func stopWatchLapRemoved() {
            print("just a fake")
        }
        
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
        
        func stopWatchLapStored(lapTime: Double, lapNumber: Int, totalTime: Double) {
            lapWasCalled = true
            timesLapWasCalled += 1
        }
    }

    private typealias klass = StopWatchService
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
        
        let result = klass.calculateTotalLapsTime(laps: service.lapTimes)
        
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
    
    func testFindFastestLap() {
        let result = StopWatchService.findFastestLapIndex(service.lapTimes)
        
        XCTAssertNil(result)
        
        service.start()
        
        service.lap()
        
        let secondResult = StopWatchService.findFastestLapIndex(service.lapTimes)
        
        XCTAssertEqual(secondResult, 0)
        
        let testLapTimes = [1.0,2.0,3.0]
        
        let thirdResult = StopWatchService.findFastestLapIndex(testLapTimes)
        
        XCTAssertEqual(thirdResult, 0)
    }
    
    func testFindSlowestLap() {
        let result = StopWatchService.findSlowestLapIndex(service.lapTimes)
        
        XCTAssertNil(result)
        
        service.start()
        
        service.lap()
        
        let secondResult = StopWatchService.findSlowestLapIndex(service.lapTimes)
        
        XCTAssertEqual(secondResult, 0)
        
        let testLapTimes = [1.0,2.0,3.0]
        
        let thirdResult = StopWatchService.findSlowestLapIndex(testLapTimes)
        
        XCTAssertEqual(thirdResult, 2)
    }
    
    func testCalculateAverageLapTime() {
        service.lapTimes = [10.0, 8.0, 0.0]
        
        let result = klass.calculateAverageLapTime(laps: service.lapTimes)
        
        XCTAssertEqual(6.0, result)
        
        let secondResult = klass.calculateAverageLapTime(laps: service.completedLapTimes())
        
        XCTAssertEqual(9.0, secondResult)
    }
    
    func testCalculateStandardDeviation() {
        service.lapTimes = lapTimesMock
        
        let result = klass.calculateStandardDeviation(laps: service.lapTimes)
        
        XCTAssertEqual(2, result)
    }
    
    func testDetermineLapQualityWhenGood() {
        service.lapTimes = lapTimesMock
        
        let result = klass.determineLapQuality(lap: 5.0, laps: service.lapTimes)
        
        XCTAssertEqual(LapQualities.good, result)
    }
    
    func testDetermineLapQualityWhenBad() {
        service.lapTimes = lapTimesMock
        
        let result = klass.determineLapQuality(lap: 7.0, laps: service.lapTimes)
        
        XCTAssertEqual(LapQualities.bad, result)
    }
    
    func testDetermineLapQualityWhenUgly() {
        service.lapTimes = lapTimesMock
        
        let result = klass.determineLapQuality(lap: 10.0, laps: service.lapTimes)
        
        XCTAssertEqual(LapQualities.ugly, result)
    }
    
    func testCalculateLapDeviationPercentage() {
        service.lapTimes = lapTimesMock
        
        let result = service.calculateLapDeviationPercentage(lapTime: 5.34)
        
        XCTAssertEqual(result, 0.585)
    }
    
    func testStartPingInterval() {
        Constants.storedSettings.set(true, forKey: SettingsService.intervalKey)
        
        service.startPingInterval()
        
        XCTAssertNotNil(service.pingTimer)
    }
}
