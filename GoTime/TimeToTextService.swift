//
//  TimeToTextService.swift
//  GoTime
//
//  Created by John Keith on 1/29/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import Foundation

class TimeToTextService {
    func timeAsSingleString(inputTime: Double) -> String {
        let (strMinutes, strSeconds, strFraction) = timeAsMultipleStrings(inputTime: inputTime)
        
        return "\(strMinutes):\(strSeconds).\(strFraction)"
    }
    
    func timeAsMultipleStrings(inputTime: Double) -> (minutes: String, seconds: String, fraction: String) {
        var elapsedTime = inputTime
        
//        fatal error: Double value cannot be converted to UInt64 because it is either infinite or NaN
        // right here got an Inf. value for elapsedTime
        let minutes = UInt64(elapsedTime / 60.0)
        
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        let seconds = UInt64(elapsedTime)
        
        elapsedTime -= TimeInterval(seconds)
        
        let fraction = UInt64(elapsedTime * 100)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        return (minutes: strMinutes, seconds: strSeconds, fraction: strFraction)
    }
}
