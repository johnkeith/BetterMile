//
//  SingleViewController.swift
//  GoTime
//
//  Created by John Keith on 5/1/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class SingleViewController: UIViewController {
//  NON-DI
    let startBtn = UIButton()
    let totalTimeLbl = UILabel()
    let lapLbl = UILabel()
    
//  DI
    var stopWatchSrv: StopWatchService
    
    init(stopWatchSrv: StopWatchService = StopWatchService()) {
        self.stopWatchSrv = stopWatchSrv

        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = Constants.colorPalette["white"]
        
        addSubviews([startBtn, totalTimeLbl, lapLbl])

        configStartBtn()
        configTotalTimeLbl()
        configLapLbl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("config(coder:) has not been implemented")
    }
    
    func configStartBtn() {
        self.startBtn.setTitle("START", for: UIControlState.normal)
        self.startBtn.setTitleColor(Constants.colorPalette["black"], for: UIControlState.normal)
        self.startBtn.titleLabel?.font = Constants.responsiveDefaultFont
        self.startBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        self.startBtn.titleLabel?.numberOfLines = 1
        self.startBtn.titleLabel?.baselineAdjustment = .alignCenters
        self.startBtn.titleLabel?.textAlignment = .center
        
        self.startBtn.addTarget(self, action:#selector(onStartTap), for: .touchUpInside)
        
        self.startBtn.snp.makeConstraints { make in
            make.width.equalTo(startBtn.superview!).offset(-Constants.defaultMargin * 4)
            make.center.equalTo(startBtn.superview!)
        }
    }
    
    func configTotalTimeLbl() {

    }
    
    func configLapLbl() {

    }
    
    func onStartTap() {
        print("start tapped")
    }
}
