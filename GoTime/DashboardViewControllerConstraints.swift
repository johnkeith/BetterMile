//
//  DashboardViewControllerConstraints.swift
//  GoTime
//
//  Created by John Keith on 4/8/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit
import SnapKit

class DashboardViewControllerConstraints {
    static let sharedInstance = DashboardViewControllerConstraints()
    
    private init() {}
    
    private static let defaultMargin = Constants.defaultMargin
    
    class func positionStartButton(startButton: StartButton) {
        startButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(startButton.superview!).offset(-(defaultMargin * 6))
            make.height.equalTo(startButton.superview!.frame.height / 5)
            make.center.equalTo(startButton.superview!)
        }
    }
    
    class func positionTotalTimeLabel(totalTimeLabel: TotalTimeLabel) {
        totalTimeLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(totalTimeLabel.superview!).offset(-defaultMargin * 2)
            make.height.equalTo(totalTimeLabel.superview!.frame.height / 6)
            make.centerX.equalTo(totalTimeLabel.superview!)
            make.top.equalTo(totalTimeLabel.superview!).offset(defaultMargin * 2)
//            make.bottom.equalTo(totalTimeLabel.superview!.snp.centerY)
        }
    }

    class func positionTimerHelpTextLabel(timerHelpTextLabel: TimerHelpTextLabel) {
        timerHelpTextLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(timerHelpTextLabel.superview!).offset(-(defaultMargin * 2))
            make.height.equalTo(timerHelpTextLabel.superview!.frame.height / 5)
            make.centerY.equalTo(timerHelpTextLabel.superview!)
            make.centerX.equalTo(timerHelpTextLabel.superview!)
        }
    }
    
    class func positionLapTimeTable(lapTimeTable: LapTimeTable, totalTimeLabel: TotalTimeLabel) {
        lapTimeTable.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(lapTimeTable.superview!).offset(-defaultMargin * 2)
            make.top.equalTo(totalTimeLabel.snp.bottom).offset(defaultMargin / 2)
            make.left.equalTo(lapTimeTable.superview!).offset(defaultMargin)
            make.bottom.equalTo(lapTimeTable.superview!).offset(-(defaultMargin * 2))
        }
        
        lapTimeTable.layoutIfNeeded()
        
        lapTimeTable.contentInset = UIEdgeInsetsMake(0.0, 0.0, lapTimeTable.frame.height - lapTimeTable.superview!.frame.height / 9, 0.0)
    }
    
    class func positionFadeOverlayView(fadeOverlayView: FadeOverlayView, lapTimeTable: LapTimeTable) {
        fadeOverlayView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(lapTimeTable.snp.top)
            make.bottom.equalTo(lapTimeTable.snp.bottom)
            make.width.equalTo(lapTimeTable.snp.width)
            make.left.equalTo(lapTimeTable.snp.left)
        }
        
        fadeOverlayView.layoutIfNeeded()
        
        fadeOverlayView.gradientLayer.frame = fadeOverlayView.bounds
    }
    
    class func positionTopDividerLabel(dividerLabel: DividerLabel, lapTimeTable: LapTimeTable) {
        dividerLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(dividerLabel.superview!).offset(-defaultMargin * 2)
            make.height.equalTo(1)
            make.left.equalTo(dividerLabel.superview!).offset(defaultMargin)
            make.top.equalTo(lapTimeTable.snp.top)
        }
    }
    
    class func positionBottomDividerLabel(dividerLabel: DividerLabel, lapTimeTable: LapTimeTable) {
        dividerLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(dividerLabel.superview!).offset(-defaultMargin * 2)
            make.height.equalTo(1)
            make.left.equalTo(dividerLabel.superview!).offset(defaultMargin)
            make.bottom.equalTo(lapTimeTable.snp.bottom)
        }
    }
}
