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
    
    static let vibrationNotificationsKey = "vibrationNotifications"
    static let vibrateOnLapKey = "vibrateOnLapNotification"
    static let vibrateOnPauseKey = "vibrateOnPauseNotification"
    static let vibrateOnClearKey = "vibrateOnClearNotification"
    
    var mapOfSettingsForTable: [(displayName: String, userDefaultsKey: String)] = []
    
    init() {
        mapOfSettingsForTable = [
            (displayName: "Voice Notifications", userDefaultsKey: type(of: self).voiceNotificationsKey),
            (displayName: "Previous Lap Time", userDefaultsKey: type(of: self).previousLapTimeKey),
            (displayName: "Average Lap Time", userDefaultsKey: type(of: self).averageLapTimeKey),
            (displayName: "Total Time", userDefaultsKey: type(of: self).totalTimeKey),
            (displayName: "Vibration Notifications", userDefaultsKey: type(of: self).vibrationNotificationsKey),
            (displayName: "Vibrate on Lap", userDefaultsKey: type(of: self).vibrateOnLapKey),
            (displayName: "Vibrate on Pause", userDefaultsKey: type(of: self).vibrateOnPauseKey),
            (displayName: "Vibrate on Clear", userDefaultsKey: type(of: self).vibrateOnClearKey)
        ]
    }
}
