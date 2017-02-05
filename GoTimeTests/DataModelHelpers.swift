//
//  DataModelTestsHelper.swift
//  GoTime
//
//  Created by John Keith on 2/1/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import XCTest
import CoreData
@testable import GoTime

enum SaveManagedContextError: Error {
    case Fail
}

class DataModelHelpers {
    static let sharedInstance = DataModelHelpers()
    private init() {}
    
    class func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
    
    class func saveManagedObjectContext(context: NSManagedObjectContext) throws -> Bool {
        do {
            try context.save()
            
            return true
        } catch {
            throw(SaveManagedContextError.Fail)
        }
    }
}

class FakeCoreDataService: CoreDataService {
    var saveWasCalled = false
    
    override func save() {
        saveWasCalled = true
    }
}

