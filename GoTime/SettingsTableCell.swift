//
//  SettingsTableCell.swift
//  GoTime
//
//  Created by John Keith on 4/9/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

// TODO: UNTESTED
class SettingsTableCell: UITableViewCell {
    let label = UILabel(frame: CGRect())
    let toggleSwitch = UISwitch(frame: CGRect())
    var userDefaultsKey: String?
    
    override init(style: UITableViewCellStyle = .default, reuseIdentifier: String? = "SettingsTableCell") {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        self.contentView.addSubview(label)
        self.contentView.addSubview(toggleSwitch)
        
        let currentFontSize = label.font.pointSize
        label.font = UIFont.systemFont(ofSize: currentFontSize, weight: UIFontWeightThin)
        
        toggleSwitch.addTarget(self, action:#selector(saveToggleState), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotificationOfSave), name: Notification.Name(rawValue: Constants.notificationOfSettingsToggle), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotificationOfSubToggleFlipped), name: Notification.Name(rawValue: Constants.notificationOfSubSettingsToggle), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContent(displayName: String) {
        label.text = displayName
    }
    
    func setToggleState() {
        let state = Constants.storedSettings.bool(forKey: self.userDefaultsKey!)
        
        self.toggleSwitch.setOn(state, animated: false)
    }
    
    func saveToggleState() {
        Constants.storedSettings.set(self.toggleSwitch.isOn, forKey: self.userDefaultsKey!)
        
        if [SettingsService.voiceNotificationsKey, SettingsService.vibrationNotificationsKey].contains(self.userDefaultsKey!) {
            broadcastSettingWasSaved()
        } else if SettingsService.voiceNotificationOptionKeys.contains(self.userDefaultsKey!) ||
            SettingsService.vibrationNotificationOptionKeys.contains(self.userDefaultsKey!) {
            broadcastSubToggleFlipped()
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
    
    func broadcastSubToggleFlipped() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notificationOfSubSettingsToggle),
            object: nil,
            userInfo: ["toggledUserDefaultsKey":userDefaultsKey!])
    }
    
    func handleNotificationOfSubToggleFlipped(notification: Notification) {
        let toggledUserDefaultsKey = notification.userInfo?["toggledUserDefaultsKey"] as! String
        
        if userDefaultsKey! == SettingsService.voiceNotificationsKey &&
            SettingsService.voiceNotificationOptionKeys.contains(toggledUserDefaultsKey) {
            setToggleSwitchAndUserDefaults(toggleState: true)
        }
        
        if userDefaultsKey! == SettingsService.vibrationNotificationsKey &&
            SettingsService.vibrationNotificationOptionKeys.contains(toggledUserDefaultsKey) {
            setToggleSwitchAndUserDefaults(toggleState: true)
        }
    }
    
    func setToggleSwitchAndUserDefaults(toggleState: Bool) {
        self.toggleSwitch.setOn(toggleState, animated: true)
        Constants.storedSettings.set(toggleState, forKey: self.userDefaultsKey!)
    }
    
    func addConstraints(leftInset: CGFloat) {
        label.snp.makeConstraints { (make) in
            make.height.equalTo(self.frame.size.height)
            make.width.equalTo(self.frame.size.width - self.toggleSwitch.frame.size.width)
            make.left.equalTo(leftInset)
        }
        
        toggleSwitch.snp.makeConstraints { (make) in
            make.top.equalTo(toggleSwitch.superview!).offset((self.frame.size.height - toggleSwitch.frame.size.height) / 2)
            make.right.equalTo(toggleSwitch.superview!).offset(-leftInset / 2)
        }
    }
}

