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
    init(dataStore: [Double]) {
        let defaultFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        super.init(frame: defaultFrame, style: .plain)
        
        self.dataSource = LapTimeTableDataSource(dataStore: dataStore)
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// TODO: UNTESTED
class LapTimeTableDataSource: NSObject, UITableViewDataSource {
    var dataStore: [Double]
    var timeToTextService: TimeToTextService
    
    init(dataStore: [Double], timeToTextService: TimeToTextService = TimeToTextService()) {
        self.dataStore = dataStore
        self.timeToTextService = timeToTextService
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let time = timeToTextService.timeAsSingleString(inputTime: dataStore[indexPath.row])
        let cell = tableView.dequeueReusableCell(withIdentifier: "LapTimeTableCell", for: indexPath as IndexPath)
        
        cell.textLabel?.text = "\(time)"
        
        return cell
    }
}

