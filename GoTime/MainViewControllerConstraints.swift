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
    
    class func positionStartButton(startButton: UIButton) {
        startButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(startButton.superview!).offset(-(defaultMargin * 2))
            make.height.equalTo(startButton.superview!.frame.height / 5)
            make.center.equalTo(startButton.superview!)
        }
    }
    
    class func positionTotalTimeLabel(totalTimeLabel: UILabel) {
        totalTimeLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(totalTimeLabel.superview!).offset(-(defaultMargin * 2))
            make.height.equalTo(totalTimeLabel.superview!.frame.height / 6)
            make.top.equalTo(totalTimeLabel.superview!).offset(defaultMargin * 2)
            make.left.equalTo(totalTimeLabel.superview!).offset(defaultMargin)
        }
    }
}
