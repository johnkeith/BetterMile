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
        self.alwaysBounceVertical = false
        
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
    
//  TODO: UNTESTED
    func setRowHeightBySuperview(_superview: UIView) {
        self.rowHeight = _superview.frame.height / 9
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
        let index = indexPath.row
        let time = timeToTextService.timeAsSingleString(inputTime: lapData[index])
        let lapNumber = lapData.count - indexPath.row
        let content = "\(lapNumber > 9 ? "" : "0")\(lapNumber) - \(time)"
        
        let cell = self.dequeueReusableCell(withIdentifier: "lapTimeTableCell") as! LapTimeTableCell
        
        if index > 0 {
            if lapData.count > 2 {
                setCellTextColor(cell, at: index, checkForSlowest: true)
            } else if lapData.count == 2 {
                setCellTextColor(cell, at: index)
            } else {
                cell.setTextColorBasedOnSettings()
            }
        } else {
            cell.setTextColorBasedOnSettings()
        }
        
        cell.setContent(labelText: content)
        cell.addLabelAndLineConstraints(rowHeight: self.rowHeight)
        
        return cell
    }
    
    func setCellTextColor(_ cell: LapTimeTableCell, at index: Int, checkForSlowest: Bool = false) {
        if checkForSlowest && isSlowestLap(index){
            cell.backgroundColor = Constants.colorPalette["_red"]
            cell.label.textColor = Constants.colorPalette["white"]
        } else if isFastestLap(index) {
            cell.backgroundColor = Constants.colorPalette["_green"]
            cell.label.textColor = Constants.colorPalette["white"]
        } else {
            cell.setTextColorBasedOnSettings()
        }
    }
    
    func isSlowestLap(_ index: Int) -> Bool {
        let lapsMinusFirst = Array(self.lapData.dropFirst())
        let slowestLapIndex = StopWatchService.findSlowestLapIndex(lapsMinusFirst)
        
        if slowestLapIndex != nil {
            return slowestLapIndex! + 1 == index
        } else {
            return false
        }
        
    }
    
    func isFastestLap(_ index: Int) -> Bool {
        let lapsMinusFirst = Array(self.lapData.dropFirst())
        let fastestLapIndex = StopWatchService.findFastestLapIndex(lapsMinusFirst)
        
        if fastestLapIndex != nil {
            return fastestLapIndex! + 1 == index
        } else {
            return false
        }
    }
}

extension LapTimeTable: RespondsToThemeChange {
    func handleNotificationOfDarkModeFlipped(notification: Notification) {
        let value = notification.userInfo?["value"] as! Bool
        
        setColoration(darkModeEnabled: value)
        self.reloadData()
    }
    
    func setColoration(darkModeEnabled: Bool = Constants.storedSettings.bool(forKey: SettingsService.useDarkModeKey), animationDuration: Double = 0.0) {
        if darkModeEnabled {
            self.backgroundColor = Constants.colorPalette["black"]
        } else {
            self.backgroundColor = Constants.colorPalette["white"]
        }
    }
    
    
}

