//
//  AverageLapTimeButton.swift
//  GoTime
//
//  Created by John Keith on 3/26/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class AverageLapTimeButton: SettingsButton {
    override var xMultiple: Double {
        get {
            return 1/4
        }
        set {}
    }
    
    override var yMultiple: Double {
        get {
            return 2/5
        }
        set {}
    }
}
