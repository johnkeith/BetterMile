//
//  StartButtonView.swift
//  GoTime
//
//  Created by John Keith on 1/21/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

protocol StartButtonDelegate: class {
    func onStartTap(sender: StartButton)
}

class StartButton: UIButton {
    var delegate: StartButtonDelegate!
    
    // this is the init for when no frame is passed - StartButton()
    init() {
        let defaultFrame = CGRect()
        super.init(frame: defaultFrame)
        
        sharedInit()
    }
    
    // this allows us to call StartButton(frame: ...) with a frame argument
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sharedInit()
    }
    
    // this allows us to create a StartButton through the Storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        sharedInit()
    }
    
    func sharedInit() { // UNTESTED        
        setTitle("START", for: UIControlState.normal)
        
        titleLabel?.font = Constants.responsiveDefaultFont
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.numberOfLines = 1
        titleLabel?.baselineAdjustment = .alignCenters
        titleLabel?.textAlignment = .center
        
        addTarget(self, action:#selector(onStartTap), for: .touchUpInside)
        
        setColoration()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotificationOfDarkModeFlipped), name: Notification.Name(rawValue: Constants.notificationOfDarkModeToggle), object: nil)
    }
    
    func onStartTap(sender: StartButton) {
        delegate.onStartTap(sender: sender)
    }
}

extension StartButton: RespondsToThemeChange {
    func handleNotificationOfDarkModeFlipped(notification: Notification) {
        let value = notification.userInfo?["value"] as! Bool
        
        setColoration(darkModeEnabled: value)
    }
    
    func setColoration(darkModeEnabled: Bool = Constants.storedSettings.bool(forKey: SettingsService.useDarkModeKey), animationDuration: Double = 0.0) {
        if darkModeEnabled {
            setTitleColor(Constants.colorPalette["white"], for: UIControlState.normal)
        } else {
            setTitleColor(Constants.colorPalette["black"], for: UIControlState.normal)
        }
    }
}
