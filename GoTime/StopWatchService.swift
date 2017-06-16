//
//  TimerService.swift
//  GoTime
//
//  Created by John Keith on 1/27/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

enum LapQualities {
    case good
    case bad
    case ugly
}

protocol StopWatchServiceDelegate: class {
    func stopWatchIntervalElapsed(totalTimeElapsed: TimeInterval)
    
    func stopWatchStopped()
    
    func stopWatchPaused()
    
    func stopWatchRestarted()
    
    func stopWatchLapStored(lapTime: Double, lapNumber: Int, totalTime: Double)
    
    func stopWatchStarted()
}

class StopWatchService: NSObject {
    weak var delegate: StopWatchServiceDelegate?
    
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

        timerRunning = true
    
        if(!restart) {
            lapTimes.append(0.0)
            delegate?.stopWatchStarted()
        }
    }
    
    func timeIntervalElapsed() {
        lapTimes[lapTimes.endIndex - 1] = calculateTimeBetweenPointAndNow(initialTime: startTime)
        let totalTimeElapsed = calculateTotalLapsTime(_lapTimes: lapTimes)

        delegate?.stopWatchIntervalElapsed(totalTimeElapsed: totalTimeElapsed)
    }
    
    func calculateTotalLapsTime(_lapTimes: [Double]) -> Double {
        return _lapTimes.map{$0}.reduce(0, +)
    }
    
//  This can only be used when calculating right after adding a 0 lap
//  which would occur after hitting the lpa button
    func calculateAverageLapTime() -> Double {
        let totalLapTime = calculateTotalLapsTime(_lapTimes: self.lapTimes)
        
        return totalLapTime / Double(lapTimes.count - 1)
    }
    
    func calculateStandardDeviation() -> Double {
        let meanLapTime = calculateMeanLapTime()
        
        let sumOfLaps = self.lapTimes.reduce(0.0, { acc, time in
            let s = (time - meanLapTime)
            return acc + s * s
        })
        
        let result = sumOfLaps / Double(lapTimes.count)

        return result.squareRoot()
    }
    
    func determineLapQuality(lapTime: Double) -> LapQualities {
        let currentStandardDeviation = calculateStandardDeviation()
        let currentAverageLapTime = calculateMeanLapTime()
        
        if (lapTime <= currentAverageLapTime) {
            return LapQualities.good
        } else if (lapTime <= currentStandardDeviation + currentAverageLapTime) {
            return LapQualities.bad
        } else {
            return LapQualities.ugly
        }
    }
    
    func calculateMeanLapTime() -> Double {
        let totalLapTime = calculateTotalLapsTime(_lapTimes: self.lapTimes)
        
        return totalLapTime / Double(lapTimes.count)
    }
    
    func calculateTimeBetweenPointAndNow(initialTime: TimeInterval) -> TimeInterval {
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        
        return currentTime - initialTime
    }
    
    func stop() {
        if(timer != nil) {
            timer.invalidate()
        }

        RunPersistanceService(_lapTimes: self.lapTimes).save()

        resetInitialState()
        
        delegate?.stopWatchStopped()
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
    }
    
    func restart() {
        let newStartTime = NSDate.timeIntervalSinceReferenceDate - elapsedTimeBeforePause
        
        elapsedTimeBeforePause = 0.0
        
        start(initialTime: newStartTime, restart: true)
        
        delegate?.stopWatchRestarted()
    }
    
    func lap() {
        timer.invalidate()

        start()
    
        let currentTotalTime = calculateTotalLapsTime(_lapTimes: lapTimes)
        let lapNumber = lapTimes.count - 1
        let lapTime = lapTimes[lapTimes.count - 2]
                
        delegate?.stopWatchLapStored(lapTime: lapTime, lapNumber: lapNumber, totalTime: currentTotalTime)
    }
}

// MARK: CLASS FUNCTIONS
extension StopWatchService {
    class func findFastestLapIndex(_ laps: [Double]) -> Int? {
        let min = laps.min()
        
        if (min != nil) {
            return laps.index(of: min!)
        } else {
            return nil
        }
    }
    
    class func findSlowestLapIndex(_ laps: [Double]) -> Int? {
        let max = laps.max()
        
        if (max != nil) {
            return laps.index(of: max!)
        } else {
            return nil
        }
    }
}
