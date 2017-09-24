//
//  SingleViewController.swift
//  GoTime
//
//  Created by John Keith on 5/1/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit
import AudioToolbox
import SnapKit
import StoreKit

class SingleViewController: UIViewController {
//  NON-DI
    
    let vibrationOnText = "Vibrate On"
    let vibrationOffText = "Vibrate Off"
    let voiceOnText = "Voice On"
    let voiceOffText = "Voice Off"
    let defaultTotalTimeLblText = "Total 00:00.00"
    let clearAlertMessage = "Are you sure you want to end your run?"
    
    let container = UIView()
    
    let totalTimeLbl = UILabel()
    let lapTimeLbl = LapTimeLabel()
    let lapLbl = UILabel()
    let blurOverlay = BlurOverlayView()
    let lapTableBtn = UIButton()
    
    var vibrationBarBtn: UIBarButtonItem!
    var voiceBarBtn: UIBarButtonItem!
    var clearBarBtn: UIBarButtonItem!
    var rightBarBtn: UIBarButtonItem!
    
    var doubleTapRecognizer: UITapGestureRecognizer! // TODO: FIX
    
    var fgClr: UIColor
    var bgClr: UIColor
    var btnFgClr: UIColor
    var btnBgClr: UIColor
//  DI
    var stopWatchSrv: StopWatchService
    var animationSrv: AnimationService
    var timeToTextSrv: TimeToTextService
    var speechSrv: SpeechService
    var settingsBtn: SettingsButton
    var helpText: TimerHelpTextLabel
    
    init(stopWatchSrv: StopWatchService = StopWatchService(),
         animationSrv: AnimationService = AnimationService(),
         timeToTextSrv: TimeToTextService = TimeToTextService(),
         speechSrv: SpeechService = SpeechService()) {
        self.stopWatchSrv = stopWatchSrv
        self.animationSrv = animationSrv
        self.timeToTextSrv = timeToTextSrv
        self.speechSrv = speechSrv
        self.settingsBtn = SettingsButton(blurOverlay: blurOverlay, animationSrv: animationSrv)
        self.helpText = TimerHelpTextLabel(hidden: true, animationService: animationSrv)
        
        fgClr = Constants.colorBlack
        bgClr = Constants.colorBackground
        btnFgClr = fgClr
        btnBgClr = UIColor.clear // Constants.colorPalette["BTNBG"]!
        
        super.init(nibName: nil, bundle: nil)
        
        vibrationBarBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(onVibrationNotificationsTap))
        voiceBarBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(onVoiceNotificationsTap))
        clearBarBtn = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(onClearTap))
        rightBarBtn = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(onStartTap))
        
        stopWatchSrv.delegate = self
        
        view.backgroundColor = Constants.colorWhite
        
        addSubviews([container, blurOverlay, lapTableBtn, helpText])
        
        container.addSubview(lapLbl)
        container.addSubview(totalTimeLbl)
        container.addSubview(lapTimeLbl)
        
        configContainer()
        configLapLbl()
        configTotalTimeLbl()
        configLapTimeLbl()
        configBlurOverlay()
        configLapTableBtn()
        configHelpText()
        
        self.navigationItem.rightBarButtonItem = rightBarBtn

        askForReview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("config(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
        
        if let lapTime = self.stopWatchSrv.lapTimes.last {
            self.setLapTimeLblText(lapTime: lapTime)
        }
        
        configNavBar()
        configToolbar()
        
        animationSrv.animateWithSpring(lapLbl, fromAlphaZero: true)
        animationSrv.animateWithSpring(totalTimeLbl, duration: 0.8, fromAlphaZero: true)
        animationSrv.animateWithSpring(lapTimeLbl, duration: 0.8, fromAlphaZero: true)
    }
    
    func configToolbar() {
        let vibrationState = Constants.storedSettings.bool(forKey: SettingsService.vibrationNotificationsKey)
        let voiceState = Constants.storedSettings.bool(forKey: SettingsService.voiceNotificationsKey)
        
        let vibrationTitle = vibrationState ? vibrationOnText : vibrationOffText
        let voiceTitle = voiceState ? voiceOnText : voiceOffText
        
        vibrationBarBtn.title = vibrationTitle
        voiceBarBtn.title = voiceTitle
        
        vibrationBarBtn.tintColor = Constants.colorBlack
        voiceBarBtn.tintColor = Constants.colorBlack
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        self.toolbarItems = [vibrationBarBtn, spacer, voiceBarBtn]
    }
    
    func configNavBar() {
        clearBarBtn.tintColor = Constants.colorBlack
        rightBarBtn.tintColor = Constants.colorBlack
        
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = Constants.colorWhite
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.view.backgroundColor = Constants.colorWhite
        self.navigationController?.navigationBar.tintColor = Constants.colorWhite
        self.navigationController?.navigationBar.barTintColor = Constants.colorWhite
        
        self.navigationController?.toolbar!.barStyle = .default
        self.navigationController?.toolbar!.isTranslucent = false
        self.navigationController?.toolbar!.backgroundColor = Constants.colorWhite
        self.navigationController?.toolbar!.barTintColor = Constants.colorWhite
    }
    
    func askForReview() {
        if #available(iOS 10.3, *) {
            let key = Constants.appRunTimes
            let numberOfRuns = Constants.storedSettings.integer(forKey: key)
            
            if numberOfRuns > 5 {
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    func configBlurOverlay() {
        blurOverlay.addBlurEffect()
    }
    
    func configContainer() {
        let parentHeight = container.superview!.frame.height
        let height = (parentHeight / 3) + (parentHeight / 5)
        
        container.snp.makeConstraints { make in
            make.width.equalTo(container.superview!)
            make.height.equalTo(height)
            make.center.equalTo(container.superview!)
        }
        
        container.layoutIfNeeded()
    }
    
    func configTotalTimeLbl() {
        totalTimeLbl.isHidden = true
        totalTimeLbl.text = defaultTotalTimeLblText
        totalTimeLbl.font = Constants.responsiveDigitFont
        totalTimeLbl.adjustsFontSizeToFitWidth = true
        totalTimeLbl.numberOfLines = 1
        totalTimeLbl.baselineAdjustment = .alignCenters
        totalTimeLbl.textAlignment = .center
        totalTimeLbl.textColor = fgClr
        
        let offset = totalTimeLbl.superview!.frame.width / 10
        
        totalTimeLbl.snp.makeConstraints { make in
            make.width.equalTo(totalTimeLbl.superview!).offset(-offset)
            make.height.equalTo(self.view.frame.height / 10)
            make.centerX.equalTo(totalTimeLbl.superview!)
            make.bottom.equalTo(lapTimeLbl.snp.top)
        }
    }
    
    func configLapTimeLbl() {
        let offset = lapTimeLbl.superview!.frame.width / 10
        
        lapTimeLbl.snp.makeConstraints { make in
            make.width.equalTo(lapTimeLbl.superview!).offset(-offset)
            make.height.equalTo(self.view.frame.height / 10)
            make.centerX.equalTo(lapTimeLbl.superview!)
            make.bottom.equalTo(container.snp.bottom)
        }
        
        lapTimeLbl.layoutIfNeeded()
    }
    
    func configLapLbl() {
        lapLbl.isHidden = true
        lapLbl.text = "00"
        lapLbl.textAlignment = .center
        lapLbl.textColor = fgClr
        lapLbl.baselineAdjustment = .alignCenters
        
        lapLbl.snp.makeConstraints { make in
            make.width.equalTo(lapLbl.superview!).offset(-Constants.defaultMargin * 2)
            make.height.equalTo(self.view.frame.height / 3)
            make.centerX.equalTo(lapLbl.superview!)
            make.top.equalTo(container.snp.top).offset(-Constants.defaultMargin)
        }
        
        lapLbl.layoutIfNeeded()
        
        lapLbl.adjustsFontSizeToFitWidth = true
        lapLbl.numberOfLines = 1
        lapLbl.font = Constants.responsiveDigitFont
    }
    
    func configLapTableBtn() {
        lapTableBtn.hide()
        
        lapTableBtn.setTitle("View lap times ›", for: UIControlState.normal)
        lapTableBtn.setTitleColor(fgClr, for: UIControlState.normal)
        
        lapTableBtn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        lapTableBtn.titleLabel?.textAlignment = .center
        
        lapTableBtn.addTarget(self, action: #selector(onLapTableTap), for: .touchDown)
        
        lapTableBtn.snp.makeConstraints { make in
            make.width.equalTo(lapTableBtn.superview!)
            make.top.equalTo(lapTimeLbl.snp.bottom).offset(Constants.defaultMargin)
        }
    }
    
    func configHelpText() {
        helpText.snp.makeConstraints { make in
            make.width.equalTo(helpText.superview!)
            make.top.equalTo(helpText.superview!).offset(Constants.defaultMargin)
        }
    }
    
    @objc func onPauseTap() {
        self.navigationItem.rightBarButtonItem?.title = "Resume"
        self.navigationItem.rightBarButtonItem?.action = #selector(onRestartTap)
        
        animationSrv.animateWithSpring(lapTableBtn, fromAlphaZero: true)
        
        stopWatchSrv.pause()
    }
    
    func setLapLblText(lapCount: Int) {
        let shouldPad = lapCount < 10
        let padding = shouldPad ? "0" : ""
        lapLbl.text = "\(padding)\(lapCount)"
    }
    
    func setTotalTimeLblText(totalTimeElapsed: TimeInterval) {
        self.totalTimeLbl.text = "Total \(self.timeToTextSrv.timeAsSingleString(inputTime: totalTimeElapsed))"
    }
    
    func setLapTimeLblText(lapTime: TimeInterval) {
        let lapTimeAsString = self.timeToTextSrv.timeAsSingleString(inputTime: lapTime)
        
        self.lapTimeLbl.setTextForLabel(lapTimeAsString)
    }

    @objc func onStartTap() {
        stopWatchSrv.start()
        
        helpText.showBriefly()
        
        setLapLblText(lapCount: self.stopWatchSrv.lapTimes.count)
        
        self.navigationItem.leftBarButtonItem = clearBarBtn
        self.navigationItem.rightBarButtonItem?.title = "Pause"
        self.navigationItem.rightBarButtonItem?.action = #selector(onPauseTap)
    }
    
    @objc func onRestartTap() {
        self.navigationItem.rightBarButtonItem?.title = "Pause"
        self.navigationItem.rightBarButtonItem?.action = #selector(onPauseTap)
        
        animationSrv.animateFadeOutView(lapTableBtn)
        
        stopWatchSrv.restart()
    }
    
    @objc func onLapTableTap() {
        let lapTableController = LapTableController(stopWatchSrv: stopWatchSrv)
        
        self.navigationController?.pushViewController(lapTableController, animated: true)
    }
    
    @objc func onClearTap() {
        let clearAlertConfirmAction = UIAlertAction(title: "Clear", style: .destructive, handler: { (action) in
            self.animationSrv.animateFadeOutView(self.lapTableBtn)
            self.stopWatchSrv.stop()
            
            DispatchQueue.main.async {
                self.animationSrv.animateTextChange(self.lapLbl, duration: 0.8)
                self.animationSrv.animateTextChange(self.totalTimeLbl, duration: 0.8)
                self.animationSrv.animateTextChange(self.lapTimeLbl, duration: 0.8)
                
                self.totalTimeLbl.text = self.defaultTotalTimeLblText
                self.lapLbl.text = "00"
                self.lapTimeLbl.text = self.lapTimeLbl.defaultText
            }
            
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem?.title = "Start"
            self.navigationItem.rightBarButtonItem?.action = #selector(self.onStartTap)
        })
        
        let clearAlertCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in })
        
        let clearAlert = UIAlertController(title: "Clear Run", message: clearAlertMessage, preferredStyle: .alert)
        clearAlert.addAction(clearAlertCancelAction)
        clearAlert.addAction(clearAlertConfirmAction)
        
        self.present(clearAlert, animated: true, completion: nil)
    }
    
    @objc func onVoiceNotificationsTap() {
        let newValue = handleSettingsToggle(key: SettingsService.voiceNotificationsKey)
        
        voiceBarBtn.title = newValue ? voiceOnText : voiceOffText
    }
    
    @objc func onVibrationNotificationsTap() {
        let newValue = handleSettingsToggle(key: SettingsService.vibrationNotificationsKey)
        
        vibrationBarBtn.title = newValue ? vibrationOnText : vibrationOffText
    }
    
    func handleSettingsToggle(key: String) -> Bool {
        let currentValue = Constants.storedSettings.bool(forKey: key)
        let newValue = !currentValue
        
        Constants.storedSettings.set(newValue, forKey: key)
        
        return newValue
    }
    
    func notifyWithVibrationIfEnabled() {
        if Constants.storedSettings.bool(forKey: SettingsService.vibrationNotificationsKey) {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    func notifyWithVoiceIfEnabled(lapTime: Double, lapNumber: Int) {
        let shouldSpeak = Constants.storedSettings.bool(forKey: SettingsService.voiceNotificationsKey)
        
        if shouldSpeak {
            let timeTuple = timeToTextSrv.timeAsMultipleStrings(inputTime: lapTime)
            let averageLapTime = StopWatchService.calculateAverageLapTime(laps: stopWatchSrv.completedLapTimes())
            let averageLapTimeTuple = timeToTextSrv.timeAsMultipleStrings(inputTime: averageLapTime)
            
            speechSrv.speakPreviousAndAverageLapTimes(previous: timeTuple, average: averageLapTimeTuple, lapNumber: lapNumber)
        }
    }
    
    func notifyPaused() {
        let shouldSpeak = Constants.storedSettings.bool(forKey: SettingsService.voiceNotificationsKey)
        
        if shouldSpeak {
            speechSrv.speakTimerPaused()
        }
    }
    
    func notifyResumed() {
        let shouldSpeak = Constants.storedSettings.bool(forKey: SettingsService.voiceNotificationsKey)
        
        if shouldSpeak {
            speechSrv.speakTimerRestarted()
        }
    }
    
    func notifyStarted() {
        let shouldSpeak = Constants.storedSettings.bool(forKey: SettingsService.voiceNotificationsKey)
        
        if shouldSpeak {
            speechSrv.speakTimerStarted()
        }
    }
    
    func notifyTimerCleared() {
        let shouldSpeak = Constants.storedSettings.bool(forKey: SettingsService.voiceNotificationsKey)
        
        if shouldSpeak {
            speechSrv.speakTimerCleared()
        }
    }
}


// MARK StopWatchServiceDelegate
extension SingleViewController: StopWatchServiceDelegate {
    func stopWatchStarted() {
        attachDoubleTapRecognizer()
        
        if stopWatchSrv.lapTimes.count == 1 {
            notifyStarted()
        }
    }
    
    func stopWatchIntervalElapsed(totalTimeElapsed: TimeInterval) {
        DispatchQueue.main.async {
            if let lapTime = self.stopWatchSrv.lapTimes.last {
                self.setLapTimeLblText(lapTime: lapTime)
                self.setTotalTimeLblText(totalTimeElapsed: totalTimeElapsed)
            }
        }
    }
    
    func stopWatchLapStored(lapTime: Double, lapNumber: Int, totalTime: Double) {
        self.setLapLblText(lapCount: self.stopWatchSrv.lapTimes.count)
        
        self.animationSrv.animateTextChange(self.lapTimeLbl, duration: 0.8)
        
        notifyWithVibrationIfEnabled()
        notifyWithVoiceIfEnabled(lapTime: lapTime, lapNumber: lapNumber)
    }
    
    func stopWatchLapRemoved() {
        let lapCount = stopWatchSrv.lapTimes.count
        var totalLapTime: Double
        var currentLap: Double
        
        if lapCount > 0 {
            totalLapTime = stopWatchSrv.calculateTotalLapsTime()
            currentLap = stopWatchSrv.lapTimes.last!
        } else {
            totalLapTime = 0.0
            currentLap = 0.0
        }
        
        self.setLapLblText(lapCount: lapCount)
        self.setTotalTimeLblText(totalTimeElapsed: totalLapTime)
        self.setLapTimeLblText(lapTime: currentLap)
    }
    
    func stopWatchStopped() {
        notifyTimerCleared()
    }
    
    func stopWatchPaused() {
        notifyPaused()
    }
    
    func stopWatchRestarted() {
        notifyStarted()
    }
}

// MARK Gestures
extension SingleViewController {
    func attachDoubleTapRecognizer() {
        doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewDoubleTapped))
        doubleTapRecognizer.numberOfTapsRequired = 2
        
        view.addGestureRecognizer(doubleTapRecognizer)
    }

    @objc func viewDoubleTapped() {
        if stopWatchSrv.timerRunning {
            stopWatchSrv.lap()
            animationSrv.enlargeBriefly(lapLbl)
        }
    }
}

