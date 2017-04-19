//
//  SettingsTable.swift
//  GoTime
//
//  Created by John Keith on 4/9/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

// TODO: UNTESTED
class SettingsTable: UITableView {
    var settingsService: SettingsService
    
    init(settingsService: SettingsService = SettingsService()) {
        self.settingsService = settingsService
        
        super.init(frame: Constants.defaultFrame, style: .plain)
        
        self.dataSource = self
        
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        self.rowHeight = Constants.lapTimeTableCellHeight
        
        self.register(SettingsTableCell.self, forCellReuseIdentifier: "settingsTableCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsTable: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsService.mapOfSettingsForTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: "settingsTableCell") as! SettingsTableCell
        
        let displayName = settingsService.mapOfSettingsForTable[indexPath.row].displayName
        let userDefaultsKey = settingsService.mapOfSettingsForTable[indexPath.row].userDefaultsKey
        
        cell.userDefaultsKey = userDefaultsKey
        cell.setContent(displayName: displayName)
        cell.setToggleState()
        cell.addConstraints(leftInset: self.separatorInset.left)
        
        return cell
    }
}
