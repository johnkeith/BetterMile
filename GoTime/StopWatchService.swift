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
}

class StopWatchService: NSObject {
    var delegate: StopWatchServiceDelegate!
    
    var startTime: TimeInterval!
    var timer: Timer!
    var timerRunning: Bool = false
    var elapsedTimeBeforePause: TimeInterval!
    
    override init() {
        super.init()
    }
    
    func start(initialTime: TimeInterval = NSDate.timeIntervalSinceReferenceDate) { // UNTESTED
        startTime = initialTime
        timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(timeIntervalElapsed),
            userInfo: nil,
            repeats: true
        )
        timerRunning = true
    }
    
    func timeIntervalElapsed() { // UNTESTED
        let totalTimeElapsed = calculateTimeBetweenPointAndNow(initialTime: startTime)
        
        delegate.stopWatchIntervalElapsed(totalTimeElapsed: totalTimeElapsed)
    }
    
    func calculateTimeBetweenPointAndNow(initialTime: TimeInterval) -> TimeInterval { // UNTESTED
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        
        return initialTime - currentTime
    }
    
    func stop() { // UNTESTED
        timer.invalidate()
        
        resetInitialState()
        
        delegate.stopWatchStopped()
    }
    
    func resetInitialState() { // UNTESTED
        startTime = nil
        timer = nil
        timerRunning = false
        elapsedTimeBeforePause = nil
    }
    
    func pause() { // UNTESTED
        elapsedTimeBeforePause = calculateTimeBetweenPointAndNow(initialTime: startTime)
        
        timer.invalidate()
        
        delegate.stopWatchPaused()
    }
    
    func restart() { // UNTESTED
        let newStartTime = NSDate.timeIntervalSinceReferenceDate - elapsedTimeBeforePause
        
        start(initialTime: newStartTime)
        
        delegate.stopWatchRestarted()
    }
}
