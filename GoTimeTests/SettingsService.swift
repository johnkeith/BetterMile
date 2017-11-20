//
//  SettingsService.swift
//  GoTimeTests
//
//  Created by John Keith on 11/5/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import XCTest
@testable import GoTime

class SettingsServiceTests: XCTestCase {
    override func setUp() {
        super.setUp()
        let bundle = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: bundle!)
    }
    
    func assertDefaultSettings() {
        XCTAssertTrue(Constants.storedSettings.bool(forKey: SettingsService.previousLapTimeKey))
        XCTAssertTrue(Constants.storedSettings.bool(forKey: SettingsService.averageLapTimeKey))
        XCTAssertTrue(Constants.storedSettings.bool(forKey: SettingsService.vibrationNotificationsKey))
        XCTAssertEqual(12, Constants.storedSettings.integer(forKey: SettingsService.milePaceAmountKey))
        XCTAssertEqual(15, Constants.storedSettings.integer(forKey: SettingsService.intervalAmountKey))
    }
    
    func testIncrementRunAppCount() {
        SettingsService.incrementAppRunCount()
        
        XCTAssertEqual(1, Constants.storedSettings.integer(forKey: Constants.appRunTimes))
    }
    
    func testFirstRunSetup() {
        XCTAssertFalse(Constants.storedSettings.bool(forKey: SettingsService.previousLapTimeKey))
        XCTAssertFalse(Constants.storedSettings.bool(forKey: SettingsService.averageLapTimeKey))
        XCTAssertFalse(Constants.storedSettings.bool(forKey: SettingsService.vibrationNotificationsKey))
        XCTAssertEqual(0, Constants.storedSettings.integer(forKey: SettingsService.milePaceAmountKey))
        XCTAssertEqual(0, Constants.storedSettings.integer(forKey: SettingsService.intervalAmountKey))
        
        SettingsService.firstRunSetup()
        assertDefaultSettings()
    }
    
    func testResetToDefaultSettings() {
        Constants.storedSettings.set(false, forKey: SettingsService.previousLapTimeKey)
        Constants.storedSettings.set(true, forKey: SettingsService.averageLapTimeKey)
        Constants.storedSettings.set(false, forKey: SettingsService.vibrationNotificationsKey)
        Constants.storedSettings.set(3, forKey: SettingsService.milePaceAmountKey)
        Constants.storedSettings.set(60, forKey: SettingsService.intervalAmountKey)
        
        SettingsService.resetToDefaultSettings()
        assertDefaultSettings()
    }
}
