//
//  CoreDataService.swift
//  GoTime
//
//  Created by John Keith on 2/2/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import CoreData

// much of implementation lifted from https://swifting.io/blog/2016/09/25/25-core-data-in-ios10-nspersistentcontainer/

final class CoreDataService {
    static let sharedInstance = CoreDataService()
    private init() {}
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GoTime")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                NSLog("CoreData error \(error), \(error._userInfo)")
            }
        })
        
        return container
    }()
    
    static var viewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    static var backgroundContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()
    
    class func save() {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                NSLog("CoreData error \(error), \(error._userInfo)")
            }
        }
    }
    
    class func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        viewContext.perform {
            block(self.viewContext)
        }
    }
    
    class func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
    
    
}
