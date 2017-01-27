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

    let startButton = FakeStartButton()
    
    var ctrl: MainViewController!
    
    override func setUp() {
        super.setUp()
        
        ctrl = MainViewController(startButton: startButton)
        
        _ = ctrl.view
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // CONTEXT viewDidLoad()
    
    func testStartButtonViewAdded() {
        XCTAssertTrue(startButton.isDescendant(of: ctrl.view))
    }
    
    func testBgColorSet() {
        XCTAssertEqual(ctrl.view.backgroundColor, UIColor.white)
    }
    
    // END viewDidLoad()
    
    func testOnStartTap() {
        ctrl.onStartTap(sender: startButton)
        
        XCTAssertTrue(startButton.hideWasCalled)
    }
    
    func testStartButtonDelegation() {
        startButton.onStartTap(sender: startButton)
        
        XCTAssertTrue(startButton.hideWasCalled)
    }
}
