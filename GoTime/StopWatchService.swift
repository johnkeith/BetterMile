//
//  TimerService.swift
//  GoTime
//
//  Created by John Keith on 1/27/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

protocol StopWatchServiceDelegate: class {
    func stopWatchIntervalElapsed(totalTimeElapsed: TimeInterval)
    
    func stopWatchStopped()
    
    func stopWatchPaused()
    
    func stopWatchRestarted()
    
    func stopWatchLapStored()
    
    func stopWatchStarted()
}

class StopWatchService: NSObject {
    // TODO: REMOVE - in for backwards comp.
    weak var delegate: StopWatchServiceDelegate?
    var delegates: [StopWatchServiceDelegate] = [] // SMELLY! NEEDS TO BE WEAKLY REFERENCED
    
    var coreData: CoreDataService
    
    var timer: Timer!
    var timerRunning: Bool = false
    var startTime: TimeInterval!
    var elapsedTimeBeforePause: TimeInterval = 0.0

    lazy var lapTimes: Array = [Double]()
    
    init(coreDataService: CoreDataService = CoreDataService.shared) {
        coreData = coreDataService
    }
    
    func start(initialTime: TimeInterval = NSDate.timeIntervalSinceReferenceDate, restart: Bool = false) {
        startTime = initialTime
        timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(timeIntervalElapsed),
            userInfo: nil,
            repeats: true
        )
        
        RunLoop.main.add(timer, forMode: .commonModes)

        timerRunning = true
        
        if(!restart) {
            lapTimes.append(0.0)
        }
        
        delegate?.stopWatchStarted()
        
        delegateToMultiple({ x in x.stopWatchStarted() })
    }
    
    func timeIntervalElapsed() {
        lapTimes[lapTimes.endIndex - 1] = calculateTimeBetweenPointAndNow(initialTime: startTime)
        let totalTimeElapsed = calculateTotalLapsTime(_lapTimes: lapTimes)

        delegate?.stopWatchIntervalElapsed(totalTimeElapsed: totalTimeElapsed)
        
        delegateToMultiple({ x in x.stopWatchIntervalElapsed(totalTimeElapsed: totalTimeElapsed) })
    }
    
    func calculateTotalLapsTime(_lapTimes: [Double]) -> Double {
        return _lapTimes.map{$0}.reduce(0, +)
    }
    
    func calculateTimeBetweenPointAndNow(initialTime: TimeInterval) -> TimeInterval {
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        
        return currentTime - initialTime
    }
    
    func stop() {
        if(timer != nil) {
            timer.invalidate()
        }
        
        resetInitialState()
        
        delegate?.stopWatchStopped()
        
        delegateToMultiple({ x in x.stopWatchStopped() })
    }
    
    func resetInitialState() {
        timer = nil
        timerRunning = false
        startTime = nil
        elapsedTimeBeforePause = 0.0
        lapTimes.removeAll()
    }
    
    func pause() {
        print("pausing")
        elapsedTimeBeforePause = calculateTimeBetweenPointAndNow(initialTime: startTime)
        
        timerRunning = false
        
        timer.invalidate()
        
        delegate?.stopWatchPaused()
        
        delegateToMultiple({ x in x.stopWatchPaused() })
    }
    
    func restart() {
        let newStartTime = NSDate.timeIntervalSinceReferenceDate - elapsedTimeBeforePause
        
        elapsedTimeBeforePause = 0.0
        
        start(initialTime: newStartTime, restart: true)
        
        delegate?.stopWatchRestarted()
        
        delegateToMultiple({ x in x.stopWatchRestarted() })
    }
    
    func lap() {
        timer.invalidate()

        start()
    
        delegate?.stopWatchLapStored()
        
        delegateToMultiple({ x in x.stopWatchLapStored() })
    }
    
    // TODO: IMPROVE. THIS HOLDS STRONG REFERENCES
    // OPTION 1: http://www.gregread.com/2016/02/23/multicast-delegates-in-swift/,
    // OPTION 2: NOTIFICATIONS https://www.andrewcbancroft.com/2014/10/08/fundamentals-of-nsnotificationcenter-in-swift/
    // THAT SAID, THIS DOES WORK, WHICH IS COOL, AND SINCE NOTHING NEEDS TO BE DEALLOCED IN THIS SMALL APP, IT IS OKAY
    func delegateToMultiple(_ fn: ((StopWatchServiceDelegate) -> ())) {
        for _d in self.delegates {
            fn(_d)
        }
    }
}
