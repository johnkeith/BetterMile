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
    
    func testRunInit() {
        let run = NSEntityDescription.entity(forEntityName: "Run", in: self.managedObjectContext)
        print(run)
    }
}
