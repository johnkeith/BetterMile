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
    
    func start(initialTime: TimeInterval = NSDate.timeIntervalSinceReferenceDate) {
        startTime = initialTime
        timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(timeIntervalElapsed),
            userInfo: nil,
            repeats: true
        )
        timerRunning = true
        lapTimes.append(0.0) // TODO: UNTESTED
    }
    
    func timeIntervalElapsed() {
        lapTimes[lapTimes.endIndex - 1] = calculateTimeBetweenPointAndNow(initialTime: startTime) // TODO: UNTESTED
        let totalTimeElapsed = calculateTotalLapsTime(_lapTimes: lapTimes)

        delegate.stopWatchIntervalElapsed(totalTimeElapsed: totalTimeElapsed)
    }
    
    func calculateTotalTimeElapsed() -> Double {
        let timeSinceStart = calculateTimeBetweenPointAndNow(initialTime: startTime)
        let totalLapTimes = calculateTotalLapsTime(_lapTimes: lapTimes)
        
        return timeSinceStart + totalLapTimes
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
        
        start(initialTime: newStartTime)
        
        delegate.stopWatchRestarted()
    }
    
    func lap() {
        let totalLapTime = calculateTimeBetweenPointAndNow(initialTime: startTime)
        
//        lapTimes.append(totalLapTime)
        
        timer.invalidate()

        start()
        
        delegate.lapStored()
    }
}
