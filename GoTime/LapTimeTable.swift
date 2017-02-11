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
    init(hidden: Bool = false) {
        let defaultFrame = CGRect(x: 0, y: 0, width: 100, height: 100)

        super.init(frame: defaultFrame, style: .plain)

        self.isHidden = hidden
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    func setDataSource(dataStore: [Double]) {
        self.dataSource = LapTimeTableDataSource(dataStore: dataStore)
        self.reloadData()
        print(dataStore, "Set as dataSource")
    }
    
    func hide() {
        isHidden = true
    }
    
    func show() {
        isHidden = false
    }
}

// TODO: UNTESTED
class LapTimeTableDataSource: NSObject {
    var dataStore: [Double]
    var timeToTextService: TimeToTextService
    
    init(dataStore: [Double], timeToTextService: TimeToTextService = TimeToTextService()) {
        
        self.dataStore = dataStore
        self.timeToTextService = timeToTextService
        print(dataStore, "init store")
    }
}

extension LapTimeTableDataSource: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("in sections")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("in count")
        return dataStore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("settingUpCell")
        let time = timeToTextService.timeAsSingleString(inputTime: dataStore[indexPath.row])
        let cell = tableView.dequeueReusableCell(withIdentifier: "LapTimeTableCell", for: indexPath as IndexPath)
        
        cell.textLabel?.text = "\(time)"
        
        return cell
    }
}

