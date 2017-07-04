//
//  LapTableController.swift
//  GoTime
//
//  Created by John Keith on 5/25/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class LapTableController: UIViewController {
    let lapTable = LapTimeTable()
    
    init(lapTimes: [Double]) {
        lapTable.setLapData(lapData: lapTimes)
        lapTable.reloadData()
        
        super.init(nibName: nil, bundle: nil)
        
        lapTable.setRowHeightBySuperview(_superview: self.view)
        
        self.view.addSubview(lapTable)
        self.view.backgroundColor = Constants.colorPalette["black"]
        
        configLapTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = Constants.colorPalette["white"]
//        self.navigationController?.navigationBar.titleTextAttributes = UIFont.preferredFont(forTextStyle: .headline)
        self.navigationItem.title = "Lap Times"
        
        
//        let backButton = UIBarButtonItem(title: "< Backzßß®", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        
//        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline)], for: UIControlState.normal)
        

        
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline)], for: UIControlState.normal)
    }
    
    func configLapTable() {
        lapTable.isHidden = false
        lapTable.snp.makeConstraints({ make in
            make.width.equalTo(lapTable.superview!)
            make.top.equalTo(lapTable.superview!)
            make.bottom.equalTo(lapTable.superview!)
        })
    }
}
