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
        
        override func start(initialTime: TimeInterval = NSDate.timeIntervalSinceReferenceDate) {
            startWasCalled = true
        }
        
        override func lap() {
            lapWasCalled = true
        }
    }

    let startButton = FakeStartButton()
    let stopWatchService = FakeStopWatchService()
    let totalTimeLabel = FakeTotalTimeLabel()
    
    var ctrl: MainViewController!
    
    override func setUp() {
        super.setUp()
        
        ctrl = MainViewController(
            startButton: startButton,
            totalTimeLabel: totalTimeLabel,
            stopWatchService: stopWatchService)
        
        _ = ctrl.view
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddSubviews() {
        XCTAssertTrue(startButton.isDescendant(of: ctrl.view))
        XCTAssertTrue(totalTimeLabel.isDescendant(of: ctrl.view))
    }
    
    func testBgColorSet() {
        XCTAssertEqual(ctrl.view.backgroundColor, UIColor.white)
    }
    
    func testViewDoubleTapped() {
        ctrl.viewDoubleTapped()
        
        XCTAssertTrue(stopWatchService.lapWasCalled)
    }
    
    func testAttachLapDoubleTapRecognizer() {
        ctrl.attachLapDoubleTapRecognizer()

        XCTAssertEqual(ctrl.view.gestureRecognizers?.count, 1)
        XCTAssertEqual(ctrl.view.gestureRecognizers?[0], ctrl.lapDoubleTap)
    }
    
    func testOnStartTap() {
        ctrl.onStartTap(sender: startButton)
        
        XCTAssertTrue(startButton.hideWasCalled)
        XCTAssertTrue(totalTimeLabel.showWasCalled)
        XCTAssertTrue(stopWatchService.startWasCalled)
    }
    
    func testStartButtonDelegation() {
        startButton.onStartTap(sender: startButton)
        
        XCTAssertTrue(startButton.hideWasCalled)
    }
}
