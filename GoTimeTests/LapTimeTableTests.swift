//
//  LapTimeTableTests.swift
//  GoTime
//
//  Created by John Keith on 2/21/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import XCTest
@testable import GoTime

class LapTimeTableTests: XCTestCase {
    let lapData = [1.0, 2.0, 3.0]
    let stopWatchSrv = StopWatchService()
    
    class FakeTimeToTextService: TimeToTextService {
        var timeAsSingleStringCalled = false
        
        override func timeAsSingleString(inputTime: Double) -> String {
            timeAsSingleStringCalled = true
            return "10:10.10"
        }
    }
    
    let timeToTextService = FakeTimeToTextService()
    var table: LapTimeTable!
    
    override func setUp() {
        super.setUp()
        
        stopWatchSrv.lapTimes = lapData
        table = LapTimeTable(stopWatchSrv: stopWatchSrv, hidden: true, timeToTextService: timeToTextService)
    }
    
    func testInitOfTable() {
        XCTAssertTrue(table.isHidden)
        XCTAssertNotNil(table.dataSource)
    }
    
    func testNumberOfSectionsInTableView() {
        XCTAssertEqual(table.numberOfSectionsInTableView(tableView: table), 1)
    }
    
    func testSetLapData() {
//        happens in init
        XCTAssertEqual(table.lapData.count, lapData.count)
        
        let firstCell = table.tableView(table, cellForRowAt: IndexPath(row: 0, section: 1))
        
        XCTAssertNotNil(firstCell)
    }
    
    func testTableViewConvertsTimesAndIncludesLapNumber() {
        table.lapData = lapData
        table.reloadData()
        
        let firstCell = table.tableView(table, cellForRowAt: IndexPath(row: 0, section: 1))
        let firstCellTextLabel = firstCell.contentView.subviews[0] as! UILabel

        XCTAssertEqual(firstCellTextLabel.text!, "03 - 10:10.10")
        XCTAssertTrue(timeToTextService.timeAsSingleStringCalled)
    }
    
    func testHide() {
        table.hide()
        XCTAssertTrue(table.isHidden)
    }
    
    func testShow() {
        table.show()
        XCTAssertFalse(table.isHidden)
    }
}
