//
//  TimeToTextService.swift
//  GoTime
//
//  Created by John Keith on 1/29/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import Foundation

class TimeToTextService {
    static let sharedInstance = TimeToTextService()
    private init() {}
    
    class func timeAsSingleString(inputTime: Double) -> String {
        let (strMinutes, strSeconds, strFraction) = timeAsMultipleStrings(inputTime: inputTime)
        
        return [strMinutes, strSeconds, strFraction].joined(separator: ":")
    }
    
    class func timeAsMultipleStrings(inputTime: Double) -> (minutes: String, seconds: String, fraction: String) {
        var elapsedTime = inputTime
        
        let minutes = UInt8(elapsedTime / 60.0)
        
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= TimeInterval(seconds)
        
        let fraction = UInt8(elapsedTime * 100)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        return (minutes: strMinutes, seconds: strSeconds, fraction: strFraction)
    }
}
