//
//  SettingsViewControllerConstraints.swift
//  GoTime
//
//  Created by John Keith on 4/9/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit
import SnapKit

class SettingsViewControllerConstraints {
    static let sharedInstance = SettingsViewControllerConstraints()
    
    private init() {}
    
    private static let defaultMargin = Constants.defaultMargin
    
    class func positionSettingsTable(settingsTable: SettingsTable) {
        settingsTable.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(settingsTable.superview!)
            make.top.equalTo(settingsTable.superview!).offset(defaultMargin * 2)
            make.bottom.equalTo(settingsTable.superview!).offset(-(defaultMargin * 2))
        }
        
        settingsTable.layoutIfNeeded()
    }
    
    class func positionTopDividerLabel(dividerLabel: DividerLabel) {
        dividerLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(dividerLabel.superview!)
            make.height.equalTo(1)
            make.top.equalTo(dividerLabel.superview!).offset(defaultMargin * 2)
        }
    }
    
    class func positionBottomDividerLabel(dividerLabel: DividerLabel) {
        dividerLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(dividerLabel.superview!)
            make.height.equalTo(1)
            make.bottom.equalTo(dividerLabel.superview!).offset(-(defaultMargin * 2))
        }
    }
}
