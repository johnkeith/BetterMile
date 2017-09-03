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
    
    init(stopWatchSrv: StopWatchService = StopWatchService(), hidden: Bool = true, timeToTextService: TimeToTextService = TimeToTextService()) {
        self.timeToTextService = timeToTextService
        self.stopWatchSrv = stopWatchSrv
        
        let defaultFrame = CGRect()

        super.init(frame: defaultFrame, style: .plain)

        self.isHidden = hidden
        self.dataSource = self
        self.delegate = self
        
        self.rowHeight = 60
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        self.alwaysBounceVertical = false
        
        self.backgroundColor = Constants.colorPalette["_black"]
        
        self.register(LapTimeTableCell.self, forCellReuseIdentifier: "lapTimeTableCell")
        
        setLapData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    func setLapData() {
        self.lapData = stopWatchSrv.lapTimes.reversed()
    }
    
//  TODO: UNTESTED - TODO: FIX - showing errors sometimes
    func reloadCurrentLapRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        
        self.reloadRows(at: [indexPath], with: .none)
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
        
        cell.backgroundColor = Constants.colorPalette["_black"]
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
        let someAction = UITableViewRowAction(style: .default, title: "Delete") { value in
            self.beginUpdates()
            
            self.stopWatchSrv.deleteLap(at: indexPath.row)
            self.lapData.remove(at: indexPath.row)
            self.deleteRows(at: [indexPath], with: .automatic)
            
            self.endUpdates()
            self.reloadData()
        }
        
        someAction.backgroundColor = Constants.colorPalette["_black"]
        
        return [someAction]
    }
}

extension LapTimeTable: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let _cell = cell as! LapTimeTableCell

        if self.lapData.count > 1 && index != 0 {
            setCellTextColor(_cell, at: index)
        } else {
            setDefaultRowColors(_cell)
        }
    }
    
    func setCellTextColor(_ cell: LapTimeTableCell, at index: Int) {
        let lap = self.lapData[index]
        let lapDataWithoutCurrentLap = Array(self.lapData[1..<self.lapData.count])
        let quality = StopWatchService.determineLapQuality(lap: lap, laps: lapDataWithoutCurrentLap)
        
        if quality == LapQualities.good {
            cell.backgroundColor = Constants.colorPalette["_green"]
            cell.label.textColor = Constants.colorWhite
        } else if quality == LapQualities.bad {
            setDefaultRowColors(cell)
        } else {
            cell.backgroundColor = Constants.colorPalette["_red"]
            cell.label.textColor = Constants.colorWhite
        }
    }
    
    func setDefaultRowColors(_ cell: LapTimeTableCell) {
        cell.backgroundColor = Constants.colorPalette["_black"]
        cell.label.textColor = Constants.colorWhite
    }
    
    func oldSetCellTextColor(_ cell: LapTimeTableCell, at index: Int, checkForSlowest: Bool = false) {
        if checkForSlowest && isSlowestLap(index){
            cell.backgroundColor = Constants.colorPalette["_red"]
            cell.label.textColor = Constants.colorWhite
        } else if isFastestLap(index) {
            cell.backgroundColor = Constants.colorPalette["_green"]
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

