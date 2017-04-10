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
        settingsTable.snp.makeConstraints { (make) in
            make.top.equalTo(settingsTable.superview!)
            make.width.equalTo(settingsTable.superview!)
            make.height.equalTo(settingsTable.superview!)
            make.left.equalTo(settingsTable.superview!)
        }
    }
}
