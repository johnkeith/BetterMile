//
//  LapTimeViewControllerConstraints.swift
//  GoTime
//
//  Created by John Keith on 4/9/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit
import SnapKit

class LapTimeViewControllerConstraints {
    static let sharedInstance = LapTimeViewControllerConstraints()
    
    private init() {}
    
    private static let defaultMargin = Constants.defaultMargin
    
    class func positionLapTimeTable(lapTimeTable: LapTimeTable) {
        lapTimeTable.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(lapTimeTable.superview!)
//            make.width.equalTo(lapTimeTable.superview!).offset(-(defaultMargin * 2))
            make.top.equalTo(lapTimeTable.superview!).offset(defaultMargin * 2)
//            make.left.equalTo(lapTimeTable.superview!).offset(defaultMargin)
            make.bottom.equalTo(lapTimeTable.superview!).offset(-(defaultMargin * 2))
        }
        
        lapTimeTable.layoutIfNeeded()
        
        lapTimeTable.contentInset = UIEdgeInsetsMake(0.0, 0.0, lapTimeTable.frame.height - Constants.lapTimeTableCellHeight, 0.0)
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
    
    class func positionTopDividerLabel(dividerLabel: DividerLabel) {
        dividerLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(dividerLabel.superview!)
//            make.width.equalTo(dividerLabel.superview!).offset(-(defaultMargin * 2))
            make.height.equalTo(1)
//            make.left.equalTo(dividerLabel.superview!).offset(defaultMargin)
            make.top.equalTo(dividerLabel.superview!).offset(defaultMargin * 2)
        }
    }
    
    class func positionBottomDividerLabel(dividerLabel: DividerLabel) {
        dividerLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(dividerLabel.superview!)
//            make.width.equalTo(dividerLabel.superview!).offset(-(defaultMargin * 2))
            make.height.equalTo(1)
//            make.left.equalTo(dividerLabel.superview!).offset(defaultMargin)
            make.bottom.equalTo(dividerLabel.superview!).offset(-(defaultMargin * 2))
        }
    }
    
    class func positionLapTimeTableEmptyLabel(lapTimeTableEmptyLabel: LapTimeTableEmptyLabel, lapTimeTable: LapTimeTable) {
        lapTimeTableEmptyLabel.snp.makeConstraints { (make) in
            make.width.equalTo(lapTimeTableEmptyLabel.superview!).offset(-(defaultMargin * 2))
            make.height.equalTo(lapTimeTableEmptyLabel.superview!.frame.height / 5)
            make.center.equalTo(lapTimeTable.snp.center)
        }
    }
}
