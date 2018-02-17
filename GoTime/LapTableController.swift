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
    
    var fgColor: UIColor?
    var bgColor: UIColor? {
        didSet {
            self.view.backgroundColor = bgColor
        }
    }
    
    var usesDarkMode: Bool = Constants.storedSettings.bool(forKey: SettingsService.darkModeKey) {
        didSet {
            self.setColorConstants()
        }
    }
    
    init(stopWatchSrv: StopWatchService) {
        lapTable = LapTimeTable(stopWatchSrv: stopWatchSrv)
        lapTable.reloadData()
        
        super.init(nibName: nil, bundle: nil)
        
        lapTable.setRowHeightBySuperview(_superview: self.view)
        
        self.view.addSubview(lapTable)
        self.view.backgroundColor = Constants.colorBlack
        
        setColorConstants()
        configLapTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Lap Times"
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.navigationBar.barStyle = usesDarkMode ? .blackTranslucent : .default
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = bgColor
        self.navigationController?.view.backgroundColor = bgColor
        self.navigationController?.navigationBar.tintColor = bgColor
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationController?.navigationBar.tintColor = fgColor
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
    
    private func setColorConstants() {
        fgColor = usesDarkMode ? Constants.colorWhite : Constants.colorBlack
        bgColor = usesDarkMode ? Constants.colorBlack : Constants.colorWhite
    }
}
