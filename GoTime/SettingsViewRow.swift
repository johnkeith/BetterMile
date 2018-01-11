//
//  SettingsViewRow.swift
//  GoTime
//
//  Created by John Keith on 9/10/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

protocol SettingsViewToggleDelegate: class {
    func onSettingsToggle(_ this: SettingsViewRow, kind: SettingsViewRowKind, newValue: Bool)
}

enum SettingsViewRowKind {
    case vibration
    case previousLap
    case averageLap
    case milePace
    case intervalPing
    case startStop
    case viewMode
}

// TODO: UNTESTED
class SettingsViewRow:UIView {
    let label = UILabel()
    let subLabel = UILabel()
    let line = UILabel()
    let rowSwitch = UISwitch()
    
    var labelText: String
    var userDefaultsKey: String
    var kind: SettingsViewRowKind
    var hideLine: Bool
    var sublabelText: String?
    var incrementControl: IncrementControl?
    var settingsToggleDelegate: SettingsViewToggleDelegate?
    var incrementUserDefaultsKey: String?
    var toggleCallback: (() -> Void)?

    var fgColor: UIColor? {
        didSet {
            label.textColor = fgColor
            subLabel.textColor = fgColor
        }
    }
    var lineColor: UIColor? {
        didSet {
            line.backgroundColor = lineColor
        }
    }
    var switchColor: UIColor? {
        didSet {
            rowSwitch.onTintColor = switchColor
        }
    }
    
    var usesDarkMode: Bool = Constants.storedSettings.bool(forKey: SettingsService.darkModeKey) {
        didSet {
            self.setColorConstants()
            
            if incrementControl != nil {
                incrementControl!.refreshUsesDarkMode()
            }
        }
    }
    
    init(
        labelText: String,
        userDefaultsKey: String,
        kind: SettingsViewRowKind,
        sublabelText: String? = nil,
        incrementValue: Int? = nil,
        incrementLabel: String? = nil,
        incrementMin: Int? = nil,
        incrementUserDefaultsKey: String? = nil,
        toggleCallback: (() -> Void)? = {},
        hideLine: Bool = false) {
        self.labelText = labelText
        self.userDefaultsKey = userDefaultsKey
        self.kind = kind
        self.incrementUserDefaultsKey = incrementUserDefaultsKey
        self.toggleCallback = toggleCallback
        self.hideLine = hideLine
        
        super.init(frame: Constants.defaultFrame)

        setColorConstants()
        
        addLabel()
        
        if(!hideLine) {
            addLine()
        }
        
        addRowSwitch()
        
        if sublabelText != nil {
            self.sublabelText = sublabelText
            addSublabel()
        }
        
        if incrementValue != nil && incrementLabel != nil && incrementMin != nil {
            self.incrementControl = IncrementControl(value: incrementValue!, labelText: incrementLabel!, minValue: incrementMin!)
            
            incrementControl!.delegate = self
            
            addIncrementControl()
        }
        
        setVisibleBasedOnToggle()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshUsesDarkMode), name: Notification.Name(rawValue: Constants.notificationOfDarkModeToggle), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configConstraints() {
        setLabelConstraints()
        setRowSwitchConstraints()
        setSublabelConstraints()
        setIncrementControlConstraints()
        setLineConstraints()
    }
    
    @objc func onRowToggle() {
        let currentValue = Constants.storedSettings.bool(forKey: userDefaultsKey)
        let nextValue = !currentValue
        
        Constants.storedSettings.set(nextValue, forKey: userDefaultsKey)

        settingsToggleDelegate?.onSettingsToggle(self, kind: kind, newValue: nextValue)

        resetConstraints(nextValue: nextValue)
        
        if toggleCallback != nil {
            toggleCallback?()
        }
    }
    
    func resetConstraints(nextValue: Bool) {
        setLabelConstraints()
        setRowSwitchConstraints()
        setSublabelConstraints()
        setIncrementControlConstraints()
        setVisibleBasedOnToggle()
    }
    
    func settingIsEnabled() -> Bool {
        return Constants.storedSettings.bool(forKey: userDefaultsKey)
    }
    
    func setToDisabled() {
        rowSwitch.setOn(false, animated: true)
        
        Constants.storedSettings.set(false, forKey: userDefaultsKey)
        
        resetConstraints(nextValue: false)
    }
    
    func setToEnabled() {
        rowSwitch.setOn(true, animated: true)
        
        Constants.storedSettings.set(true, forKey: userDefaultsKey)
        
        resetConstraints(nextValue: true)
    }
    
    func setVisibleBasedOnToggle() {
        if sublabelText != nil && incrementControl != nil {
            subLabel.isHidden = !settingIsEnabled()
            incrementControl!.isHidden = !settingIsEnabled()
        }
    }
    
    @objc func refreshUsesDarkMode() {
        usesDarkMode = Constants.storedSettings.bool(forKey: SettingsService.darkModeKey)
    }
    
    private func setColorConstants() {
        fgColor = usesDarkMode ? Constants.colorWhite : Constants.colorBlack
        lineColor = usesDarkMode ? Constants.colorDarkModeBorderGray : Constants.colorGray
        switchColor = Constants.colorGreen
    }
    
    private func setLabelConstraints() {
        label.snp.remakeConstraints { make in
            if(settingIsEnabled() && incrementControl != nil) {
                make.height.equalTo(self.frame.height / 2)
            } else {
                make.height.equalTo(self)
            }
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.width.equalTo(self.frame.width * (2/3))
        }
    }
    
    private func setRowSwitchConstraints() {
        rowSwitch.snp.remakeConstraints { make in
            make.centerY.equalTo(label)
            make.right.equalTo(self).offset(-Constants.defaultMargin / 2)
            make.width.equalTo(self.frame.width / 6)
        }
    }
    
    private func setSublabelConstraints() {
        if sublabelText != nil {
            subLabel.snp.remakeConstraints { make in
                make.bottom.equalTo(self).offset(-4)
                make.height.equalTo(self.frame.height / 2)
                make.left.equalTo(self)
                make.width.equalTo(self.frame.width * (2/5))
            }
        }
    }
    
    private func setIncrementControlConstraints() {
        if incrementControl != nil {
            incrementControl!.snp.remakeConstraints { make in
                make.bottom.equalTo(self).offset(-4)
                make.height.equalTo(label)
                make.right.equalTo(self).offset(-Constants.defaultMargin / 2)
                make.width.equalTo(self.frame.width * (3/5))
            }
            
            incrementControl!.layoutIfNeeded()
        }
    }
    
    private func setLineConstraints() {
        if(!hideLine) {
            line.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.right.equalTo(self)
                make.bottom.equalTo(self.snp.bottom)
                make.width.equalTo(self)
            }
        }
    }
    
    private func addLabel() {
        addSubview(label)
        
        label.text = labelText
        label.textAlignment = .left
    }
    
    private func addSublabel() {
        addSubview(subLabel)
        
        subLabel.text = sublabelText
        subLabel.textAlignment = .left
    }
    
    private func addLine() {
        addSubview(line)
    }
    
    private func addRowSwitch() {
        addSubview(rowSwitch)
        
        let currentStoredValue = Constants.storedSettings.bool(forKey: userDefaultsKey)
        rowSwitch.isOn = currentStoredValue
        
        rowSwitch.addTarget(self, action: #selector(onRowToggle), for: UIControlEvents.allEvents)
    }
    
    private func addIncrementControl() {
        addSubview(incrementControl!)
    }
}

extension SettingsViewRow: IncrementControlDelegate {
    func onIncrementChangeHandler(newValue: Int) {
        Constants.storedSettings.set(newValue, forKey: incrementUserDefaultsKey!)
    }
}
