//
//  SettingsViewRow.swift
//  GoTime
//
//  Created by John Keith on 9/10/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class SettingsViewRow:UIView {
    let label = UILabel()
    let subLabel = UILabel()
    let line = UILabel()
    let rowSwitch = UISwitch()
    
    var labelText: String
    var userDefaultsKey: String
    var sublabelText: String
    var incrementControl: IncrementControl
    
    init(
        labelText: String,
        sublabelText: String,
        userDefaultsKey: String,
        incrementValue: Int,
        incrementLabel: String) {
        self.labelText = labelText
        self.userDefaultsKey = userDefaultsKey
        self.sublabelText = sublabelText
        self.incrementControl = IncrementControl(value: incrementValue, labelText: incrementLabel)
        
        super.init(frame: Constants.defaultFrame)
        
        addLabel()
        addSublabel()
        addIncrementControl()
        addLine()
        addRowSwitch()
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
        
        if nextValue {
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
    
    func setVisibleBasedOnToggle() {
        subLabel.isHidden = !settingIsEnabled()
        incrementControl.isHidden = !settingIsEnabled()
    }
    
    private func setLabelConstraints() {
        label.snp.remakeConstraints { make in
            if(settingIsEnabled()) {
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
        subLabel.snp.remakeConstraints { make in
            make.bottom.equalTo(self).offset(-4)
            make.height.equalTo(self.frame.height / 2)
            make.left.equalTo(self)
            make.width.equalTo(self.frame.width * (2/5))
        }
    }
    
    private func setIncrementControlConstraints() {
        incrementControl.snp.remakeConstraints { make in
            make.bottom.equalTo(self).offset(-4)
            make.height.equalTo(label)
            make.right.equalTo(self).offset(-Constants.defaultMargin / 2)
            make.width.equalTo(self.frame.width * (3/5))
        }
        
        incrementControl.layoutIfNeeded()
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
        
        setVisibleBasedOnToggle()
        
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
        addSubview(incrementControl)
    }
}
