//
//  AnimationServiceTests.swift
//  GoTime
//
//  Created by John Keith on 3/18/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import XCTest
@testable import GoTime

class AnimationServiceTests: XCTestCase {
    var view: TimerHelpTextLabel!
    var service: AnimationService!
    
    override func setUp() {
        super.setUp()
        
        view = TimerHelpTextLabel()
        service = AnimationService()
    }
    
    func testAnimateFadeInView() {
        service.animateFadeInView(viewToFadeIn: view)
        
        RunLoop.current.run(until: Date().addingTimeInterval(0.3))
        
        XCTAssertEqual(view.alpha, 1.0)
    }
    
    func testAnimateFadeOutView() {
        service.animateFadeOutView(viewToFadeOut: view)
        
        RunLoop.current.run(until: Date().addingTimeInterval(0.3))
        
        XCTAssertTrue(view.isHidden)
        XCTAssertEqual(view.alpha, 1.0)
    }
    
}
