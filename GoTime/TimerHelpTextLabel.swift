//
//  TimerHelpTextLabel.swift
//  GoTime
//
//  Created by John Keith on 3/5/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

// TODO: UNTESTED
class TimerHelpTextLabel: UILabel {
    var animationService: AnimationService
    
    init(hidden: Bool = true, animationService: AnimationService = AnimationService()) {
        let defaultFrame = CGRect()
        
        self.animationService = animationService

        super.init(frame: defaultFrame)
        
        self.isHidden = hidden
        
        self.text = "Double tap to lap\nHold to pause"
        
        self.font = Constants.responsiveDefaultFont
        self.adjustsFontSizeToFitWidth = true
        self.numberOfLines = 2
        self.baselineAdjustment = .alignCenters
        self.textAlignment = .center
        
        setColoration()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotificationOfDarkModeFlipped), name: Notification.Name(rawValue: Constants.notificationOfDarkModeToggle), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    func showBriefly() {
        show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.animationService.animateFadeOutView(self, duration: 2.0)
        }
    }
}

extension TimerHelpTextLabel: RespondsToThemeChange {
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
