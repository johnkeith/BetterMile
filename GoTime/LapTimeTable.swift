//
//  LapTimeTable.swift
//  GoTime
//
//  Created by John Keith on 2/8/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class LapTimeTable: UITableView {
    var stopWatchSrv: StopWatchService
    var lapData = [Double]()
    var timeToTextService: TimeToTextService
    
    var fgColor: UIColor?
    var bgColor: UIColor? {
        didSet {
            self.backgroundColor = bgColor
        }
    }
    
    var usesDarkMode: Bool = Constants.storedSettings.bool(forKey: SettingsService.darkModeKey) {
        didSet {
            self.setColorConstants()
        }
    }
    
    init(stopWatchSrv: StopWatchService = StopWatchService(), hidden: Bool = true, timeToTextService: TimeToTextService = TimeToTextService()) {
        self.timeToTextService = timeToTextService
        self.stopWatchSrv = stopWatchSrv
        
        let defaultFrame = CGRect()

        super.init(frame: defaultFrame, style: .plain)

        self.isHidden = hidden
        self.dataSource = self
        self.delegate = self
        
        self.rowHeight = 60
//        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        self.alwaysBounceVertical = false
        
        self.setColorConstants()
        self.backgroundColor = bgColor
        
        self.register(LapTimeTableCell.self, forCellReuseIdentifier: "lapTimeTableCell")
        
        setLapData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    func setLapData() {
        self.lapData = stopWatchSrv.completedLapTimes().reversed()
    }
    
    func showMessageIfNoData() {
        if lapData.count == 0 {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: superview!.bounds.size.width, height: superview!.bounds.size.height))
            messageLabel.text = "No completed lap times"
            messageLabel.textColor = fgColor
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont.preferredFont(forTextStyle: .body)
            messageLabel.sizeToFit()
            
            self.backgroundView = messageLabel;
            self.separatorStyle = .none;
        }
    }
    
    func setRowHeightBySuperview(_superview: UIView) {
        self.rowHeight = _superview.frame.height / Constants.tableRowHeightDivisor
    }
    
    private func setColorConstants() {
        fgColor = usesDarkMode ? Constants.colorWhite : Constants.colorBlack
        bgColor = usesDarkMode ? Constants.colorBlack : Constants.colorWhite
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
        
        cell.backgroundColor = bgColor
        cell.setContent(labelText: content)
        cell.setLineVisibility(index: index)
        cell.addLabelAndLineConstraints(rowHeight: self.rowHeight)
        
        return cell
    }
    
//    CAN BE USED TO ADD DELETE TO TABLE, NEEDS STYLING
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let someAction = UITableViewRowAction(style: .default, title: "Delete") { value, other in
            self.beginUpdates()
            
            let reversedIndex = self.stopWatchSrv.lapTimes.count - indexPath.row - 1
            self.stopWatchSrv.deleteLap(at: reversedIndex)
            self.lapData.remove(at: indexPath.row)
            self.deleteRows(at: [indexPath], with: .automatic)
            
            self.endUpdates()
            self.reloadData()
        }
        
        someAction.backgroundColor = Constants.colorBlack
        
        return [someAction]
    }
}

extension LapTimeTable: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let _cell = cell as! LapTimeTableCell

        setCellTextColor(_cell, at: index)
    }
    
    func setCellTextColor(_ cell: LapTimeTableCell, at index: Int) {
        let lap = self.lapData[index]
        let lapDataWithoutCurrentLap = Array(self.lapData[1..<self.lapData.count])
        let quality = StopWatchService.determineLapQuality(lap: lap, laps: lapDataWithoutCurrentLap)
        
        if quality == LapQualities.good {
            cell.label.textColor = Constants.colorGreen
        } else if quality == LapQualities.bad {
            setDefaultRowColors(cell)
        } else {
            cell.label.textColor = Constants.colorRed
        }
    }
    
    func setDefaultRowColors(_ cell: LapTimeTableCell) {
        cell.backgroundColor = bgColor
        cell.label.textColor = fgColor
    }
    
    func oldSetCellTextColor(_ cell: LapTimeTableCell, at index: Int, checkForSlowest: Bool = false) {
        if checkForSlowest && isSlowestLap(index){
            cell.backgroundColor = Constants.colorRed
            cell.label.textColor = Constants.colorWhite
        } else if isFastestLap(index) {
            cell.backgroundColor = Constants.colorGreen
            cell.label.textColor = Constants.colorWhite
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

