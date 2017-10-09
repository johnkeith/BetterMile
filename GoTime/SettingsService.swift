//
//  SettingsService.swift
//  GoTime
//
//  Created by John Keith on 4/9/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import Foundation

// TODO: UNTESTED
class SettingsService {
//    static let voiceNotificationsKey = "voiceNotifications"
    
    static let previousLapTimeKey = "previousLapTimeVoiceNotification"
    static let averageLapTimeKey = "averageLapTimeVoiceNotification"
//    static let totalTimeKey = "totalTimeVoiceNotification"
//    static let timerPausedKey = "timerPauseNotification"
//    static let timerClearedKey = "timerClearedNotification"
    
    static let milePaceKey = "milePaceVoiceNotification"
    static let intervalKey = "intervalVoiceNotification"
    
    static let vibrationNotificationsKey = "vibrationNotifications"
//    static let vibrateOnLapKey = "vibrateOnLapNotification"
//    static let vibrateOnPauseKey = "vibrateOnPauseNotification"
//    static let vibrateOnClearKey = "vibrateOnClearNotification"
    
    static func incrementAppRunCount() {
        let key = Constants.appRunTimes
        let currentValue = Constants.storedSettings.integer(forKey: key)
        let newValue = currentValue + 1
        
        Constants.storedSettings.set(newValue, forKey: key)
    }
    
    static func firstRunSetup() {
        let key = Constants.appRunTimes
        let currentValue = Constants.storedSettings.integer(forKey: key)

        if currentValue == 0 {
            Constants.storedSettings.set(true, forKey: previousLapTimeKey)
            Constants.storedSettings.set(true, forKey: averageLapTimeKey)
            Constants.storedSettings.set(true, forKey: vibrationNotificationsKey)
        }
    }
}
