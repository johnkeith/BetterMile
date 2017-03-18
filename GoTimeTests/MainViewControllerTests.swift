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
            super.hide()
            
            hideWasCalled = true
        }
    }
    
    class FakeTotalTimeLabel: TotalTimeLabel {
        var showWasCalled = false
        
        override func show() {
            super.show()
            
            showWasCalled = true
        }
    }
    
    class FakeStopWatchService: StopWatchService {
        var startWasCalled = false
        var lapWasCalled = false
        var restartWasCalled = false
        var pauseWasCalled = false
        var stopWasCalled = false
        
        override func start(initialTime: TimeInterval = NSDate.timeIntervalSinceReferenceDate, restart: Bool = false) {
            super.start()
            
            startWasCalled = true
            timerRunning = true
        }
        
        override func lap() {
            super.lap()
            
            lapWasCalled = true
        }
        
        override func restart() {
            super.restart()
            
            restartWasCalled = true
        }
        
        override func pause() {
            super.pause()
            
            pauseWasCalled = true
        }
        
        override func stop() {
            super.stop()
            
            stopWasCalled = true
        }
    }
    
    class FakeLapTimeTable: LapTimeTable {
        var setLapDataWasCalled = false
        var showWasCalled = false
        
        override func setLapData(lapData: [Double]) {
            super.setLapData(lapData: lapData)
            
            setLapDataWasCalled = true
        }
        
        override func show() {
            super.show()
            
            showWasCalled = true
        }
    }
    
    class FakeDividerLabel: DividerLabel {
        var showWasCalled = false
        
        override func show() {
            super.show()
            
            showWasCalled = true
        }
    }
    
    class FakeEndedLongPressRecognizer: UILongPressGestureRecognizer {
        override var state: UIGestureRecognizerState {
            return UIGestureRecognizerState.ended
        }
    }
    
    class FakeTimerHelpTextLabel: TimerHelpTextLabel {
        var showBrieflyWasCalled = false
        
        override func showBriefly() {
            super.showBriefly()
            
            showBrieflyWasCalled = true
        }
    }

    let startButton = FakeStartButton()
    let stopWatchService = FakeStopWatchService()
    let totalTimeLabel = FakeTotalTimeLabel()
    let lapTimeTable = FakeLapTimeTable()
    let dividerLabel = FakeDividerLabel()
    let timerHelpTextLabel = FakeTimerHelpTextLabel()
    
    var ctrl: MainViewController!
    
    override func setUp() {
        super.setUp()
        
        ctrl = MainViewController(
            startButton: startButton,
            totalTimeLabel: totalTimeLabel,
            lapTimeTable: lapTimeTable,
            stopWatchService: stopWatchService,
            dividerLabel: dividerLabel,
            timerHelpTextLabel: timerHelpTextLabel)
        
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
        XCTAssertTrue(timerHelpTextLabel.isDescendant(of: ctrl.view))
    }
    
    func testBgColorSet() {
        XCTAssertEqual(ctrl.view.backgroundColor, UIColor.white)
    }
    
    // another way to async test as in StopWatchServiceTests use of RunLoop
    func testViewDoubleTappedWhenTimerRunning() {
        ctrl.onStartTap(sender: startButton)
        ctrl.viewDoubleTapped()
        
        let err = expectation(description: "setLapData was not called")
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertTrue(self.stopWatchService.startWasCalled)
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertTrue(self.stopWatchService.restartWasCalled)
            XCTAssertTrue(self.lapTimeTable.setLapDataWasCalled)
            
            err.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testViewLongPressedWhenTimerRunning() {
        ctrl.onStartTap(sender: startButton)
        ctrl.viewLongPressed(sender: FakeEndedLongPressRecognizer())
        
        RunLoop.current.run(until: Date().addingTimeInterval(0.2))
        
        XCTAssertTrue(self.stopWatchService.pauseWasCalled)
        XCTAssertTrue(self.lapTimeTable.setLapDataWasCalled)
    }
    
    func testViewLongPressedWhenTimerNotRunning() {
        ctrl.attachDoubleTapRecognizer()
        ctrl.attachLongPressRecognizer()
        ctrl.viewLongPressed(sender: FakeEndedLongPressRecognizer())
        
        RunLoop.current.run(until: Date().addingTimeInterval(0.2))
        
        XCTAssertTrue(self.stopWatchService.stopWasCalled)
        XCTAssertFalse(self.lapTimeTable.setLapDataWasCalled)
    }
    
    func testAttachDoubleTapRecognizer() {
        ctrl.attachDoubleTapRecognizer()

        XCTAssertEqual(ctrl.view.gestureRecognizers?.count, 1)
        XCTAssertEqual(ctrl.view.gestureRecognizers?[0], ctrl.doubleTapRecognizer)
    }
    
    func testAttachLongPressRecognizer() {
        ctrl.attachLongPressRecognizer()
        
        XCTAssertEqual(ctrl.view.gestureRecognizers?.count, 1)
        XCTAssertEqual(ctrl.view.gestureRecognizers?[0], ctrl.longPressRecognizer)
    }
    
    func testRemoveViewRecognizers() {
        ctrl.attachDoubleTapRecognizer()
        ctrl.attachLongPressRecognizer()
        
        ctrl.removeViewRecognizers()
        
        XCTAssertEqual(ctrl.view.gestureRecognizers?.count, 0)
    }
    
    func testOnStartTap() {
        ctrl.onStartTap(sender: startButton)
        
        XCTAssertTrue(startButton.hideWasCalled)
        XCTAssertTrue(totalTimeLabel.showWasCalled)
        XCTAssertTrue(stopWatchService.startWasCalled)
        XCTAssertTrue(lapTimeTable.showWasCalled)
        XCTAssertTrue(dividerLabel.showWasCalled)
        XCTAssertTrue(timerHelpTextLabel.showBrieflyWasCalled)
    }
    
    func testStartButtonDelegation() {
        startButton.onStartTap(sender: startButton)
        
        XCTAssertTrue(startButton.hideWasCalled)
    }
    
    func testStopWatchIntervalElapsed() {
        let interval = 60.0
        
        totalTimeLabel.text = "test"
        
        ctrl.stopWatchIntervalElapsed(totalTimeElapsed: interval)
        
        RunLoop.current.run(until: Date().addingTimeInterval(0.2))
        
        XCTAssertEqual(totalTimeLabel.text, TimeToTextService().timeAsSingleString(inputTime: interval))
        XCTAssertTrue(lapTimeTable.setLapDataWasCalled)
    }
    
    // You must test all side effects!
    func testStopWatchStopped() {
        ctrl.onStartTap(sender: startButton)
        
        ctrl.stopWatchStopped()
        
        XCTAssertEqual(ctrl.view.gestureRecognizers?.count, 0)
        XCTAssertTrue(ctrl.totalTimeLabel.isHidden)
        XCTAssertTrue(ctrl.dividerLabel.isHidden)
        XCTAssertTrue(ctrl.lapTimeTable.isHidden)
        XCTAssertEqual(ctrl.lapTimeTable.lapData.count, 0)
        XCTAssertFalse(ctrl.startButton.isHidden)
    }
}
