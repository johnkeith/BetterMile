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
    
    override func viewDidLoad() {
        self.view.backgroundColor = Constants.colorPalette["white"]
    }
    
    init(settingsTable: SettingsTable = SettingsTable()) {
        self.settingsTable = settingsTable
        
        super.init(nibName: nil, bundle: nil)
        
        self.addSubviews([settingsTable])
        
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints() {
        SettingsViewControllerConstraints.positionSettingsTable(settingsTable: settingsTable)
    }
}
