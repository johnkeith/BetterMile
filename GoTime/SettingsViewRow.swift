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
    let line = UILabel()
    let rowSwitch = UISwitch()
    
    var labelText: String
    var userDefaultsKey: String
    
    init(labelText: String, userDefaultsKey: String) {
        self.labelText = labelText
        self.userDefaultsKey = userDefaultsKey
        
        super.init(frame: Constants.defaultFrame)
        
        addLabel()
        addLine()
        addRowSwitch()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configConstraints() {
        label.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.height.equalTo(self)
            make.left.equalTo(self).offset(Constants.defaultMargin / 2)
            make.width.equalTo(self.frame.width * (2/5))
        }
        
        line.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.right.equalTo(self)
            make.top.equalTo(self.snp.bottom)
            make.width.equalTo(self)
        }
        
        rowSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-Constants.defaultMargin)
            make.width.equalTo(self.frame.width / 6)
        }
        
        label.layoutIfNeeded()
    }
    
    func matchFontSize(of: SettingsViewRow) {
        let size = of.label.fontSize
        label.adjustsFontSizeToFitWidth = false
        label.font = UIFont.systemFont(ofSize: size, weight: Constants.responsiveDefaultFontWeight)
    }
    
    @objc func onRowToggle() {
        let currentValue = Constants.storedSettings.bool(forKey: userDefaultsKey)
        
        Constants.storedSettings.set(!currentValue, forKey: userDefaultsKey)
    }
    
    private func addLabel() {
        addSubview(label)
        
        label.font = Constants.defaultHeadlineFont
        label.text = labelText
        label.textAlignment = .left
        
        label.textColor = Constants.colorBlack
    }
    
    private func addLine() {
        addSubview(line)
        
        line.backgroundColor = Constants.colorBlack
    }
    
    private func addRowSwitch() {
        addSubview(rowSwitch)
        
        rowSwitch.onTintColor = Constants.colorGreen
        
        let currentStoredValue = Constants.storedSettings.bool(forKey: userDefaultsKey)
        rowSwitch.isOn = currentStoredValue
        
        rowSwitch.addTarget(self, action: #selector(onRowToggle), for: UIControlEvents.allEvents)
    }
}
