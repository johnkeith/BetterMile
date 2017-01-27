//
//  StartButtonTests.swift
//  GoTime
//
//  Created by John Keith on 1/26/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import XCTest
@testable import GoTime

class StartButtonTests: XCTestCase {
    var button: StartButton!
    var delegateCtlr: UIViewController!
    
    class FakeDelegate: UIViewController, StartButtonDelegate {
        var startButton: StartButton!
        var hideWasCalled = false
        
        init(startButton: StartButton) {
            self.startButton = startButton
            
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            startButton.delegate = self
        }
        
        func onStartTap(sender: StartButton) {
            hideWasCalled = true
        }
    }
    
    override func setUp() {
        super.setUp()
        
        button = StartButton()
        delegateCtlr = FakeDelegate(startButton: button)
        _ = delegateCtlr.view
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testOnStartTapDelegation() {
        button.onStartTap(sender: button)
        print(delegateCtlr.hideWasCalled)
        XCTAssertTrue(delegateCtlr.hideWasCalled)
    }
}
