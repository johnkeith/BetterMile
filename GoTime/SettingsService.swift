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
    static let voiceNotificationsKey = "voiceNotifications"
    static let previousLapTimeKey = "previousLapTimeVoiceNotification"
    static let averageLapTimeKey = "averageLapTimeVoiceNotification"
    static let totalTimeKey = "totalTimeVoiceNotification"
    static let voiceNotificationOptionKeys = [previousLapTimeKey, averageLapTimeKey, totalTimeKey]
    
    static let vibrationNotificationsKey = "vibrationNotifications"
    static let vibrateOnLapKey = "vibrateOnLapNotification"
    static let vibrateOnPauseKey = "vibrateOnPauseNotification"
    static let vibrateOnClearKey = "vibrateOnClearNotification"
    static let vibrationNotificationOptionKeys = [vibrateOnLapKey, vibrateOnPauseKey, vibrateOnClearKey]
    
    static let showLapNumber = "showLapNumber"
    static let showCurrentLapTime = "showCurrentLapTime"
    static let showAverageLapTime = "showAverageLapTime"
    static let showBestLapTime = "showBestLapTime"
    
    static let useDarkMode = "useDarkMode"
    
    var mapOfSettingsForTable: [(displayName: String, userDefaultsKey: String?, shouldIndent: Bool)] = []
    
    init() {
        mapOfSettingsForTable = [
            (displayName: "Notification Settings", userDefaultsKey: nil, shouldIndent: false),
            (displayName: "Voice Notifications", userDefaultsKey: type(of: self).voiceNotificationsKey, shouldIndent: false),
            (displayName: "Previous Lap Time", userDefaultsKey: type(of: self).previousLapTimeKey, shouldIndent: true),
            (displayName: "Average Lap Time", userDefaultsKey: type(of: self).averageLapTimeKey, shouldIndent: true),
            (displayName: "Total Time", userDefaultsKey: type(of: self).totalTimeKey, shouldIndent: true),
            (displayName: "Vibration Notifications", userDefaultsKey: type(of: self).vibrationNotificationsKey, shouldIndent: false),
            (displayName: "Vibrate on Lap", userDefaultsKey: type(of: self).vibrateOnLapKey, shouldIndent: true),
            (displayName: "Vibrate on Pause", userDefaultsKey: type(of: self).vibrateOnPauseKey, shouldIndent: true),
            (displayName: "Vibrate on Clear", userDefaultsKey: type(of: self).vibrateOnClearKey, shouldIndent: true),
            (displayName: "Dashboard Settings", userDefaultsKey: nil, shouldIndent: false),
            (displayName: "Show Lap Number", userDefaultsKey: type(of: self).showLapNumber, shouldIndent: false),
            (displayName: "Show Current Lap Time", userDefaultsKey: type(of: self).showCurrentLapTime, shouldIndent: false),
            (displayName: "Show Average Lap Time", userDefaultsKey: type(of: self).showAverageLapTime, shouldIndent: false),
            (displayName: "Show Best Lap Time", userDefaultsKey: type(of: self).showBestLapTime, shouldIndent: false),
            (displayName: "Color Settings", userDefaultsKey: nil, shouldIndent: false),
            (displayName: "Dark Mode", userDefaultsKey: type(of: self).useDarkMode, shouldIndent: false)
        ]
    }
}
