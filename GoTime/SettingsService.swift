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
    let storedSettings = Constants.storedSettings
    let voiceNotificationsKey = "voiceNotifications"
    let vibrationNotificationsKey = "vibrationNotificationsKey"
    
    var mapOfSettingsForTable: [(displayName: String, key: String, toggleFn: () -> ())] = []
    
    init() {
        mapOfSettingsForTable = [
            (displayName: "Voice Notifications", key: voiceNotificationsKey, toggleFn: toggleVoiceNotifications),
            (displayName: "Vibration Notifications", key: vibrationNotificationsKey, toggleFn: toggleVibrationNotifications)
        ]
    }
    
    func toggleVoiceNotifications() {
        let current = self.storedSettings.bool(forKey: voiceNotificationsKey)
        
        self.storedSettings.set(!current, forKey: voiceNotificationsKey)
    }
    
    func toggleVibrationNotifications() {
        
    }
}
