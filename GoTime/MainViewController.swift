//
//  ViewController.swift
//  GoTime
//
//  Created by John Keith on 1/17/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit
import AudioToolbox

class MainViewController: UIViewController {
    var startButton: StartButton
    var totalTimeLabel: TotalTimeLabel
    var lapTimeTable: LapTimeTable
    var dividerLabel: DividerLabel
    var timerHelpTextLabel: TimerHelpTextLabel
    var openSettingsButton: OpenSettingsButton
    var settingsOverlay: SettingsOverlay
    var fadeOverlayView: FadeOverlayView
    var voiceNotificationsButton: VoiceNotificationsButton
    var vibrationNotificationsButton: VibrationNotificationsButton
    var themeButton: ThemeButton
    var previousLapTimeButton: PreviousLapTimeButton
    var averageLapTimeButton: AverageLapTimeButton
    var totalTimeButton: TotalTimeButton
    var vibrateOnLapButton: VibrateOnLapButton
    var vibrateOnPauseButton: VibrateOnPauseButton
    var vibrateOnClearButton: VibrateOnClearButton
    
    let settingsButtonCollection: [SettingsButton]
    
    var stopWatchService: StopWatchService
    var timeToTextService: TimeToTextService
    
    var doubleTapRecognizer: UITapGestureRecognizer! // TODO: SMELLY
    var longPressRecognizer: UILongPressGestureRecognizer! // TODO: SMELLY
    
    // TODO: SMELLY, SMELLY, SMELLY
    init(startButton: StartButton = StartButton(),
         totalTimeLabel: TotalTimeLabel = TotalTimeLabel(hidden: true),
         lapTimeTable: LapTimeTable = LapTimeTable(),
         stopWatchService: StopWatchService = StopWatchService(),
         timeToTextService: TimeToTextService = TimeToTextService(),
         dividerLabel: DividerLabel = DividerLabel(),
         timerHelpTextLabel: TimerHelpTextLabel = TimerHelpTextLabel(),
         openSettingsButton: OpenSettingsButton = OpenSettingsButton(),
         settingsOverlay: SettingsOverlay = SettingsOverlay(),
         fadeOverlayView: FadeOverlayView = FadeOverlayView(),
         voiceNotificationsButton: VoiceNotificationsButton = VoiceNotificationsButton(),
         vibrationNotificationsButton: VibrationNotificationsButton = VibrationNotificationsButton(),
         themeButton: ThemeButton = ThemeButton(),
         previousLapTimeButton: PreviousLapTimeButton = PreviousLapTimeButton(),
         averageLapTimeButton: AverageLapTimeButton = AverageLapTimeButton(),
         totalTimeButton: TotalTimeButton = TotalTimeButton(),
         vibrateOnLapButton: VibrateOnLapButton = VibrateOnLapButton(),
         vibrateOnPauseButton: VibrateOnPauseButton = VibrateOnPauseButton(),
         vibrateOnClearButton: VibrateOnClearButton = VibrateOnClearButton()) {
        
        self.startButton = startButton
        self.totalTimeLabel = totalTimeLabel
        self.lapTimeTable = lapTimeTable
        self.dividerLabel = dividerLabel
        self.timerHelpTextLabel = timerHelpTextLabel
        self.openSettingsButton = openSettingsButton
        self.settingsOverlay = settingsOverlay
        self.fadeOverlayView = fadeOverlayView
        
        self.voiceNotificationsButton = voiceNotificationsButton
        self.vibrationNotificationsButton = vibrationNotificationsButton
        self.themeButton = themeButton
        self.previousLapTimeButton = previousLapTimeButton
        self.averageLapTimeButton = averageLapTimeButton
        self.totalTimeButton = totalTimeButton
        self.vibrateOnLapButton = vibrateOnLapButton
        self.vibrateOnPauseButton = vibrateOnPauseButton
        self.vibrateOnClearButton = vibrateOnClearButton
        
        self.settingsButtonCollection = [
            voiceNotificationsButton,
            vibrationNotificationsButton,
            themeButton,
            previousLapTimeButton,
            averageLapTimeButton,
            totalTimeButton,
            vibrateOnLapButton,
            vibrateOnPauseButton,
            vibrateOnClearButton]
        
        self.stopWatchService = stopWatchService
        self.timeToTextService = timeToTextService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.delegate = self
        stopWatchService.delegate = self
        openSettingsButton.delegate = self
        settingsOverlay.delegate = self
        
        setBackgroundColor()
        addSubviews()
        applyConstraints()

        self.view.isUserInteractionEnabled = true
    }
    
    func setBackgroundColor() {
        self.view.backgroundColor = UIColor.white
    }
    
    func addSubviews() {
        self.view.addSubview(startButton)
        self.view.addSubview(totalTimeLabel)
        self.view.addSubview(lapTimeTable)
        self.view.addSubview(dividerLabel)
        self.view.addSubview(timerHelpTextLabel)
        self.view.addSubview(openSettingsButton)
        self.view.addSubview(fadeOverlayView)
        self.view.addSubview(settingsOverlay)
        self.view.addSubview(voiceNotificationsButton)
        self.view.addSubview(vibrationNotificationsButton)
        self.view.addSubview(themeButton)
        self.view.addSubview(previousLapTimeButton)
        self.view.addSubview(averageLapTimeButton)
        self.view.addSubview(totalTimeButton)
        self.view.addSubview(vibrateOnLapButton)
        self.view.addSubview(vibrateOnPauseButton)
        self.view.addSubview(vibrateOnClearButton)
    }
    
    func applyConstraints() { // TODO: UNTESTED
        MainViewControllerConstraints.positionStartButton(startButton: startButton)
        MainViewControllerConstraints.positionTotalTimeLabel(totalTimeLabel: totalTimeLabel)
        MainViewControllerConstraints.positionLapTimeTable(lapTimeTable: lapTimeTable, totalTimeLabel: totalTimeLabel)
        MainViewControllerConstraints.positionDividerLabel(dividerLabel: dividerLabel, lapTimeTable: lapTimeTable)
        MainViewControllerConstraints.positionTimerHelpTextLabel(timerHelpTextLabel: timerHelpTextLabel)
        MainViewControllerConstraints.positionOpenSettingsButton(openSettingsButton: openSettingsButton)
        MainViewControllerConstraints.positionSettingsOverlay(settingsOverlay: settingsOverlay)
        MainViewControllerConstraints.positionFadeOverlayView(fadeOverlayView: fadeOverlayView, lapTimeTable: lapTimeTable)
        MainViewControllerConstraints.positionVoiceNotificationsButton(voiceNotificationsButton: voiceNotificationsButton, openSettingsButton: openSettingsButton)
        MainViewControllerConstraints.positionVibrationNotificationsButton(vibrationNotificationsButton: vibrationNotificationsButton, openSettingsButton: openSettingsButton)
        MainViewControllerConstraints.positionThemeButton(themeButton: themeButton, openSettingsButton: openSettingsButton)
        MainViewControllerConstraints.positionPreviousLapTimeButton(previousLapTimeButton: previousLapTimeButton, openSettingsButton: openSettingsButton)
        MainViewControllerConstraints.positionAverageLapTimeButton(averageLapTimeButton: averageLapTimeButton, openSettingsButton: openSettingsButton)
        MainViewControllerConstraints.positionTotalTimeButton(totalTimeButton: totalTimeButton, openSettingsButton: openSettingsButton)
        MainViewControllerConstraints.positionVibrateOnLapButton(vibrateOnLapButton: vibrateOnLapButton, openSettingsButton: openSettingsButton)
        MainViewControllerConstraints.positionVibrateOnPauseButton(vibrateOnPauseButton: vibrateOnPauseButton, openSettingsButton: openSettingsButton)
        MainViewControllerConstraints.positionVibrateOnClearButton(vibrateOnClearButton: vibrateOnClearButton, openSettingsButton: openSettingsButton)
    }
    
    // MARK - REMOVE, ONLY FOR DEBUGGING
    func setBordersForView(targetView: AnyObject, borderWidth: CGFloat = CGFloat(2.0), borderRadius: CGFloat = CGFloat(4.0), borderColor: CGColor = UIColor.blue.cgColor) {
        targetView.layer.borderWidth = borderWidth
        targetView.layer.cornerRadius = borderRadius
        targetView.layer.borderColor = borderColor
    }
}

// MARK: Gesture recognizer functions
extension MainViewController {
    func refreshLapTableData() {
        DispatchQueue.main.async {
            // TODO: UNTESTED (the reversing)
            self.lapTimeTable.setLapData(lapData: self.stopWatchService.lapTimes.reversed())
        }
    }
    
    func viewDoubleTapped() {
        stopWatchService.timerRunning ? stopWatchService.lap() : stopWatchService.restart()
        
        refreshLapTableData()
    }
    
    func attachDoubleTapRecognizer() {
        doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewDoubleTapped))
        doubleTapRecognizer.numberOfTapsRequired = 2
        
        self.view.addGestureRecognizer(doubleTapRecognizer)
    }
    
    func viewLongPressed(sender: UILongPressGestureRecognizer) {
        if(sender.state == UIGestureRecognizerState.ended) {
            if(stopWatchService.timerRunning) {
                stopWatchService.pause()
                refreshLapTableData()
            } else {
                stopWatchService.stop()
            }
        }
    }
    
    func attachLongPressRecognizer() {
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.viewLongPressed))
        longPressRecognizer.minimumPressDuration = 0.6
        
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    func removeViewRecognizers() {
        if(doubleTapRecognizer != nil) {
            self.view.removeGestureRecognizer(doubleTapRecognizer)
        }
        
        if(longPressRecognizer != nil) {
            self.view.removeGestureRecognizer(longPressRecognizer)
        }
    }
}

extension MainViewController: StartButtonDelegate {
    func onStartTap(sender: StartButton) {
        sender.hide()
        
        totalTimeLabel.show()
        lapTimeTable.show()
        dividerLabel.show()
        fadeOverlayView.show()
        timerHelpTextLabel.showBriefly()
        
        attachDoubleTapRecognizer()
        attachLongPressRecognizer()

        stopWatchService.start()
    }
}

extension MainViewController: StopWatchServiceDelegate {
    func stopWatchIntervalElapsed(totalTimeElapsed: TimeInterval) {
        totalTimeLabel.text = timeToTextService.timeAsSingleString(inputTime: totalTimeElapsed)
        
        DispatchQueue.main.async {
            self.lapTimeTable.setLapData(lapData: self.stopWatchService.lapTimes.reversed())
        }
    }
    
    func stopWatchStopped() {
        removeViewRecognizers()
        
        totalTimeLabel.hide()
        dividerLabel.hide()
        lapTimeTable.hide()
        fadeOverlayView.hide()

        lapTimeTable.clearLapData()
        
        startButton.show()
    }
    
    func stopWatchPaused() {
        
    }
    
    func stopWatchRestarted() {
        
    }
    
    // TODO: UNTESTED; also, right place for this?
    func stopWatchLapStored() {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        timerHelpTextLabel.hide()
    }
}

extension MainViewController: OpenSettingsButtonDelegate {
    // TODO: UNTESTED
    func onSettingsTap(sender: OpenSettingsButton) {
        settingsOverlay.show()
        
//        for button in settingsButtonCollection {
//            button.animateButtonFromOrigin()
//        }
        voiceNotificationsButton.animateButtonFromOrigin()
        previousLapTimeButton.animateButtonFromOrigin()
        averageLapTimeButton.animateButtonFromOrigin()
    }
}

extension MainViewController: SettingsOverlayDelegate {
    func onSettingsOverlayHide() {
        for button in settingsButtonCollection {
            button.animateButtonToOrigin()
        }
    }
}

