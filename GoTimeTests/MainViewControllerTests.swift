//
//  MainViewControllerTests.swift
//  GoTime
//
//  Created by John Keith on 1/23/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import XCTest
@testable import GoTime

class MainViewControllerTests: XCTestCase {
    class FakeStartButton: StartButton {
        var hideWasCalled = false
        
        override func hide() {
            hideWasCalled = true
        }
    }
    
    class FakeTotalTimeLabel: TotalTimeLabel {
        var showWasCalled = false
        
        override func show() {
            showWasCalled = true
        }
    }
    
    class FakeStopWatchService: StopWatchService {
        var startWasCalled = false
        var lapWasCalled = false
        
        override func start(initialTime: TimeInterval = NSDate.timeIntervalSinceReferenceDate, restart: Bool = false) {
            startWasCalled = true
            timerRunning = true
        }
        
        override func lap() {
            lapWasCalled = true
        }
    }
    
    class FakeLapTimeTable: LapTimeTable {
        var setLapDataWasCalled = false
        var showWasCalled = false
        
        override func setLapData(lapData: [Double]) {
            setLapDataWasCalled = true
        }
        
        override func show() {
            showWasCalled = true
        }
    }
    
    class FakeDividerLabel: DividerLabel {
        var showWasCalled = false
        
        override func show() {
            showWasCalled = true
        }
    }

    let startButton = FakeStartButton()
    let stopWatchService = FakeStopWatchService()
    let totalTimeLabel = FakeTotalTimeLabel()
    let lapTimeTable = FakeLapTimeTable()
    let dividerLabel = FakeDividerLabel()
    
    var ctrl: MainViewController!
    
    override func setUp() {
        super.setUp()
        
        ctrl = MainViewController(
            startButton: startButton,
            totalTimeLabel: totalTimeLabel,
            lapTimeTable: lapTimeTable,
            stopWatchService: stopWatchService,
            dividerLabel: dividerLabel)
        
        _ = ctrl.view
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddSubviews() {
        XCTAssertTrue(startButton.isDescendant(of: ctrl.view))
        XCTAssertTrue(totalTimeLabel.isDescendant(of: ctrl.view))
        XCTAssertTrue(lapTimeTable.isDescendant(of: ctrl.view))
        XCTAssertTrue(dividerLabel.isDescendant(of: ctrl.view))
    }
    
    func testBgColorSet() {
        XCTAssertEqual(ctrl.view.backgroundColor, UIColor.white)
    }
    
    // another way to async test as in StopWatchServiceTests use of RunLoop
    func testViewDoubleTappedWhenTimerRunning() {
        ctrl.onStartTap(sender: startButton)
        ctrl.viewDoubleTapped()
        
        let err = expectation(description: "setLapData was not called")
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(self.stopWatchService.lapWasCalled)
            XCTAssertTrue(self.lapTimeTable.setLapDataWasCalled)
            
            err.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testViewDoubleTappedWhenTimerNotRunning() {
        ctrl.viewDoubleTapped()
        
        let err = expectation(description: "setLapData was not called")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertFalse(self.stopWatchService.lapWasCalled)
            XCTAssertTrue(self.lapTimeTable.setLapDataWasCalled)
            
            err.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testAttachDoubleTapRecognizer() {
        ctrl.attachDoubleTapRecognizer()

        XCTAssertEqual(ctrl.view.gestureRecognizers?.count, 1)
        XCTAssertEqual(ctrl.view.gestureRecognizers?[0], ctrl.doubleTapRecognizer)
    }
    
    func testOnStartTap() {
        ctrl.onStartTap(sender: startButton)
        
        XCTAssertTrue(startButton.hideWasCalled)
        XCTAssertTrue(totalTimeLabel.showWasCalled)
        XCTAssertTrue(stopWatchService.startWasCalled)
        XCTAssertTrue(lapTimeTable.showWasCalled)
        XCTAssertTrue(dividerLabel.showWasCalled)
    }
    
    func testStartButtonDelegation() {
        startButton.onStartTap(sender: startButton)
        
        XCTAssertTrue(startButton.hideWasCalled)
    }
    
    func testStopWatchIntervalElapsed() {
        let interval = 60.0
        
        totalTimeLabel.text = "test"
        
        ctrl.stopWatchIntervalElapsed(totalTimeElapsed: interval)
        
        RunLoop.current.run(until: Date().addingTimeInterval(0.5))
        
        XCTAssertEqual(totalTimeLabel.text, TimeToTextService().timeAsSingleString(inputTime: interval))
        XCTAssertTrue(lapTimeTable.setLapDataWasCalled)
    }
}
