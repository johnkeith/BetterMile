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
    
    init(labelText: String, sublabelText: String, userDefaultsKey: String) {
        self.labelText = labelText
        self.userDefaultsKey = userDefaultsKey
        self.sublabelText = sublabelText
        
        super.init(frame: Constants.defaultFrame)
        
        addLabel()
        addSublabel()
        addLine()
        addRowSwitch()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configConstraints() {
        setRowSwitchConstraints()
                
        label.snp.makeConstraints { make in
            make.centerY.equalTo(rowSwitch)
            make.height.lessThanOrEqualToSuperview()
            make.left.equalTo(self).offset(Constants.defaultMargin / 2)
            make.width.equalTo(self.frame.width * (5/6))
        }
        
        subLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-Constants.defaultMargin)
            make.height.lessThanOrEqualToSuperview()
            make.left.equalTo(self).offset(Constants.defaultMargin / 2)
            make.width.equalTo(self.frame.width * (5/6))
        }
        
        line.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.right.equalTo(self)
            make.top.equalTo(self.snp.bottom)
            make.width.equalTo(self)
        }

        
        label.layoutIfNeeded()
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
        
        setRowSwitchConstraints()
        setSublabelVisibleBasedOnToggle()
    }
    
    func settingIsEnabled() -> Bool {
        return Constants.storedSettings.bool(forKey: userDefaultsKey)
    }
    
    func setSublabelVisibleBasedOnToggle() {
        subLabel.isHidden = !settingIsEnabled()
    }
    
    private func setRowSwitchConstraints() {
        rowSwitch.snp.remakeConstraints { make in
            if(settingIsEnabled()) {
                make.top.equalTo(self).offset(Constants.defaultMargin)
            } else {
                make.centerY.equalTo(self)
            }
            make.right.equalTo(self).offset(-Constants.defaultMargin)
            make.width.equalTo(self.frame.width / 6)
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
        
        setSublabelVisibleBasedOnToggle()
        
        label.textColor = Constants.colorBlack
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
}
