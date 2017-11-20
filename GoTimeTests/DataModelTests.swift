//
//  DataModelTests.swift
//  GoTime
//
//  Created by John Keith on 2/1/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import XCTest
import CoreData
@testable import GoTime

class DataModelTests: XCTestCase {
    var managedObjectContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        managedObjectContext = DataModelHelpers.setUpInMemoryManagedObjectContext()
    }
    
    func testRunInitSucceedsWithValidAttributes() {
//        let runEntity = NSEntityDescription.entity(forEntityName: "Run", in: self.managedObjectContext)
//        let newRun = NSEntityDescription.insertNewObject(forEntityName: "Run", into: self.managedObjectContext)
//        let run = Run(entity: runEntity!, insertInto: self.managedObjectContext)
        
        let run = Run(context: self.managedObjectContext)
        run.date = Date()

        XCTAssertTrue(try DataModelHelpers.saveManagedObjectContext(context: self.managedObjectContext))
    }
    
    func testRunInitFailsWithInvalidAttributes() {
        _ = Run(context: self.managedObjectContext)
        
        XCTAssertThrowsError(try DataModelHelpers.saveManagedObjectContext(context: self.managedObjectContext))
    }
    
    func testLapInitSucceedsWithValidRelationshipToRun() {
        let run = Run(context: self.managedObjectContext)
        run.date = Date()
        
        let lap = Lap(context: self.managedObjectContext)
        lap.time = 100.0
        
        run.addToLaps(lap)
        
        XCTAssertTrue(try DataModelHelpers.saveManagedObjectContext(context: self.managedObjectContext))
    }
    
    func testLapInitFailsWithNoRelationshipToRun() {
        let run = Run(context: self.managedObjectContext)
        run.date = Date()
        
        let lap = Lap(context: self.managedObjectContext)
        lap.time = 100.0
        
        XCTAssertThrowsError(try DataModelHelpers.saveManagedObjectContext(context: self.managedObjectContext))
    }
}
