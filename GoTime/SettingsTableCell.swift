//
//  SettingsTableCell.swift
//  GoTime
//
//  Created by John Keith on 4/9/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

protocol RespondsToThemeChange {
    func handleNotificationOfDarkModeFlipped(notification: Notification)
    
    func setColoration(darkModeEnabled: Bool, animationDuration: Double)
}

// TODO: UNTESTED
class SettingsTableCell: UITableViewCell, RespondsToThemeChange {
    let label = UILabel(frame: CGRect())
    let toggleSwitch = UISwitch(frame: CGRect())
    let line = UILabel(frame: CGRect())
    
    var userDefaultsKey: String? {
        didSet {
            let useDarkMode = Constants.storedSettings.bool(forKey: SettingsService.useDarkModeKey)
            
            if self.userDefaultsKey != nil {
                self.toggleSwitch.isHidden = false
                
                setColoration(darkModeEnabled: useDarkMode)
            } else {
                self.toggleSwitch.isHidden = true
                
                setColoration(darkModeEnabled: !useDarkMode)
            }
        }
    }
    var shouldIndent = false
    
    override init(style: UITableViewCellStyle = .default, reuseIdentifier: String? = "SettingsTableCell") {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        self.contentView.addSubview(label)
        self.contentView.addSubview(toggleSwitch)
        self.contentView.addSubview(line)
        
        let currentFontSize = label.font.pointSize
        label.font = UIFont.systemFont(ofSize: currentFontSize, weight: UIFontWeightThin)
        
        toggleSwitch.isHidden = true
        toggleSwitch.addTarget(self, action:#selector(saveToggleState), for: .touchUpInside)
        
        setColoration()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotificationOfSave), name: Notification.Name(rawValue: Constants.notificationOfSettingsToggle), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotificationOfSubToggleFlipped), name: Notification.Name(rawValue: Constants.notificationOfSubSettingsToggle), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotificationOfDarkModeFlipped), name: Notification.Name(rawValue: Constants.notificationOfDarkModeToggle), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContent(displayName: String) {
        label.text = displayName
    }
    
    func setColoration(darkModeEnabled: Bool = Constants.storedSettings.bool(forKey: SettingsService.useDarkModeKey), animationDuration: Double = 0.0) {
        UIView.animate(withDuration: animationDuration, animations: {
            if darkModeEnabled {
                self.backgroundColor = Constants.colorPalette["black"]
                self.label.textColor = Constants.colorPalette["white"]
                self.line.backgroundColor = Constants.colorPalette["white"]
                self.toggleSwitch.onTintColor = Constants.colorPalette["white"]
            } else {
                self.backgroundColor = Constants.colorPalette["white"]
                self.label.textColor = Constants.colorPalette["black"]
                self.line.backgroundColor = Constants.colorPalette["black"]
                self.toggleSwitch.onTintColor = Constants.colorPalette["black"]
            }
        })
    }

    func setToggleState() {
        if userDefaultsKey != nil {
            let state = Constants.storedSettings.bool(forKey: self.userDefaultsKey!)
            self.toggleSwitch.setOn(state, animated: false)
        }
    }
    
    func saveToggleState() {
        Constants.storedSettings.set(self.toggleSwitch.isOn, forKey: self.userDefaultsKey!)
        
        if [SettingsService.voiceNotificationsKey, SettingsService.vibrationNotificationsKey].contains(self.userDefaultsKey!) {
            broadcastSettingWasSaved()
        } else if SettingsService.voiceNotificationOptionKeys.contains(self.userDefaultsKey!) ||
            SettingsService.vibrationNotificationOptionKeys.contains(self.userDefaultsKey!) {
            broadcastSubToggleFlipped()
        } else if SettingsService.useDarkModeKey == self.userDefaultsKey! {
            broadcastDarkModeFlipped()
        }
    }
    
    func broadcastSettingWasSaved() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notificationOfSettingsToggle),
            object: nil,
            userInfo: ["toggledUserDefaultsKey":userDefaultsKey!,"toggleState":self.toggleSwitch.isOn])
    }
    
    func handleNotificationOfSave(notification: Notification) {
        let toggledUserDefaultsKey = notification.userInfo?["toggledUserDefaultsKey"] as! String
        let toggleState = notification.userInfo?["toggleState"] as! Bool
        
        if userDefaultsKey != nil {
            if toggledUserDefaultsKey == SettingsService.voiceNotificationsKey {
                if SettingsService.voiceNotificationOptionKeys.contains(userDefaultsKey!) {
                    setToggleSwitchAndUserDefaults(toggleState: toggleState)
                }
            }
            
            if toggledUserDefaultsKey == SettingsService.vibrationNotificationsKey {
                if SettingsService.vibrationNotificationOptionKeys.contains(userDefaultsKey!) {
                    setToggleSwitchAndUserDefaults(toggleState: toggleState)
                }
            }
        }
    }
    
    func broadcastSubToggleFlipped() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notificationOfSubSettingsToggle),
                                        object: nil,
                                        userInfo: ["toggledUserDefaultsKey":userDefaultsKey!])
    }
    
    func handleNotificationOfSubToggleFlipped(notification: Notification) {
        let toggledUserDefaultsKey = notification.userInfo?["toggledUserDefaultsKey"] as! String
        
        if userDefaultsKey != nil {
            if userDefaultsKey! == SettingsService.voiceNotificationsKey {
                if SettingsService.voiceNotificationOptionKeys.contains(toggledUserDefaultsKey) {
                    setToggleSwitchAndUserDefaults(toggleState: true)
                }
                
                toggleVoiceNotificationsKeyIfAllSubsToggled()
            }
            
            if userDefaultsKey! == SettingsService.vibrationNotificationsKey {
                if SettingsService.vibrationNotificationOptionKeys.contains(toggledUserDefaultsKey) {
                    setToggleSwitchAndUserDefaults(toggleState: true)
                }
                
                toggleVibrationNotificationsKeyIfAllSubsToggled()
            }
        }
    }
    
    func broadcastDarkModeFlipped() {
        //      Waiting a few moments to handle for switch animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notificationOfDarkModeToggle), object: nil, userInfo: ["value":self.toggleSwitch.isOn])
        }
    }
    
    func handleNotificationOfDarkModeFlipped(notification: Notification) {
        let value = notification.userInfo?["value"] as! Bool
        
        if self.userDefaultsKey != nil {
            self.setColoration(darkModeEnabled: value, animationDuration: 0.2)
        } else {
            self.setColoration(darkModeEnabled: !value, animationDuration: 0.2)
        }
    }
    
    func setToggleSwitchAndUserDefaults(toggleState: Bool) {
        self.toggleSwitch.setOn(toggleState, animated: true)
        Constants.storedSettings.set(toggleState, forKey: self.userDefaultsKey!)
    }
    
    func toggleVoiceNotificationsKeyIfAllSubsToggled() {
        var allSubsToggled = true
        
        SettingsService.voiceNotificationOptionKeys.forEach { key in
            if Constants.storedSettings.bool(forKey: key) {
                allSubsToggled = false
            }
        }
        
        if allSubsToggled {
            setToggleSwitchAndUserDefaults(toggleState: false)
        }
    }
    
    func toggleVibrationNotificationsKeyIfAllSubsToggled() {
        var allSubsToggled = true
        
        SettingsService.vibrationNotificationOptionKeys.forEach { key in
            if Constants.storedSettings.bool(forKey: key) {
                allSubsToggled = false
            }
        }
        
        if allSubsToggled {
            setToggleSwitchAndUserDefaults(toggleState: false)
        }
    }
    
    func addConstraints() {
        var indent: Int {
            if self.shouldIndent {
                return Constants.defaultMargin * 2
            } else {
                return Constants.defaultMargin / 2
            }
        }
        
        label.snp.remakeConstraints { (make) in
            make.centerY.equalTo(label.superview!)
            make.left.equalTo(label.superview!).offset(indent)
        }
        
        toggleSwitch.snp.remakeConstraints { (make) in
            make.centerY.equalTo(toggleSwitch.superview!)
            make.right.equalTo(toggleSwitch.superview!).offset(-(toggleSwitch.frame.width / 12))
        }
        
        line.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(line.superview!)
            make.height.equalTo(1)
            
            if self.shouldIndent {
                make.left.equalTo(line.superview!).offset(indent)
            }
        }
    }
}

