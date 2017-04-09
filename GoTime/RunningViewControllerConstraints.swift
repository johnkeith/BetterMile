//
//  RunningViewControllerConstraints.swift
//  GoTime
//
//  Created by John Keith on 4/8/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit
import SnapKit

class RunningViewControllerConstraints {
    static let sharedInstance = RunningViewControllerConstraints()
    
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
            make.width.equalTo(totalTimeLabel.superview!).offset(-(defaultMargin * 2))
            make.height.equalTo(totalTimeLabel.superview!.frame.height * (1/6))
            make.top.equalTo(totalTimeLabel.superview!).offset(defaultMargin * 4)
            make.left.equalTo(totalTimeLabel.superview!).offset(defaultMargin)
        }
    }
    
    class func positionDividerLabel(dividerLabel: DividerLabel, totalTimeLabel: TotalTimeLabel) {
        dividerLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(dividerLabel.superview!).offset(-(defaultMargin * 2))
            make.height.equalTo(2)
            make.top.equalTo(totalTimeLabel.snp.bottom).offset(defaultMargin / 2)
            make.left.equalTo(dividerLabel.superview!).offset(defaultMargin)
        }
    }

    class func positionTimerHelpTextLabel(timerHelpTextLabel: TimerHelpTextLabel) {
        timerHelpTextLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(timerHelpTextLabel.superview!).offset(-(defaultMargin * 2))
            make.height.equalTo(timerHelpTextLabel.superview!.frame.height / 5)
            make.center.equalTo(timerHelpTextLabel.superview!)
        }
    }
}
