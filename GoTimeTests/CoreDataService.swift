//
//  CoreDataService.swift
//  GoTime
//
//  Created by John Keith on 2/2/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import XCTest
import CoreData
@testable import GoTime

// Mostly, these tests are unneeded. They are a hold over of my tendency to test more than necessary in RSpec/Jasmine,
// where there is not the type checking of Swift

class CoreDataServiceTests: XCTestCase {
    func testServiceCanBeInit() {
        XCTAssertTrue((CoreDataService.init() as Any) is CoreDataService)
    }
    
    func testServiceCanBeAccessedAsSingleton() {
        XCTAssertTrue((CoreDataService.shared as Any) is CoreDataService)
    }
    
    func testViewContextReturnsManagedObjectContext() {
        XCTAssertTrue((CoreDataService.shared.viewContext as Any) is NSManagedObjectContext)
    }
    
    func testBackgroundContextReturnsManagedObjectContext() {
        XCTAssertTrue((CoreDataService.shared.backgroundContext as Any) is NSManagedObjectContext)
    }
}
