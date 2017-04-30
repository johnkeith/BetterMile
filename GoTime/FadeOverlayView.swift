//
//  FadeOverlayView.swift
//  GoTime
//
//  Created by John Keith on 3/22/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

// TODO: UNTESTED
class FadeOverlayView: UIView {
    let gradientLayer = CAGradientLayer()
    
    init(hidden: Bool = false) {
        super.init(frame: Constants.defaultFrame)
        
        self.isHidden = hidden
        self.isUserInteractionEnabled = false

        setColoration()
        
        gradientLayer.locations = [0.0, 1.0]
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotificationOfDarkModeFlipped), name: Notification.Name(rawValue: Constants.notificationOfDarkModeToggle), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
}

extension FadeOverlayView: RespondsToThemeChange {
    func handleNotificationOfDarkModeFlipped(notification: Notification) {
        let value = notification.userInfo?["value"] as! Bool
        
        setColoration(darkModeEnabled: value)
    }
    
    func setColoration(darkModeEnabled: Bool = Constants.storedSettings.bool(forKey: SettingsService.useDarkModeKey), animationDuration: Double = 0.0) {
        var firstColor: CGColor
        var secondColor: CGColor
        
        if darkModeEnabled {
            firstColor = UIColor(white: 0, alpha: 0).cgColor
            secondColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
        } else {
            firstColor = UIColor(white: 1, alpha: 0).cgColor
            secondColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6).cgColor
        }

        self.gradientLayer.colors = [firstColor, secondColor]
    }
}
