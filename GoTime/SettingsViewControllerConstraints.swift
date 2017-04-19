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
            make.width.equalTo(settingsTable.superview!).offset(-(defaultMargin * 2))
            make.top.equalTo(settingsTable.superview!).offset(defaultMargin * 2)
            make.left.equalTo(settingsTable.superview!).offset(defaultMargin)
            make.bottom.equalTo(settingsTable.superview!).offset(-(defaultMargin * 2))
        }
        
        settingsTable.layoutIfNeeded()
        
        settingsTable.contentInset = UIEdgeInsetsMake(0.0, 0.0, settingsTable.frame.height - Constants.lapTimeTableCellHeight, 0.0)
    }
    
    class func positionTopDividerLabel(dividerLabel: DividerLabel) {
        dividerLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(dividerLabel.superview!).offset(-(defaultMargin * 2))
            make.height.equalTo(1)
            make.left.equalTo(dividerLabel.superview!).offset(defaultMargin)
            make.top.equalTo(dividerLabel.superview!).offset(defaultMargin * 2)
        }
    }
    
    class func positionBottomDividerLabel(dividerLabel: DividerLabel) {
        dividerLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(dividerLabel.superview!).offset(-(defaultMargin * 2))
            make.height.equalTo(1)
            make.left.equalTo(dividerLabel.superview!).offset(defaultMargin)
            make.bottom.equalTo(dividerLabel.superview!).offset(-(defaultMargin * 2))
        }
    }
}
