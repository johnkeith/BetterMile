//
//  MainViewControllerConstraints.swift
//  GoTime
//
//  Created by John Keith on 1/22/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit
import SnapKit

class MainViewControllerConstraints {
    static let sharedInstance = MainViewControllerConstraints()
    private init() {}
    
    private static let defaultMargin = 20
    
    class func positionStartButton(startButton: StartButton) {
        startButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(startButton.superview!).offset(-(defaultMargin * 2))
            make.height.equalTo(startButton.superview!.frame.height / 5)
            make.center.equalTo(startButton.superview!)
        }
    }
    
    class func positionTotalTimeLabel(totalTimeLabel: TotalTimeLabel) {
        totalTimeLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(totalTimeLabel.superview!).offset(-(defaultMargin * 2))
            make.height.equalTo(totalTimeLabel.superview!.frame.height * (1/6))
            make.top.equalTo(totalTimeLabel.superview!).offset(defaultMargin * 3)
            make.left.equalTo(totalTimeLabel.superview!).offset(defaultMargin)
        }
    }
    
    class func positionLapTimeTable(lapTimeTable: LapTimeTable, totalTimeLabel: TotalTimeLabel) {
        // relative to totalTimeLabel
        lapTimeTable.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(lapTimeTable.superview!)
            make.top.equalTo(totalTimeLabel.snp.bottom).offset(defaultMargin / 2)
            make.left.equalTo(lapTimeTable.superview!)
            make.bottom.equalTo(lapTimeTable.superview!)
        }
    }
    
    class func positionDividerLabel(dividerLabel: DividerLabel, lapTimeTable: LapTimeTable) {
        dividerLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(dividerLabel.superview!).offset(-(defaultMargin * 2))
            make.height.equalTo(2)
            make.top.equalTo(lapTimeTable.snp.top).offset(-(defaultMargin / 2))
            make.left.equalTo(lapTimeTable.superview!).offset(defaultMargin)
        }
    }
}
