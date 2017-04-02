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
    
    class func positionDividerLabel(dividerLabel: DividerLabel, lapTimeTable: LapTimeTable) {
        dividerLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(dividerLabel.superview!).offset(-(defaultMargin * 2))
            make.height.equalTo(2)
            make.top.equalTo(lapTimeTable.snp.top)
            make.left.equalTo(lapTimeTable.superview!).offset(defaultMargin)
        }
    }
    
    class func positionLapTimeTable(lapTimeTable: LapTimeTable, totalTimeLabel: TotalTimeLabel) {
        // relative to totalTimeLabel
        lapTimeTable.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(lapTimeTable.superview!).offset(-(defaultMargin * 2))
            make.top.equalTo(totalTimeLabel.snp.bottom).offset(defaultMargin / 2)
            make.left.equalTo(lapTimeTable.superview!).offset(defaultMargin)
            make.bottom.equalTo(lapTimeTable.superview!)
        }
    }
    
    class func positionTimerHelpTextLabel(timerHelpTextLabel: TimerHelpTextLabel) {
        timerHelpTextLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(timerHelpTextLabel.superview!).offset(-(defaultMargin * 2))
            make.height.equalTo(timerHelpTextLabel.superview!.frame.height / 5)
            make.center.equalTo(timerHelpTextLabel.superview!)
        }
    }
    
    class func positionOpenSettingsButton(openSettingsButton: OpenSettingsButton) {
        openSettingsButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(openSettingsButton.superview!.frame.width * (1/10))
            make.height.equalTo(openSettingsButton.superview!.frame.width * (1/10))
            make.top.equalTo(openSettingsButton.superview!).offset(Double(defaultMargin) * 2)
            make.right.equalTo(openSettingsButton.superview!).offset(Double(-defaultMargin))
        }
        
        openSettingsButton.layoutIfNeeded()
    }
    
    class func positionSettingsOverlay(settingsOverlay: SettingsOverlay) {
        settingsOverlay.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(settingsOverlay.superview!)
            make.height.equalTo(settingsOverlay.superview!)
        }
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
    
    class func positionVoiceNotificationsButton(voiceNotificationsButton: VoiceNotificationsButton, openSettingsButton: OpenSettingsButton) {
        voiceNotificationsButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(openSettingsButton.snp.top)
            make.width.equalTo(openSettingsButton.frame.width / 5)
            make.height.equalTo(openSettingsButton.frame.width / 5)
            make.left.equalTo(openSettingsButton.snp.left)
        }
    }
    
    class func positionVibrationNotificationsButton(vibrationNotificationsButton: VibrationNotificationsButton, openSettingsButton: OpenSettingsButton) {
        vibrationNotificationsButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(openSettingsButton.snp.top)
            make.width.equalTo(openSettingsButton.frame.width / 5)
            make.height.equalTo(openSettingsButton.frame.width / 5)
            make.left.equalTo(openSettingsButton.snp.left).offset(openSettingsButton.frame.width * 0.4)
        }
    }
    
    class func positionThemeButton(themeButton: ThemeButton, openSettingsButton: OpenSettingsButton) {
        themeButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(openSettingsButton.snp.top)
            make.width.equalTo(openSettingsButton.frame.width / 5)
            make.height.equalTo(openSettingsButton.frame.width / 5)
            make.right.equalTo(openSettingsButton.snp.right)
        }
    }
    
    class func positionPreviousLapTimeButton(previousLapTimeButton: PreviousLapTimeButton, openSettingsButton: OpenSettingsButton) {
        previousLapTimeButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(openSettingsButton.snp.top).offset(openSettingsButton.frame.height * 0.4)
            make.width.equalTo(openSettingsButton.frame.width / 5)
            make.height.equalTo(openSettingsButton.frame.width / 5)
            make.left.equalTo(openSettingsButton.snp.left)
        }
    }
    
    class func positionAverageLapTimeButton(averageLapTimeButton: AverageLapTimeButton, openSettingsButton: OpenSettingsButton) {
        averageLapTimeButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(openSettingsButton.snp.top).offset(openSettingsButton.frame.height * 0.4)
            make.width.equalTo(openSettingsButton.frame.width / 5)
            make.height.equalTo(openSettingsButton.frame.width / 5)
            make.left.equalTo(openSettingsButton.snp.left).offset(openSettingsButton.frame.width * 0.4)
        }
    }
    
    class func positionTotalTimeButton(totalTimeButton: TotalTimeButton, openSettingsButton: OpenSettingsButton) {
        totalTimeButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(openSettingsButton.snp.top).offset(openSettingsButton.frame.height * 0.4)
            make.width.equalTo(openSettingsButton.frame.width / 5)
            make.height.equalTo(openSettingsButton.frame.width / 5)
            make.right.equalTo(openSettingsButton.snp.right)
        }
    }
    
    class func positionVibrateOnLapButton(vibrateOnLapButton: VibrateOnLapButton, openSettingsButton: OpenSettingsButton) {
        vibrateOnLapButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(openSettingsButton.snp.bottom)
            make.width.equalTo(openSettingsButton.frame.width / 5)
            make.height.equalTo(openSettingsButton.frame.width / 5)
            make.left.equalTo(openSettingsButton.snp.left)
        }
    }
    
    class func positionVibrateOnPauseButton(vibrateOnPauseButton: VibrateOnPauseButton, openSettingsButton: OpenSettingsButton) {
        vibrateOnPauseButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(openSettingsButton.snp.bottom)
            make.width.equalTo(openSettingsButton.frame.width / 5)
            make.height.equalTo(openSettingsButton.frame.width / 5)
            make.left.equalTo(openSettingsButton.snp.left).offset(openSettingsButton.frame.width * 0.4)
        }
    }
    
    class func positionVibrateOnClearButton(vibrateOnClearButton: VibrateOnClearButton, openSettingsButton: OpenSettingsButton) {
        vibrateOnClearButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(openSettingsButton.snp.bottom)
            make.width.equalTo(openSettingsButton.frame.width / 5)
            make.height.equalTo(openSettingsButton.frame.width / 5)
            make.right.equalTo(openSettingsButton.snp.right)
        }
    }
    
    class func positionAnySettingsButtonBasedOnMultiplers(button: SettingsButton, xMultiple: Double, yMultiple: Double) {
        let x = Double(button.superview!.frame.width) * xMultiple
        let y = Double(button.superview!.frame.width) * yMultiple
        let initialWidth = button.frame.width
        let initialHeight = button.frame.height
        
        button.snp.updateConstraints { (make) -> Void in
            make.left.equalTo(x)
            make.top.equalTo(y)
            make.width.equalTo(initialWidth * 3)
            make.height.equalTo(initialHeight * 3)
        }
    }
}
