//
//  LapTimeTable.swift
//  GoTime
//
//  Created by John Keith on 2/8/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

// TODO: UNTESTED
class LapTimeTable: UITableView {
    var lapData = [Double]()
    var timeToTextService: TimeToTextService
    
    init(hidden: Bool = false, timeToTextService: TimeToTextService = TimeToTextService()) {
        self.timeToTextService = timeToTextService
        let defaultFrame = CGRect(x: 0, y: 0, width: 100, height: 100)

        super.init(frame: defaultFrame, style: .plain)

        self.isHidden = hidden
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    func setLapData(lapData: [Double]) {
        self.lapData = lapData
        self.reloadData()
    }
    
    func hide() {
        isHidden = true
    }
    
    func show() {
        isHidden = false
    }
}

extension LapTimeTable: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("in sections")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("in count", lapData.count)
        return lapData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("settingUpCell")
        let time = timeToTextService.timeAsSingleString(inputTime: lapData[indexPath.row])
//        let cell = tableView.dequeueReusableCell(withIdentifier: "LapTimeTableCell", for: indexPath as IndexPath)
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "\(time)"
        
        return cell
    }
}

