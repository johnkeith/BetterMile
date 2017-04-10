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
    let storedSettings = UserDefaults.standard
    var mapOfSettingsForTable: [(displayName: String, toggleFn: () -> ())] = []
    
    init() {
        mapOfSettingsForTable = [
            (displayName: "Voice Notifications", toggleFn: toggleVoiceNotifications),
            (displayName: "Vibration Notifications", toggleFn: toggleVibrationNotifications)
        ]
    }
    
    func toggleVoiceNotifications() {
        let key = "voiceNotifications"
        let current = self.storedSettings.bool(forKey: key)
        
        self.storedSettings.set(!current, forKey: key)
    }
    
    func toggleVibrationNotifications() {
        
    }
}
