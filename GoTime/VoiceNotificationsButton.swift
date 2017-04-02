//
//  VoiceNotificationsButton.swift
//  GoTime
//
//  Created by John Keith on 3/26/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class VoiceNotificationsButton: SettingsButton {
    override var xMultiple: Double {
        get {
            return 1/8
        }
        set {}
    }
    
    override var yMultiple: Double {
        get {
            return 1/5
        }
        set {}
    }
}
