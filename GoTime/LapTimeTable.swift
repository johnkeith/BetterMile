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
        self.delegate = self
        
        self.rowHeight = 60
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        self.alwaysBounceVertical = false
        
        self.backgroundColor = Constants.colorPalette["_black"]
        
        self.register(LapTimeTableCell.self, forCellReuseIdentifier: "lapTimeTableCell")
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
        
        cell.backgroundColor = Constants.colorPalette["_black"]
        cell.setContent(labelText: content)
        cell.addLabelAndLineConstraints(rowHeight: self.rowHeight)
        
        return cell
    }
}

extension LapTimeTable: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(indexPath);
        let index = indexPath.row
        let _cell = cell as! LapTimeTableCell

        if self.lapData.count > 1 {
            setCellTextColor(_cell, at: index)
//        if index > 0 {
//            if lapData.count > 2 {
//                setCellTextColor(_cell, at: index, checkForSlowest: true)
//            } else if lapData.count == 2 {
//                setCellTextColor(_cell, at: index)
//            }
        } else {
            _cell.backgroundColor = Constants.colorPalette["_green"]
        }
    }
    
    func setCellTextColor(_ cell: LapTimeTableCell, at index: Int) {
        let lap = self.lapData[index]
        let quality = StopWatchService.determineLapQuality(lap: lap, laps: self.lapData)
        
        if quality == LapQualities.good {
            cell.backgroundColor = Constants.colorPalette["_green"]
            cell.label.textColor = Constants.colorPalette["_white"]
        } else if quality == LapQualities.bad {
            cell.backgroundColor = Constants.colorPalette["_black"]
            cell.label.textColor = Constants.colorPalette["_white"]
        } else {
            cell.backgroundColor = Constants.colorPalette["_red"]
            cell.label.textColor = Constants.colorPalette["_white"]
        }
    }
    
    func oldSetCellTextColor(_ cell: LapTimeTableCell, at index: Int, checkForSlowest: Bool = false) {
        if checkForSlowest && isSlowestLap(index){
            cell.backgroundColor = Constants.colorPalette["_red"]
            cell.label.textColor = Constants.colorPalette["_white"]
        } else if isFastestLap(index) {
            cell.backgroundColor = Constants.colorPalette["_green"]
            cell.label.textColor = Constants.colorPalette["_white"]
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

