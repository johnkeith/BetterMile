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
    let settingsViewAnimationDuration = 0.5

    let advancedSettingsText = "Settings"
    let defaultTotalTimeLblText = "Total 00:00.00"
    let clearAlertMessage = "Are you sure you want to end your run?"
    
    let container = UIView()
    
    let totalTimeLbl = UILabel()
    let lapTimeLbl = LapTimeLabel()
    let lapLbl = UILabel()
    let blurOverlay = BlurOverlayView()
    let settingsView = SettingsView()
    
    var clearBarBtn: UIBarButtonItem!
    var rightBarBtn: UIBarButtonItem!
    var advancedBarBtn: UIBarButtonItem!
    var lapTimesBarBtn: UIBarButtonItem!
    
    var pingIntervalBeforeSettingsShown: Int!
    
    var doubleTapRecognizer: UITapGestureRecognizer! // TODO: FIX
    
//  DI
    var stopWatchSrv: StopWatchService
    var animationSrv: AnimationService
    var timeToTextSrv: TimeToTextService
    var speechSrv: SpeechService
    var helpText: TimerHelpTextLabel
    
    var fgColor: UIColor? {
        didSet {
            totalTimeLbl.textColor = fgColor
            lapTimeLbl.textColor = fgColor
            lapLbl.textColor = fgColor
            clearBarBtn.tintColor = fgColor
            rightBarBtn.tintColor = fgColor
            advancedBarBtn.tintColor = fgColor
            lapTimesBarBtn.tintColor = fgColor
        }
    }
    var bgColor: UIColor? {
        didSet {
            self.view.backgroundColor = bgColor
        }
    }
    var usesDarkMode: Bool = Constants.storedSettings.bool(forKey: SettingsService.darkModeKey) {
        didSet {
            self.setColorConstants()
            self.configNavBar()
        }
    }
    
    init(stopWatchSrv: StopWatchService = StopWatchService(),
         animationSrv: AnimationService = AnimationService(),
         timeToTextSrv: TimeToTextService = TimeToTextService(),
         speechSrv: SpeechService = SpeechService()) {
        self.stopWatchSrv = stopWatchSrv
        self.animationSrv = animationSrv
        self.timeToTextSrv = timeToTextSrv
        self.speechSrv = speechSrv
        self.helpText = TimerHelpTextLabel(hidden: true, animationService: animationSrv)
        
        super.init(nibName: nil, bundle: nil)
        
        advancedBarBtn = UIBarButtonItem(title: advancedSettingsText, style: .plain, target: self, action: #selector(onAdvancedSettingsTap))
        clearBarBtn = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(onClearTap))
        rightBarBtn = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(onStartTap))
        lapTimesBarBtn = UIBarButtonItem(title: "Lap Times", style: .plain, target: self, action: #selector(onLapTableTap))
        
        stopWatchSrv.delegate = self
        settingsView.saveDelegate = self

        view.backgroundColor = Constants.colorWhite
        
        addSubviews([container, helpText])
        
        container.addSubview(lapLbl)
        container.addSubview(totalTimeLbl)
        container.addSubview(lapTimeLbl)
        
        configContainer()
        configLapLbl()
        configTotalTimeLbl()
        configLapTimeLbl()
        configHelpText()
        
        self.navigationItem.leftBarButtonItem = clearBarBtn
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightBarBtn

        setColorConstants()

        NotificationCenter.default.addObserver(self, selector: #selector(self.onNotificationOfDarkModeToggle), name: Notification.Name(rawValue: Constants.notificationOfDarkModeToggle), object: nil)
        
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
    
        setStatusBarStyle()
        
        if let lapTime = self.stopWatchSrv.lapTimes.last {
            self.setLapTimeLblText(lapTime: lapTime)
        }
        
        configNavBar()
        
        animationSrv.animateWithSpring(lapLbl, fromAlphaZero: true)
        animationSrv.animateWithSpring(totalTimeLbl, duration: 0.8, fromAlphaZero: true)
        animationSrv.animateWithSpring(lapTimeLbl, duration: 0.8, fromAlphaZero: true)
    }
    
    @objc func onNotificationOfDarkModeToggle() {
        print("DARK MODE TOGGLED")
        usesDarkMode = Constants.storedSettings.bool(forKey: SettingsService.darkModeKey)
        setStatusBarStyle()
    }
    
    @objc func onAdvancedSettingsTap() {
        if settingsView.isHidden {
            if Constants.storedSettings.bool(forKey: SettingsService.intervalKey) {
               pingIntervalBeforeSettingsShown = Constants.storedSettings.integer(forKey: SettingsService.intervalAmountKey)
            }
            animationSrv.animateFadeInView(blurOverlay, duration: 0.1)
            animationSrv.animateMoveVerticallyFromOffscreenBottom(settingsView, duration: settingsViewAnimationDuration)
        }
    }
    
    @objc func onPauseTap() {
        self.navigationItem.rightBarButtonItem?.title = "Resume"
        self.navigationItem.rightBarButtonItem?.action = #selector(onRestartTap)
        
        stopWatchSrv.pause()
    }
    
    @objc func onStartTap() {
        stopWatchSrv.start()
        
        helpText.showBriefly()
        
        setLapLblText(lapCount: self.stopWatchSrv.lapTimes.count)
        
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        
        self.navigationItem.leftBarButtonItem = clearBarBtn
        self.navigationItem.rightBarButtonItem?.title = "Pause"
        self.navigationItem.rightBarButtonItem?.action = #selector(onPauseTap)
    }
    
    @objc func onRestartTap() {
        self.navigationItem.rightBarButtonItem?.title = "Pause"
        self.navigationItem.rightBarButtonItem?.action = #selector(onPauseTap)
        
        stopWatchSrv.restart()
    }
    
    //    TODO: UNTESTED
    @objc func onLapTableTap() {
        let lapTableController = LapTableController(stopWatchSrv: stopWatchSrv)
        
        self.navigationController?.pushViewController(lapTableController, animated: true)
    }
    
    //    TODO: UNTESTED
    @objc func onClearTap() {
        let clearAlertConfirmAction = UIAlertAction(title: "Clear", style: .destructive, handler: { (action) in
            self.stopWatchSrv.stop()
            
            DispatchQueue.main.async {
                self.animationSrv.animateTextChange(self.lapLbl, duration: 0.8)
                self.animationSrv.animateTextChange(self.totalTimeLbl, duration: 0.8)
                self.animationSrv.animateTextChange(self.lapTimeLbl, duration: 0.8)
                
                self.totalTimeLbl.text = self.defaultTotalTimeLblText
                self.lapLbl.text = "00"
                self.lapTimeLbl.text = self.lapTimeLbl.defaultText
            }
            
            self.navigationItem.rightBarButtonItem?.title = "Start"
            self.navigationItem.rightBarButtonItem?.action = #selector(self.onStartTap)
            self.navigationItem.leftBarButtonItem?.isEnabled = false
        })
        
        let clearAlertCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in })
        
        let clearAlert = UIAlertController(title: "Clear Run", message: clearAlertMessage, preferredStyle: .alert)
        clearAlert.addAction(clearAlertCancelAction)
        clearAlert.addAction(clearAlertConfirmAction)
        
        self.present(clearAlert, animated: true, completion: nil)
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

    // TODO: UNTESTED
    func notifyWithVibrationIfEnabled() {
        if Constants.storedSettings.bool(forKey: SettingsService.vibrationNotificationsKey) {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    func notifyWithVoiceIfEnabled(lapTime: Double, lapNumber: Int) {
        let shouldSpeakLap = Constants.storedSettings.bool(forKey: SettingsService.previousLapTimeKey)
        let shouldSpeakAverage = Constants.storedSettings.bool(forKey: SettingsService.averageLapTimeKey)
        let shouldSpeakMilePace = Constants.storedSettings.bool(forKey: SettingsService.milePaceKey)
        
        var sentanceToSpeak = ""
        
        if shouldSpeakLap {
            let timeTuple = timeToTextSrv.timeAsMultipleStrings(inputTime: lapTime)
            let lapNumberOrdinalized = "\(lapNumber)\(Constants.ordinalSuffixForNumber(number: lapNumber))"
            let previousLapTime = speechSrv.convertTimeTupleToString(timeTuple)
            
            sentanceToSpeak += "\(lapNumberOrdinalized) lap \(previousLapTime)."
        }
        
        if shouldSpeakAverage && lapNumber > 1{
            let averageLapTime = StopWatchService.calculateAverageLapTime(laps: stopWatchSrv.completedLapTimes())
            let averageLapTimeTuple = timeToTextSrv.timeAsMultipleStrings(inputTime: averageLapTime)
            let averageLapTimeString = speechSrv.convertTimeTupleToString(averageLapTimeTuple)
            
            sentanceToSpeak += "Average \(averageLapTimeString)."
        }
        
        if shouldSpeakMilePace && stopWatchSrv.wasMileCompleted() {
            let mileNumber = stopWatchSrv.completedMiles()
            let milePace = stopWatchSrv.calculateMilePace()
            let milePaceTuple = timeToTextSrv.timeAsMultipleStrings(inputTime: milePace)
            let milePaceString = speechSrv.convertTimeTupleToString(milePaceTuple)
            
            sentanceToSpeak += "Mile \(mileNumber) \(milePaceString)"
        }
        
        speechSrv.textToSpeech(text: sentanceToSpeak)
        speechSrv.voiceQueue.append(SpeechTypes.SpeakAfterLap)
    }
    
    // TODO: UNTESTED
    func notifyPaused() {
        let shouldSpeak = Constants.storedSettings.bool(forKey: SettingsService.speakStartStopKey)
        
        if shouldSpeak {
            speechSrv.speakTimerPaused()
        }
    }
    
    // TODO: UNTESTED
    func notifyResumed() {
        let shouldSpeak = Constants.storedSettings.bool(forKey: SettingsService.speakStartStopKey)
        
        if shouldSpeak {
            speechSrv.speakTimerRestarted()
        }
    }
    
    // TODO: UNTESTED
    func notifyStarted() {
        let shouldSpeak = Constants.storedSettings.bool(forKey: SettingsService.speakStartStopKey)
        
        if shouldSpeak {
            speechSrv.speakTimerStarted()
        }
    }
    
    // TODO: UNTESTED
    func notifyTimerCleared() {
        let shouldSpeak = Constants.storedSettings.bool(forKey: SettingsService.speakStartStopKey)
        
        if shouldSpeak {
            speechSrv.speakTimerCleared()
        }
    }
    
    private func setColorConstants() {
        fgColor = usesDarkMode ? Constants.colorWhite : Constants.colorBlack
        bgColor = usesDarkMode ? Constants.colorBlack : Constants.colorWhite
    }
    
    private func setStatusBarStyle() {
        UIApplication.shared.statusBarStyle = usesDarkMode ? .lightContent : .default
    }

    private func configToolbar() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        advancedBarBtn.tintColor = fgColor
        lapTimesBarBtn.tintColor = fgColor
        
        self.toolbarItems = [advancedBarBtn, spacer, lapTimesBarBtn]
    }
    
    private func configNavBar() {
        clearBarBtn.tintColor = fgColor
        rightBarBtn.tintColor = fgColor
        
        self.navigationController?.navigationBar.barStyle = usesDarkMode ? .blackTranslucent : .default
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = bgColor
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.view.backgroundColor = bgColor
        self.navigationController?.navigationBar.tintColor = bgColor
        self.navigationController?.navigationBar.barTintColor = bgColor
        
        self.navigationController?.toolbar!.barStyle = usesDarkMode ? .blackTranslucent : .default
        self.navigationController?.toolbar!.isTranslucent = true
        self.navigationController?.toolbar!.backgroundColor = bgColor
        self.navigationController?.toolbar!.barTintColor = bgColor
        
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.toolbar!.setShadowImage(UIImage(), forToolbarPosition: .bottom)
        self.navigationController?.view.addSubview(blurOverlay)
        self.navigationController?.view.addSubview(settingsView)
        settingsView.configConstraints()
        configBlurOverlay()
        configToolbar()
    }
    
    private func askForReview() {
        if #available(iOS 10.3, *) {
            let key = Constants.appRunTimes
            let numberOfRuns = Constants.storedSettings.integer(forKey: key)
            
            if numberOfRuns > 5 {
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    private func configBlurOverlay() {
        blurOverlay.addBlurEffect()
    }
    
    private func configContainer() {
        let parentHeight = container.superview!.frame.height
        let height = (parentHeight / 3) + (parentHeight / 5)
        
        container.snp.makeConstraints { make in
            make.width.equalTo(container.superview!)
            make.height.equalTo(height)
            make.center.equalTo(container.superview!)
        }
        
        container.layoutIfNeeded()
    }
    
    private func configTotalTimeLbl() {
        totalTimeLbl.isHidden = true
        totalTimeLbl.text = defaultTotalTimeLblText
        totalTimeLbl.font = Constants.responsiveDigitFont
        totalTimeLbl.adjustsFontSizeToFitWidth = true
        totalTimeLbl.numberOfLines = 1
        totalTimeLbl.baselineAdjustment = .alignCenters
        totalTimeLbl.textAlignment = .center
        totalTimeLbl.textColor = Constants.colorBlack
        
        let offset = totalTimeLbl.superview!.frame.width / 10
        
        totalTimeLbl.snp.makeConstraints { make in
            make.width.equalTo(totalTimeLbl.superview!).offset(-offset)
            make.height.equalTo(self.view.frame.height / 10)
            make.centerX.equalTo(totalTimeLbl.superview!)
            make.bottom.equalTo(lapTimeLbl.snp.top)
        }
    }
    
    private func configLapTimeLbl() {
        let offset = lapTimeLbl.superview!.frame.width / 10
        
        lapTimeLbl.snp.makeConstraints { make in
            make.width.equalTo(lapTimeLbl.superview!).offset(-offset)
            make.height.equalTo(self.view.frame.height / 10)
            make.centerX.equalTo(lapTimeLbl.superview!)
            make.bottom.equalTo(container.snp.bottom)
        }
        
        lapTimeLbl.layoutIfNeeded()
    }
    
    private func configLapLbl() {
        lapLbl.isHidden = true
        lapLbl.text = "00"
        lapLbl.textAlignment = .center
        lapLbl.textColor = Constants.colorBlack
        lapLbl.baselineAdjustment = .alignCenters

        lapLbl.snp.makeConstraints { make in
            make.width.equalTo(lapLbl.superview!).offset(-Constants.defaultMargin * 2)
            make.height.equalTo(self.view.frame.height / 3)
            make.centerX.equalTo(lapLbl.superview!)
            make.top.equalTo(container.snp.top)
        }
        
        lapLbl.layoutIfNeeded()
        
        lapLbl.adjustsFontSizeToFitWidth = true
        lapLbl.numberOfLines = 1
        lapLbl.font = Constants.responsiveDigitFont        
    }
    
    private func configHelpText() {
        helpText.snp.makeConstraints { make in
            make.bottom.equalTo(lapLbl.snp.top).offset(-Constants.defaultMargin)
            make.centerX.equalTo(helpText.superview!)
            make.width.equalTo(helpText.superview!)
        }
    }
}


extension SingleViewController: StopWatchServiceDelegate {
    // TODO: UNTESTED
    func stopWatchStarted() {
        attachDoubleTapRecognizer()
        
        if stopWatchSrv.lapTimes.count == 1 {
            notifyStarted()
        }
    }
    
    // TODO: UNTESTED
    func stopWatchIntervalElapsed(totalTimeElapsed: TimeInterval) {
        DispatchQueue.main.async {
            if let lapTime = self.stopWatchSrv.lapTimes.last {
                self.setLapTimeLblText(lapTime: lapTime)
                self.setTotalTimeLblText(totalTimeElapsed: totalTimeElapsed)
            }
        }
    }
    
    // TODO: UNTESTED
    func stopWatchLapStored(lapTime: Double, lapNumber: Int, totalTime: Double) {
        self.setLapLblText(lapCount: self.stopWatchSrv.lapTimes.count)
        
        notifyWithVibrationIfEnabled()
        notifyWithVoiceIfEnabled(lapTime: lapTime, lapNumber: lapNumber)
    }
    
    // TODO: UNTESTED
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
    
    // TODO: UNTESTED
    func stopWatchStopped() {
        notifyTimerCleared()
    }
    
    // TODO: UNTESTED
    func stopWatchPaused() {
        notifyPaused()
    }
    
    // TODO: UNTESTED
    func stopWatchRestarted() {
        notifyStarted()
    }
}

extension SingleViewController {
    // TODO: UNTESTED
    func attachDoubleTapRecognizer() {
        doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewDoubleTapped))
        doubleTapRecognizer.numberOfTapsRequired = 2
        
        view.addGestureRecognizer(doubleTapRecognizer)
    }

    // TODO: UNTESTED
    @objc func viewDoubleTapped() {
        if stopWatchSrv.timerRunning {
            stopWatchSrv.lap()
            animationSrv.enlargeBriefly(lapLbl)
        }
    }
}

extension SingleViewController: SettingsViewDelegate {
    func onSave() {
        animationSrv.animateFadeOutView(blurOverlay, duration: 0.1)
        animationSrv.animateMoveVerticallyToOffscreenBottom(settingsView, duration: settingsViewAnimationDuration)
        
        let pingSetting = Constants.storedSettings.bool(forKey: SettingsService.intervalKey)
        let pingSettingAmount = Constants.storedSettings.integer(forKey: SettingsService.intervalAmountKey)
        
        if !pingSetting && stopWatchSrv.pingTimer != nil {
            stopWatchSrv.pingTimer.invalidate()
        } else if pingSetting && stopWatchSrv.pingTimer != nil &&
            pingIntervalBeforeSettingsShown != pingSettingAmount &&
            stopWatchSrv.timerRunning {
            
            stopWatchSrv.pingTimer.invalidate()
            stopWatchSrv.pingTimer = nil
            stopWatchSrv.startPingInterval()
        } else if pingSetting && stopWatchSrv.pingTimer == nil &&
            stopWatchSrv.timerRunning {
            stopWatchSrv.startPingInterval()
        }
        
        pingIntervalBeforeSettingsShown = nil
    }
}

