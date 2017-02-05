//
//  RunPersistanceService.swift
//  GoTime
//
//  Created by John Keith on 2/4/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import Foundation

class RunPersistanceService {
    var coreData: CoreDataService
    var lapTimes: [Double]
    
    init(_lapTimes: [Double], _coreData: CoreDataService = CoreDataService.shared) {
        lapTimes = _lapTimes
        coreData = _coreData
    }
    
    func save() { // untested
        let run = createRun()
        let laps = createLaps()
        
        run.laps = laps
        
        coreData.save()
    }

    
    func createRun() -> Run { // untested
        let run = Run(context: coreData.viewContext)
        run.date = NSDate()
        
        return run
    }
    
    func createLaps() -> NSOrderedSet { // untested
        let lapsCollection = lapTimes.map { (time) -> Lap in
            let lap = Lap(context: coreData.viewContext)
            lap.time = time
            
            return lap
        }
        
        return NSOrderedSet(array: lapsCollection)
    }
}
