//
//  LapTableController.swift
//  GoTime
//
//  Created by John Keith on 5/25/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class LapTableController: UIViewController {
    let lapTable: LapTimeTable
    
    init(stopWatchSrv: StopWatchService) {
        lapTable = LapTimeTable(stopWatchSrv: stopWatchSrv)
        lapTable.reloadData()
        
        super.init(nibName: nil, bundle: nil)
        
        lapTable.setRowHeightBySuperview(_superview: self.view)
        
        self.view.addSubview(lapTable)
        self.view.backgroundColor = Constants.colorBlack
        
        configLapTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = Constants.colorBlack
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.title = "Lap Times"
        self.navigationController?.isToolbarHidden = true
    }
    
    func configLapTable() {
        lapTable.isHidden = false
        lapTable.snp.makeConstraints({ make in
            make.width.equalTo(lapTable.superview!)
            make.top.equalTo(lapTable.superview!)
            make.bottom.equalTo(lapTable.superview!)
        })
        lapTable.showMessageIfNoData()
    }
}
