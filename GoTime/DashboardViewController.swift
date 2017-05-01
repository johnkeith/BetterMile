//
//  DashboardViewController.swift
//  GoTime
//
//  Created by John Keith on 4/8/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit
import AudioToolbox

// TODO: UNTESTED
class DashboardViewController: UIViewController {
    var stopWatchService: StopWatchService
    var timeToTextService: TimeToTextService
    var startButton: StartButton
    var totalTimeLabel: TotalTimeLabel
    var timerHelpTextLabel: TimerHelpTextLabel
    var lapTimeTable: LapTimeTable
    var fadeOverlayView: FadeOverlayView
    var bottomDividerLabel: DividerLabel
    var topDividerLabel: DividerLabel
    var restartButton: RestartButton?
    var clearButton: ClearButton?
    
    init(stopWatchService: StopWatchService,
         timeToTextService: TimeToTextService = TimeToTextService(),
         startButton: StartButton = StartButton(),
         totalTimeLabel: TotalTimeLabel = TotalTimeLabel(hidden: true),
         timerHelpTextLabel: TimerHelpTextLabel = TimerHelpTextLabel(),
         lapTimeTable: LapTimeTable = LapTimeTable(hidden: true),
         fadeOverlayView: FadeOverlayView = FadeOverlayView(),
         bottomDividerLabel: DividerLabel = DividerLabel(hidden: true),
         topDividerLabel: DividerLabel = DividerLabel(hidden: true)) {
        
        self.stopWatchService = stopWatchService
        self.timeToTextService = timeToTextService
        self.startButton = startButton
        self.totalTimeLabel = totalTimeLabel
        self.timerHelpTextLabel = timerHelpTextLabel
        self.lapTimeTable = lapTimeTable
        self.fadeOverlayView = fadeOverlayView
        self.bottomDividerLabel = bottomDividerLabel
        self.topDividerLabel = topDividerLabel
        
        super.init(nibName: nil, bundle: nil)
        
        startButton.delegate = self
        stopWatchService.delegates.append(self)
        
        setColoration()
        
        addSubviews([totalTimeLabel, lapTimeTable, fadeOverlayView, timerHelpTextLabel,
                     bottomDividerLabel, topDividerLabel, startButton])
        addConstraints()
        
        lapTimeTable.setRowHeightBySuperview(_superview: self.view)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotificationOfDarkModeFlipped), name: Notification.Name(rawValue: Constants.notificationOfDarkModeToggle), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.isUserInteractionEnabled = true
    }
    
    func addConstraints() {
        DashboardViewControllerConstraints.positionStartButton(startButton: startButton)
        DashboardViewControllerConstraints.positionTotalTimeLabel(totalTimeLabel: totalTimeLabel)
        DashboardViewControllerConstraints.positionTimerHelpTextLabel(timerHelpTextLabel: timerHelpTextLabel)
        DashboardViewControllerConstraints.positionLapTimeTable(lapTimeTable: lapTimeTable, totalTimeLabel: totalTimeLabel)
        DashboardViewControllerConstraints.positionFadeOverlayView(fadeOverlayView: fadeOverlayView, lapTimeTable: lapTimeTable)
        DashboardViewControllerConstraints.positionBottomDividerLabel(dividerLabel: bottomDividerLabel, lapTimeTable: lapTimeTable)
        DashboardViewControllerConstraints.positionTopDividerLabel(dividerLabel: topDividerLabel, lapTimeTable: lapTimeTable)
    }
}

extension DashboardViewController: StartButtonDelegate {
    func onStartTap(sender: StartButton) {
        sender.hide()
        
        totalTimeLabel.show()
        lapTimeTable.show()
        topDividerLabel.show()
        bottomDividerLabel.show()
        
        timerHelpTextLabel.showBriefly()
        
        stopWatchService.start()
    }
}

extension DashboardViewController: StopWatchServiceDelegate {
    func stopWatchStarted() {
        DispatchQueue.main.async {
            self.lapTimeTable.setLapData(lapData: self.stopWatchService.lapTimes.reversed())
            self.lapTimeTable.reloadData()
        }
    }
    
    func stopWatchIntervalElapsed(totalTimeElapsed: TimeInterval) {
        DispatchQueue.main.async {
            self.totalTimeLabel.setText(time: self.timeToTextService.timeAsSingleString(inputTime: totalTimeElapsed))
            self.lapTimeTable.setLapData(lapData: self.stopWatchService.lapTimes.reversed())
            self.lapTimeTable.reloadCurrentLapRow()
        }
    }
    
    func stopWatchStopped() {
        if Constants.storedSettings.bool(forKey: SettingsService.vibrateOnClearKey) {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
        totalTimeLabel.hide()
        lapTimeTable.hide()
        bottomDividerLabel.hide()
        topDividerLabel.hide()
        
        startButton.show()
        
        lapTimeTable.clearLapData()        
    }
    
    func stopWatchPaused() {
        if Constants.storedSettings.bool(forKey: SettingsService.vibrateOnPauseKey) {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
//        create clear button
//        create restart button
    }
    
    func stopWatchRestarted() {}
    
    // TODO: UNTESTED; also, right place for this?
    func stopWatchLapStored(lapTime: Double, lapNumber: Int, totalTime: Double) {
        if Constants.storedSettings.bool(forKey: SettingsService.vibrateOnLapKey) {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
        timerHelpTextLabel.hide()
    }
}

extension DashboardViewController: RespondsToThemeChange {
    func handleNotificationOfDarkModeFlipped(notification: Notification) {
        let value = notification.userInfo?["value"] as! Bool
        
        setColoration(darkModeEnabled: value)
    }
    
    func setColoration(darkModeEnabled: Bool = Constants.storedSettings.bool(forKey: SettingsService.useDarkModeKey), animationDuration: Double = 0.0) {
        if darkModeEnabled {
            self.view.backgroundColor = Constants.colorPalette["black"]
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            self.view.backgroundColor = Constants.colorPalette["white"]
            UIApplication.shared.statusBarStyle = .default
        }
    }
}
