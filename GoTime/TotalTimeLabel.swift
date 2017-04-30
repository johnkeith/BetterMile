//
//  TotalTimeLabel.swift
//  GoTime
//
//  Created by John Keith on 2/5/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class TotalTimeLabel: UILabel {
    var memoizedText = "00:00.00"
    
    init(hidden: Bool = false) {
        let defaultFrame = CGRect()
        super.init(frame: defaultFrame)

        self.isHidden = hidden
        
        self.text = memoizedText
        
        self.font = Constants.responsiveDigitFont
        self.adjustsFontSizeToFitWidth = true
        self.numberOfLines = 1
        self.baselineAdjustment = .alignCenters
        self.textAlignment = .center
        
        setColoration()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotificationOfDarkModeFlipped), name: Notification.Name(rawValue: Constants.notificationOfDarkModeToggle), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    func setText(time: String) {
        memoizedText = time
        
        self.text = memoizedText
    }
}

extension TotalTimeLabel: RespondsToThemeChange {
    func handleNotificationOfDarkModeFlipped(notification: Notification) {
        let value = notification.userInfo?["value"] as! Bool
        
        setColoration(darkModeEnabled: value)
    }
    
    func setColoration(darkModeEnabled: Bool = Constants.storedSettings.bool(forKey: SettingsService.useDarkModeKey), animationDuration: Double = 0.0) {
        if darkModeEnabled {
            self.textColor = Constants.colorPalette["white"]
        } else {
            self.textColor = Constants.colorPalette["black"]
        }
    }
}

