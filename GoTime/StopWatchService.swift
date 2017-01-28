//
//  TimerService.swift
//  GoTime
//
//  Created by John Keith on 1/27/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import Foundation

protocol StopWatchServiceDelegate {
    func stopWatchIntervalElapsed(totalTimeElapsed: TimeInterval)
    
    func stopWatchStopped()
    
    func stopWatchPaused()
    
    func stopWatchRestarted()
}

class StopWatchService: NSObject, StopWatchServiceDelegate {
    var delegate: StopWatchServiceDelegate!
    
    var startTime: TimeInterval!
    var timer: Timer!
    var timerRunning: Bool = false
    var elapsedTimeBeforePause: TimeInterval!
    
    override init() {
        super.init()
    }
    
    func start(startTime: TimeInterval = NSDate.timeIntervalSinceReferenceDate) { // UNTESTED
        startTime = startTime
        timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(timeIntervalElapsed),
            userInfo: nil,
            repeats: true
        )
        timerRunning = true
    }
    
    func stop() { // UNTESTED
        timer.invalidate()
        
        resetInitialState()
        
        delegate.stopWatchStopped()
    }
    
    func pause() { // UNTESTED
        elapsedTimeBeforePause = calculateTimeBetweenPointAndNow(initialTime: startTime)
        
        timer.invalidate()
        
        delegate.stopWatchPaused()
    }
    
    func restart() { // UNTESTED
        let newStartTime = NSDate.timeIntervalSinceReferenceDate - elapsedTimeBeforePause
        
        start(startTime: newStartTime)
        
        delegate.stopWatchRestarted()
    }
    
    func calculateTimeBetweenPointAndNow(intialTime: TimeInterval) -> TimeInterval { // UNTESTED
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        
        return initialTime - currentTime
    }
    
    func timeIntervalElapsed() { // UNTESTED
        let totalTimeElapsed = calculateTimeBetweenPointAndNow(initialTime: startTime)
        
        delegate.stopWatchIntervalElapsed(totalTimeElapsed: totalTimeElapsed)
    }
    
    func resetInitialState() { // UNTESTED
        startTime = nil
        timer = nil
        timerRunning = false
        elapsedTimeBeforePause = nil
    }
}
