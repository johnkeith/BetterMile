//
//  LapTimeTable.swift
//  GoTime
//
//  Created by John Keith on 2/8/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class LapTimeTable: UITableView {    
    var lapData = [Double]()
    var timeToTextService: TimeToTextService
    
    init(hidden: Bool = true, timeToTextService: TimeToTextService = TimeToTextService()) {
        self.timeToTextService = timeToTextService
        let defaultFrame = CGRect()

        super.init(frame: defaultFrame, style: .plain)

        self.isHidden = hidden
//        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.dataSource = self
        
        self.rowHeight = 60
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        
        setColoration()
        
        self.register(LapTimeTableCell.self, forCellReuseIdentifier: "lapTimeTableCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotificationOfDarkModeFlipped), name: Notification.Name(rawValue: Constants.notificationOfDarkModeToggle), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    func setLapData(lapData: [Double]) {
        self.lapData = lapData        
    }
    
//  TODO: UNTESTED - TODO: FIX - showing errors sometimes
    func reloadCurrentLapRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        
        self.reloadRows(at: [indexPath], with: .none)
    }
    
    func clearLapData() {
        self.lapData.removeAll()
        self.reloadData()
    }
}

extension LapTimeTable: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let time = timeToTextService.timeAsSingleString(inputTime: lapData[indexPath.row])
        let lapNumber = lapData.count - indexPath.row
        let content = "\(lapNumber > 9 ? "" : "0")\(lapNumber) - \(time)"
// TODO: WHY DOES THIS NOT WORK, BUT REMOVING THE FOR MAKES IT WORK?
//        let cell = self.dequeueReusableCell(withIdentifier: "lapTimeTableCell", for: indexPath) as! LapTimeTableCell
        let cell = self.dequeueReusableCell(withIdentifier: "lapTimeTableCell") as! LapTimeTableCell
        
        cell.setContent(labelText: content)
        
        return cell
    }
}

extension LapTimeTable: RespondsToThemeChange {
    func handleNotificationOfDarkModeFlipped(notification: Notification) {
        let value = notification.userInfo?["value"] as! Bool
        
        setColoration(darkModeEnabled: value)
    }
    
    func setColoration(darkModeEnabled: Bool = Constants.storedSettings.bool(forKey: SettingsService.useDarkModeKey)) {
        if darkModeEnabled {
            self.backgroundColor = Constants.colorPalette["black"]
        } else {
            self.backgroundColor = Constants.colorPalette["white"]
        }
    }
}

