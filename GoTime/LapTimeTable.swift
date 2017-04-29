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
        
        var content = "\(lapNumber > 9 ? "" : "0")\(lapNumber) - \(time)"
        
        if lapData.count > 2 {
            content = addEmojiToCell(content, at: index, checkForSlowest: true)
        } else if lapData.count == 2 {
            content = addEmojiToCell(content, at: index)
        }
        
        let cell = self.dequeueReusableCell(withIdentifier: "lapTimeTableCell") as! LapTimeTableCell
        
        cell.setContent(labelText: content)
        cell.addLabelAndLineConstraints(rowHeight: self.rowHeight)
        
        return cell
    }
    
    func addEmojiToCell(_ content: String, at index: Int, checkForSlowest: Bool = false) -> String {
        var result = content
        
        if checkForSlowest && isSlowestLap(index){
            result = "🐢 \(result)"
        } else if isFastestLap(index) {
            result = "💪 \(result)"
        }
        
        return result
    }
    
    func isSlowestLap(_ index: Int) -> Bool {
        let slowestLapIndex = StopWatchService.findSlowestLapIndex(self.lapData)
        
        return slowestLapIndex == index
    }
    
    func isFastestLap(_ index: Int) -> Bool {
        let fastestLapIndex = StopWatchService.findFastestLapIndex(self.lapData)
        
        return fastestLapIndex == index
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

