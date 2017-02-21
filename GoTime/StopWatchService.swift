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
    
    func lapStored()
}

class StopWatchService: NSObject {
    var delegate: StopWatchServiceDelegate!
    
    var coreData: CoreDataService
    
    var timer: Timer!
    var timerRunning: Bool = false
    var startTime: TimeInterval!
    var elapsedTimeBeforePause: TimeInterval!

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
        timerRunning = true
        
        if(!restart) {
            lapTimes.append(0.0)
        }
    }
    
    func timeIntervalElapsed() {
        lapTimes[lapTimes.endIndex - 1] = calculateTimeBetweenPointAndNow(initialTime: startTime)
        let totalTimeElapsed = calculateTotalLapsTime(_lapTimes: lapTimes)

        delegate.stopWatchIntervalElapsed(totalTimeElapsed: totalTimeElapsed)
    }
    
    func calculateTotalLapsTime(_lapTimes: [Double]) -> Double {
        return _lapTimes.map{$0}.reduce(0, +)
    }
    
    func calculateTimeBetweenPointAndNow(initialTime: TimeInterval) -> TimeInterval {
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        
        return currentTime - initialTime
    }
    
    func stop() {
        timer.invalidate()
        
        resetInitialState()
        
        delegate.stopWatchStopped()
    }
    
    func resetInitialState() {
        timer = nil
        timerRunning = false
        startTime = nil
        elapsedTimeBeforePause = nil
        lapTimes.removeAll()
    }
    
    func pause() {
        elapsedTimeBeforePause = calculateTimeBetweenPointAndNow(initialTime: startTime)
        
        timer.invalidate()
        
        delegate.stopWatchPaused()
    }
    
    func restart() {
        let newStartTime = NSDate.timeIntervalSinceReferenceDate - elapsedTimeBeforePause
        
        elapsedTimeBeforePause = nil
        
        start(initialTime: newStartTime, restart: true)
        
        delegate.stopWatchRestarted()
    }
    
    func lap() {
        timer.invalidate()

        start()
        
        delegate.lapStored()
    }
}
