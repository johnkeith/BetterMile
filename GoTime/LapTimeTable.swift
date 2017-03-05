//
//  LapTimeTable.swift
//  GoTime
//
//  Created by John Keith on 2/8/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class LapTimeTable: UITableView {
    let gradientLayer = CAGradientLayer()
    
    var lapData = [Double]()
    var timeToTextService: TimeToTextService
    
    init(hidden: Bool = false, timeToTextService: TimeToTextService = TimeToTextService()) {
        self.timeToTextService = timeToTextService
        let defaultFrame = CGRect(x: 0, y: 0, width: 100, height: 100)

        super.init(frame: defaultFrame, style: .plain)

        self.isHidden = hidden
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.dataSource = self
        
        self.rowHeight = 60
        self.separatorStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = self.bounds

        let firstColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        let secondColor = UIColor(white: 1, alpha: 0).cgColor
        gradientLayer.colors = [firstColor, secondColor]
        
        self.layer.mask = gradientLayer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    func setLapData(lapData: [Double]) {
        self.lapData = lapData
        self.reloadData()
    }
    
    func clearLapData() {
        self.lapData.removeAll()
        self.reloadData()
    }
    
    func applyGradientMask() {
//        print(self.bounds, self.frame)
//        gradientLayer.bounds = CGRect(x: 0,y: 0, width: 500, height: 500)
//        // GOTTA FIGURE OUT WHY THE SIZING IS NOT CORRECT
//        let firstColor = UIColor.clear.cgColor
//        let secondColor = UIColor.clear.withAlphaComponent(0).cgColor
////        gradientLayer.colors = [firstColor, secondColor]
//        gradientLayer.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor, UIColor(white: 1, alpha: 0).cgColor ]
//        
//        
////        self.layer.mask = gradientLayer
//        self.layer.mask = UIColor.black.cgColor
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let time = timeToTextService.timeAsSingleString(inputTime: lapData[indexPath.row])
        let cell = LapTimeTableCell()
        
        let content = "\(lapData.count - indexPath.row) - \(time)"
        
        cell.setContent(labelText: content)
        
        return cell
    }
}

