//
//  DividerLabel.swift
//  GoTime
//
//  Created by John Keith on 2/13/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class DividerLabel: UILabel {
    init(hidden: Bool = true) {
        let defaultFrame = CGRect()
        super.init(frame: defaultFrame)
        
        self.isHidden = hidden

        setColoration()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotificationOfDarkModeFlipped), name: Notification.Name(rawValue: Constants.notificationOfDarkModeToggle), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
}

extension DividerLabel: RespondsToThemeChange {
    func handleNotificationOfDarkModeFlipped(notification: Notification) {
        let value = notification.userInfo?["value"] as! Bool
        
        setColoration(darkModeEnabled: value)
    }
    
    func setColoration(darkModeEnabled: Bool = Constants.storedSettings.bool(forKey: SettingsService.useDarkModeKey), animationDuration: Double = 0.0) {
        if darkModeEnabled {
            self.backgroundColor = Constants.colorPalette["white"]
        } else {
            self.backgroundColor = Constants.colorPalette["black"]
        }
    }
}
