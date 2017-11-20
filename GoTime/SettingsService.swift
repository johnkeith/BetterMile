//
//  SettingsService.swift
//  GoTime
//
//  Created by John Keith on 4/9/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import Foundation

class SettingsService {
    static let previousLapTimeKey = "previousLapTimeVoiceNotification"
    static let averageLapTimeKey = "averageLapTimeVoiceNotification"
    
    static let milePaceKey = "milePaceVoiceNotification"
    static let intervalKey = "intervalVoiceNotification"
    static let milePaceAmountKey = "milePaceAmount"
    static let intervalAmountKey = "intervalAmount"
    
    static let vibrationNotificationsKey = "vibrationNotifications"
    
    static let speakStartStopKey = "startStopNotification"
    
    static let darkModeKey = "darkMode"
    
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
            resetToDefaultSettings()
        }
    }
    
    static func resetToDefaultSettings() {
        Constants.storedSettings.set(true, forKey: previousLapTimeKey)
        Constants.storedSettings.set(true, forKey: averageLapTimeKey)
        Constants.storedSettings.set(true, forKey: vibrationNotificationsKey)
        Constants.storedSettings.set(12, forKey: milePaceAmountKey)
        Constants.storedSettings.set(15, forKey: intervalAmountKey)
    }
}
