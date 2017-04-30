//
//  SettingsViewController.swift
//  GoTime
//
//  Created by John Keith on 4/8/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

// TODO: UNTESTED
class SettingsViewController: UIViewController {
    var settingsTable: SettingsTable
    var bottomDividerLabel: DividerLabel
    var topDividerLabel: DividerLabel
    
    override func viewDidLoad() {
        self.view.backgroundColor = Constants.colorPalette["white"]
    }
    
    init(settingsTable: SettingsTable = SettingsTable(),
         bottomDividerLabel: DividerLabel = DividerLabel(hidden: false),
         topDividerLabel: DividerLabel = DividerLabel(hidden: false)) {
        self.settingsTable = settingsTable
        self.bottomDividerLabel = bottomDividerLabel
        self.topDividerLabel = topDividerLabel
        
        super.init(nibName: nil, bundle: nil)
        
        setColoration()
        
        self.addSubviews([settingsTable, bottomDividerLabel, topDividerLabel])
        
        addConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotificationOfDarkModeFlipped), name: Notification.Name(rawValue: Constants.notificationOfDarkModeToggle), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints() {
        SettingsViewControllerConstraints.positionSettingsTable(settingsTable: settingsTable)
        SettingsViewControllerConstraints.positionBottomDividerLabel(dividerLabel: bottomDividerLabel)
        SettingsViewControllerConstraints.positionTopDividerLabel(dividerLabel: topDividerLabel)
    }
}

extension SettingsViewController: RespondsToThemeChange {
    func handleNotificationOfDarkModeFlipped(notification: Notification) {
        let value = notification.userInfo?["value"] as! Bool
        
        setColoration(darkModeEnabled: value, animationDuration: 0.2)
    }
    
    func setColoration(darkModeEnabled: Bool = Constants.storedSettings.bool(forKey: SettingsService.useDarkModeKey), animationDuration: Double = 0.0) {
        UIView.animate(withDuration: animationDuration, animations: {
            if darkModeEnabled {
                self.view.backgroundColor = Constants.colorPalette["black"]
            } else {
                self.view.backgroundColor = Constants.colorPalette["white"]
            }
        })
    }
}
