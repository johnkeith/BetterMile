//
//  RunPersistanceServiceTests.swift
//  GoTime
//
//  Created by John Keith on 2/4/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import XCTest
@testable import GoTime

class RunPersistanceServiceTests: XCTestCase {
    let fakeCoreData = FakeCoreDataService()

    var service: RunPersistanceService!
    
    override func setUp() {
        let lapTimes = [100.0, 60.0, 30.0]
        
        service = RunPersistanceService(_lapTimes: lapTimes, _coreData: fakeCoreData)
    }
    
    func testSave() {
        // also testing createRun() and createLaps through this test
        service.save()
        
        XCTAssertTrue(fakeCoreData.saveWasCalled)
    }
}
