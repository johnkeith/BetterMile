//
//  LapTimeTableCellTests.swift
//  GoTime
//
//  Created by John Keith on 3/13/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import XCTest
@testable import GoTime

class LapTimeTableCellTests: XCTestCase {
    var cell: LapTimeTableCell!
    
    override func setUp() {
        super.setUp()
        
        cell = LapTimeTableCell()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCellHasNoSelectionStyle() {
        XCTAssertEqual(cell.selectionStyle, UITableViewCellSelectionStyle.none)
    }
    
    func testSetContent() {
        cell.setContent(labelText: "This is my cell")
        
        XCTAssertEqual(cell.contentView.subviews.count, 2)
    }
}
