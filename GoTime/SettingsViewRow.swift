//
//  SettingsViewRow.swift
//  GoTime
//
//  Created by John Keith on 9/10/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

protocol SettingsViewToggleDelegate: class {
    func onSettingsToggle(kind: SettingsViewRowKind, newValue: Bool)
}

enum SettingsViewRowKind {
    case vibration
    case previousLap
    case averageLap
    case milePace
    case intervalPing
}

class SettingsViewRow:UIView {
    let label = UILabel()
    let subLabel = UILabel()
    let line = UILabel()
    let rowSwitch = UISwitch()
    
    var labelText: String
    var userDefaultsKey: String
    var kind: SettingsViewRowKind
    var sublabelText: String?
    var incrementControl: IncrementControl?
    var settingsToggleDelegate: SettingsViewToggleDelegate?
    
    init(
        labelText: String,
        userDefaultsKey: String,
        kind: SettingsViewRowKind,
        sublabelText: String? = nil,
        incrementValue: Int? = nil,
        incrementLabel: String? = nil) {
        self.labelText = labelText
        self.userDefaultsKey = userDefaultsKey
        self.kind = kind
        
        super.init(frame: Constants.defaultFrame)

        addLabel()
        addLine()
        addRowSwitch()
        
        if sublabelText != nil {
            self.sublabelText = sublabelText
            addSublabel()
        }
        
        if incrementValue != nil && incrementLabel != nil { 
            self.incrementControl = IncrementControl(value: incrementValue!, labelText: incrementLabel!)
            addIncrementControl()
        }
        
        setVisibleBasedOnToggle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configConstraints() {
        setLabelConstraints()
        setRowSwitchConstraints()
        setSublabelConstraints()
        setIncrementControlConstraints()
        
        line.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.right.equalTo(self)
            make.bottom.equalTo(self.snp.bottom)
            make.width.equalTo(self)
        }
    }
    
    @objc func onRowToggle() {
        let currentValue = Constants.storedSettings.bool(forKey: userDefaultsKey)
        let nextValue = !currentValue
        
        Constants.storedSettings.set(nextValue, forKey: userDefaultsKey)
        
        resetConstraints(nextValue: nextValue)
        
        settingsToggleDelegate?.onSettingsToggle(kind: kind, newValue: nextValue)
    }
    
    func resetConstraints(nextValue: Bool) {
        if nextValue && incrementControl != nil {
            self.snp.updateConstraints { make in
                make.height.equalTo(superview!.frame.height / (Constants.tableRowHeightDivisor / 2))
            }
        } else {
            self.snp.updateConstraints { make in
                make.height.equalTo(superview!.frame.height / Constants.tableRowHeightDivisor)
            }
        }
        
        self.layoutIfNeeded()
        
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
    
    private func addLabel() {
        addSubview(label)
        
        label.text = labelText
        label.textAlignment = .left
        
        label.textColor = Constants.colorBlack
    }
    
    private func addSublabel() {
        addSubview(subLabel)
        
        subLabel.text = sublabelText
        subLabel.textAlignment = .left
        subLabel.textColor = Constants.colorBlack
    }
    
    private func addLine() {
        addSubview(line)
        
        line.backgroundColor = Constants.colorGray
    }
    
    private func addRowSwitch() {
        addSubview(rowSwitch)
        
        rowSwitch.onTintColor = Constants.colorGreen
        
        let currentStoredValue = Constants.storedSettings.bool(forKey: userDefaultsKey)
        rowSwitch.isOn = currentStoredValue
        
        rowSwitch.addTarget(self, action: #selector(onRowToggle), for: UIControlEvents.allEvents)
    }
    
    private func addIncrementControl() {
        addSubview(incrementControl!)
    }
}
