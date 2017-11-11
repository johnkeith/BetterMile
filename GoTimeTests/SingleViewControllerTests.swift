//
//  SingleViewControllerTests.swift
//  GoTime
//
//  Created by John Keith on 1/23/17.
//  Copyright © 2017 John Keith. All rights reserved.

import XCTest
@testable import GoTime

class SingleViewControllerTests: XCTestCase {
    var mainNavCtrl: UINavigationController!
    var ctrl: SingleViewController!

    override func setUp() {
        super.setUp()
        
        ctrl = SingleViewController()
        
        mainNavCtrl = UINavigationController()
        ctrl = SingleViewController()
        mainNavCtrl.viewControllers = [ctrl]
        
        _ = ctrl.view
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testViewWillAppearSetsLapTimeLbl() {
        ctrl.stopWatchSrv.lapTimes = [1]
        ctrl.viewWillAppear(false)
        
        XCTAssertEqual(ctrl.lapTimeLbl.text, "Lap   00:01.00")
    }
    
    func testOnAvancedSettingsTapShouldSetPingInterval() {
        XCTAssertNil(ctrl.pingIntervalBeforeSettingsShown)
        
        Constants.storedSettings.set(true, forKey: SettingsService.intervalKey)
        Constants.storedSettings.set(15, forKey: SettingsService.intervalAmountKey)
        
        ctrl.onAdvancedSettingsTap()
        
        XCTAssertNotNil(ctrl.pingIntervalBeforeSettingsShown)
    }
    
    func testOnAvancedSettingsTapShouldNotDisplaySettingsViewIfVisible() {
        XCTAssertNil(ctrl.pingIntervalBeforeSettingsShown)
        
        Constants.storedSettings.set(true, forKey: SettingsService.intervalKey)
        Constants.storedSettings.set(15, forKey: SettingsService.intervalAmountKey)
        
        ctrl.settingsView.isHidden = false
        ctrl.onAdvancedSettingsTap()
        
        XCTAssertNil(ctrl.pingIntervalBeforeSettingsShown)
    }
    
    func testOnPauseTap() {
        ctrl.onStartTap()
        ctrl.onPauseTap()
        
        XCTAssertTrue(ctrl.stopWatchSrv.isPaused())
    }
    
    func testOnStartTap() {
        ctrl.onStartTap()
        
        XCTAssertFalse(ctrl.stopWatchSrv.isPaused())
        XCTAssertEqual(ctrl.lapLbl.text, "01")
    }
    
    func testOnRestartTap() {
        ctrl.onStartTap()
        ctrl.onPauseTap()
        ctrl.onRestartTap()
        
        XCTAssertFalse(ctrl.stopWatchSrv.isPaused())
    }
    
    func testSetLapLblTextLessThan10() {
        ctrl.setLapLblText(lapCount: 4)
        XCTAssertEqual("04", ctrl.lapLbl.text)
    }
    
    func testSetLapLblTextGreaterThan10() {
        ctrl.setLapLblText(lapCount: 11)
        XCTAssertEqual("11", ctrl.lapLbl.text)
    }
    
    func testSetTotalTimeLblText() {
        ctrl.setTotalTimeLblText(totalTimeElapsed: 10.0)
        XCTAssertEqual("Total 00:10.00", ctrl.totalTimeLbl.text)
    }
    
    func testSetLapTimeLblText() {
        ctrl.setLapTimeLblText(lapTime: 10.0)
        XCTAssertEqual("Lap   00:10.00", ctrl.lapTimeLbl.text)
    }
    
    func testNotifyWithVoiceIfEnabled() {
        ctrl.notifyWithVoiceIfEnabled(lapTime: 10.0, lapNumber: 1)
        XCTAssertEqual(ctrl.speechSrv.voiceQueue.count, 1)
    }
    
    func testOnSaveHandlesWhenPingIsTurnedOffInSettings() {
        Constants.storedSettings.set(true, forKey: SettingsService.intervalKey)
        Constants.storedSettings.set(15, forKey: SettingsService.intervalAmountKey)
        
        ctrl.onStartTap()
        
        XCTAssertNotNil(ctrl.stopWatchSrv.pingTimer)
        
        Constants.storedSettings.set(false, forKey: SettingsService.intervalKey)
        
        ctrl.onSave()
        
        XCTAssertFalse(ctrl.stopWatchSrv.pingTimer.isValid)
        XCTAssertNil(ctrl.pingIntervalBeforeSettingsShown)
    }
    
    func testOnSaveHandlesWhenPingIsOnAndNewPingLengthSet() {
        Constants.storedSettings.set(true, forKey: SettingsService.intervalKey)
        Constants.storedSettings.set(15, forKey: SettingsService.intervalAmountKey)
        
        ctrl.onStartTap()
        
        XCTAssertNotNil(ctrl.stopWatchSrv.pingTimer)
        
        ctrl.pingIntervalBeforeSettingsShown = 15
        
        Constants.storedSettings.set(18, forKey: SettingsService.intervalAmountKey)
        
        ctrl.onSave()
        
        XCTAssertTrue(ctrl.stopWatchSrv.pingTimer.isValid)
    }
    
    func testOnSaveHandlesWhenPingIsSetWhenOffBeforeSet() {
        Constants.storedSettings.set(false, forKey: SettingsService.intervalKey)
        
        ctrl.onStartTap()
        
        XCTAssertNil(ctrl.stopWatchSrv.pingTimer)
        
        Constants.storedSettings.set(true, forKey: SettingsService.intervalKey)
        Constants.storedSettings.set(18, forKey: SettingsService.intervalAmountKey)
        
        ctrl.onSave()
        
        XCTAssertTrue(ctrl.stopWatchSrv.pingTimer.isValid)
    }
}
