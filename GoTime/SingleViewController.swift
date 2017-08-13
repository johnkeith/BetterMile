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

class SingleViewController: UIViewController {
//  NON-DI
//    let shadowOpacity = Float(0.15)
    let shadowOpacity = Float(0.0)
    let startBtn = StartButton()
    let totalTimeLbl = UILabel()
    let lapTimeLbl = UILabel()
    let lapLbl = UILabel()
    let voiceNotificationsBtn = UIButton()
    let vibrationNotificationBtn = UIButton()
    let pauseBtn = UIButton()
    let clearBtn = UIButton()
    let restartBtn = UIButton()
    let lapTableBtn = UIButton()
    let helpText = TimerHelpTextLabel()
//    all that is needed is to create the help button and the like button and link those to the correct spots
    let helpBtn = UIButton()
    let likeBtn = LikeButton()
    let circle = UILabel()
    
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
    
    init(stopWatchSrv: StopWatchService = StopWatchService(),
         animationSrv: AnimationService = AnimationService(),
         timeToTextSrv: TimeToTextService = TimeToTextService(),
         speechSrv: SpeechService = SpeechService()) {
        self.stopWatchSrv = stopWatchSrv
        self.animationSrv = animationSrv
        self.timeToTextSrv = timeToTextSrv
        self.speechSrv = speechSrv
        
        fgClr = Constants.colorPalette["FG"]!
        bgClr = Constants.colorPalette["BG"]!
        btnFgClr = fgClr
        btnBgClr = bgClr // Constants.colorPalette["BTNBG"]!
        
        super.init(nibName: nil, bundle: nil)
        
        stopWatchSrv.delegate = self
        
        view.backgroundColor = bgClr
        
        addSubviews([startBtn, totalTimeLbl, lapLbl, voiceNotificationsBtn, pauseBtn, vibrationNotificationBtn, clearBtn, restartBtn, lapTableBtn, helpText, helpBtn, likeBtn, circle, lapTimeLbl])
        
        configStartBtn()
        configTotalTimeLbl()
        configLapLbl()
        configVoiceNotificationsBtn()
        configPauseBtn()
        configVibrationNotificationBtn()
        configClearBtn()
        configRestartBtn()
        configLapTableBtn()
        configHelpText()
//        configHelpBtn()
//        configLikeBtn()
        
//        configCircle()
        configLapTimeLbl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("config(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configNavBar()
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func configNavBar() {
        let back = UIBarButtonItem()
        back.title = ""
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = back
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func configCircle() {
        let width = circle.superview!.frame.width - CGFloat(Constants.defaultMargin * 2)
        
        circle.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(width)
            make.center.equalTo(circle.superview!)
        }
        
        circle.layer.borderColor = fgClr.cgColor
        circle.layer.borderWidth = 6
        
        circle.layer.cornerRadius = width / 2
    }
    
    func configStartBtn() {
        startBtn.addTarget(self, action:#selector(onStartTap), for: .touchDown)
        
        startBtn.snp.makeConstraints { make in
            make.width.equalTo(startBtn.superview!).offset(-Constants.defaultMargin * 4)
            make.height.equalTo(startBtn.superview!.frame.height / 5)
            make.center.equalTo(startBtn.superview!)
        }
    }
    
    func configTotalTimeLbl() {
        totalTimeLbl.isHidden = true
        totalTimeLbl.text = "00:00.00"
        totalTimeLbl.font = Constants.responsiveDigitFont
        totalTimeLbl.adjustsFontSizeToFitWidth = true
        totalTimeLbl.numberOfLines = 1
        totalTimeLbl.baselineAdjustment = .alignCenters
        totalTimeLbl.textAlignment = .center
        totalTimeLbl.textColor = fgClr
        
        totalTimeLbl.snp.makeConstraints { make in
            make.width.equalTo(totalTimeLbl.superview!)
            make.height.equalTo(totalTimeLbl.superview!.frame.height / 10)
            make.centerX.equalTo(totalTimeLbl.superview!)
//            make.left.equalTo(totalTimeLbl.superview!).offset(Constants.defaultMargin)
            make.top.equalTo(totalTimeLbl.superview!).offset(Constants.defaultMargin)
        }
    }
    
    func configLapTimeLbl() {
        lapTimeLbl.isHidden = true
        lapTimeLbl.text = "Lap   00:00.00"
        lapTimeLbl.font = Constants.responsiveDigitFont
        lapTimeLbl.adjustsFontSizeToFitWidth = true
        lapTimeLbl.numberOfLines = 1
        lapTimeLbl.baselineAdjustment = .alignCenters
        lapTimeLbl.textAlignment = .center
        lapTimeLbl.textColor = fgClr
        
        lapTimeLbl.snp.makeConstraints { make in
            make.width.equalTo(lapTimeLbl.superview!)
            make.height.equalTo(lapTimeLbl.superview!.frame.height / 10)
            make.centerX.equalTo(lapTimeLbl.superview!)
//            make.left.equalTo(lapTimeLbl.superview!).offset(Constants.defaultMargin)
            make.top.equalTo(totalTimeLbl.snp.bottom)
        }
        
        lapTimeLbl.layoutIfNeeded()
        
        print("LAP TIME LBL HEIGHT", lapTimeLbl.frame.height)
    }
    
    func configHelpText() {
        helpText.snp.makeConstraints { make in
            make.width.equalTo(helpText.superview!).offset(-Constants.defaultMargin * 2)
            make.centerX.equalTo(helpText.superview!)
            make.top.equalTo(lapTimeLbl.snp.bottom).offset(Constants.defaultMargin / 2)
            make.height.equalTo(helpText.superview!.frame.height / 12)
        }
    }
    
    func configLapLbl() {
        lapLbl.isHidden = true
        lapLbl.text = "01"
        lapLbl.textAlignment = .center
        lapLbl.textColor = fgClr
//        lapLbl.layer.borderColor = fgClr.cgColor
//        lapLbl.layer.borderWidth = 5
        lapLbl.baselineAdjustment = .alignCenters
        
        lapLbl.snp.makeConstraints { make in
            make.width.equalTo(lapLbl.superview!).offset(-Constants.defaultMargin * 2)
            make.height.equalTo(lapLbl.superview!.frame.height / 3)
//            make.centerX.equalTo(lapLbl.superview!)
//            make.centerY.equalTo(lapLbl.superview!).offset(-CGFloat(Constants.defaultMargin))
            make.center.equalTo(lapLbl.superview!)
        }
        
        lapLbl.layoutIfNeeded()
            
//        lapLbl.font = UIFont.monospacedDigitSystemFont(ofSize: lapLbl.frame.size.height, weight: Constants.responsiveDefaultFontWeight)
        
        lapLbl.adjustsFontSizeToFitWidth = true
        lapLbl.numberOfLines = 1
        lapLbl.font = Constants.responsiveDigitFont
    }
    
    func configVoiceNotificationsBtn() {
        let buttonImage = UIImage(named: "ic_volume_up_48pt")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        voiceNotificationsBtn.isHidden = true
        
        setSettingsBtnColor(btn: voiceNotificationsBtn, enabled: Constants.storedSettings.bool(forKey: SettingsService.voiceNotificationsKey), which: 0)
        
        voiceNotificationsBtn.setImage(buttonImage, for: .normal)
        voiceNotificationsBtn.setImage(buttonImage, for: .highlighted)
        voiceNotificationsBtn.addTarget(self, action:#selector(onVoiceNotificationsTap), for: .touchDown)
        
        let width = voiceNotificationsBtn.superview!.frame.width / 5
        
        voiceNotificationsBtn.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(voiceNotificationsBtn.snp.width)
            make.bottom.equalTo(voiceNotificationsBtn.superview!).offset(-Constants.defaultMargin)
            make.right.equalTo(voiceNotificationsBtn.superview!).offset(-Constants.defaultMargin)
        }
        
        voiceNotificationsBtn.layoutIfNeeded()
        
        voiceNotificationsBtn.layer.cornerRadius = voiceNotificationsBtn.frame.size.height / 2
    }
    
    func configPauseBtn() {
        let buttonImage = UIImage(named: "ic_pause_48pt")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        pauseBtn.isHidden = true
        pauseBtn.tintColor = btnFgClr
        pauseBtn.backgroundColor = btnBgClr
        pauseBtn.layer.shadowOpacity = shadowOpacity
        pauseBtn.setImage(buttonImage, for: .normal)
        pauseBtn.setImage(buttonImage, for: .highlighted)
        
        pauseBtn.addTarget(self, action:#selector(onPauseTap), for: .touchDown)
        
        let width = pauseBtn.superview!.frame.width / 5
       
        pauseBtn.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(pauseBtn.snp.width)
            make.bottom.equalTo(pauseBtn.superview!).offset(-Constants.defaultMargin)
            make.centerX.equalTo(pauseBtn.superview!)
        }
        
        pauseBtn.layoutIfNeeded()
        
        print("PAUSE BTN HEIGHT", pauseBtn.frame.height)
        
        pauseBtn.layer.cornerRadius = pauseBtn.frame.size.height / 2
    }
    
    func configVibrationNotificationBtn() {
        let buttonImage = UIImage(named: "ic_vibration_48pt")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        vibrationNotificationBtn.isHidden = true

        setSettingsBtnColor(btn: vibrationNotificationBtn, enabled: Constants.storedSettings.bool(forKey: SettingsService.vibrationNotificationsKey), which: 1)
        
        vibrationNotificationBtn.setImage(buttonImage, for: .normal)
        vibrationNotificationBtn.setImage(buttonImage, for: .highlighted)
        vibrationNotificationBtn.addTarget(self, action:#selector(onVibrationNotificationsTap), for: .touchDown)
        
        let width = vibrationNotificationBtn.superview!.frame.width / 5
        
        vibrationNotificationBtn.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(vibrationNotificationBtn.snp.width)
            make.bottom.equalTo(vibrationNotificationBtn.superview!).offset(-Constants.defaultMargin)
            make.left.equalTo(vibrationNotificationBtn.superview!).offset(Constants.defaultMargin)
        }
        
        vibrationNotificationBtn.layoutIfNeeded()
        
        vibrationNotificationBtn.layer.cornerRadius = vibrationNotificationBtn.frame.size.height / 2
    }
    
    func setSettingsBtnColor(btn: UIButton, enabled: Bool, which: Int) {
        btn.tintColor = btnFgClr
        btn.backgroundColor = btnBgClr
        btn.layer.shadowOpacity = shadowOpacity
        
        if !enabled {
            btn.tintColor = Constants.colorPalette["BGDRK"]
        }
    }
    
    func configClearBtn() {
        let buttonImage = UIImage(named: "ic_clear_48pt")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        clearBtn.isHidden = true
        clearBtn.tintColor = btnFgClr
        clearBtn.backgroundColor = btnBgClr
        clearBtn.setImage(buttonImage, for: .normal)
        clearBtn.setImage(buttonImage, for: .highlighted)
        clearBtn.layer.shadowOpacity = shadowOpacity
        clearBtn.addTarget(self, action:#selector(onClearTap), for: .touchDown)
        
        let width = clearBtn.superview!.frame.width / 5
        
        clearBtn.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(clearBtn.snp.width)
            make.bottom.equalTo(clearBtn.superview!).offset(-width - CGFloat(Constants.defaultMargin / 2))
            make.left.equalTo(clearBtn.superview!).offset(width + CGFloat(Constants.defaultMargin / 2))
        }
        
        clearBtn.layoutIfNeeded()
        
        clearBtn.layer.cornerRadius = clearBtn.frame.size.height / 2
    }
    
    func configRestartBtn() {
        let buttonImage = UIImage(named: "ic_play_arrow_48pt")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        restartBtn.isHidden = true
        restartBtn.tintColor = btnFgClr
        restartBtn.backgroundColor = btnBgClr
        restartBtn.setImage(buttonImage, for: .normal)
        restartBtn.setImage(buttonImage, for: .highlighted)
        restartBtn.layer.shadowOpacity = shadowOpacity
        restartBtn.addTarget(self, action:#selector(onRestartTap), for: .touchDown)
        
        let width = restartBtn.superview!.frame.width / 5
        
        restartBtn.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(restartBtn.snp.width)
            make.bottom.equalTo(restartBtn.superview!).offset(-Constants.defaultMargin)
            make.centerX.equalTo(restartBtn.superview!)
        }
        
        restartBtn.layoutIfNeeded()
        
        restartBtn.layer.cornerRadius = restartBtn.frame.size.height / 2
    }
    
    func configLapTableBtn() {
        let buttonImage = UIImage(named: "ic_format_list_bulleted_48pt")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        lapTableBtn.isHidden = true
        lapTableBtn.tintColor = btnFgClr
        lapTableBtn.backgroundColor = btnBgClr
        lapTableBtn.layer.shadowOpacity = shadowOpacity
        lapTableBtn.setImage(buttonImage, for: .normal)
        lapTableBtn.setImage(buttonImage, for: .highlighted)
        lapTableBtn.addTarget(self, action:#selector(onLapTableTap), for: .touchDown)
        
        let width = lapTableBtn.superview!.frame.width / 5
        
        lapTableBtn.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(lapTableBtn.snp.width)
            make.bottom.equalTo(lapTableBtn.superview!).offset(-width - CGFloat(Constants.defaultMargin / 2))
            make.right.equalTo(lapTableBtn.superview!).offset(-width - CGFloat(Constants.defaultMargin / 2))
        }
        
        lapTableBtn.layoutIfNeeded()
        
        lapTableBtn.layer.cornerRadius = lapTableBtn.frame.size.height / 2
    }
    
    func configHelpBtn() {
        let buttonImage = UIImage(named: "ic_help_outline_48pt")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        helpBtn.isHidden = false
        helpBtn.tintColor = btnFgClr
        helpBtn.backgroundColor = btnBgClr
        helpBtn.setImage(buttonImage, for: .normal)
        helpBtn.setImage(buttonImage, for: .highlighted)
        helpBtn.addTarget(self, action:#selector(onHelpTap), for: .touchDown)
        
        let width = helpBtn.superview!.frame.width / 8

        helpBtn.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(helpBtn.snp.width)
            make.centerY.equalTo(helpBtn.superview!).offset(helpBtn.superview!.frame.height / 4)
            make.centerX.equalTo(helpBtn.superview!).offset(-Constants.defaultMargin * 2)
        }
        
        helpBtn.layoutIfNeeded()
        
        helpBtn.layer.cornerRadius = helpBtn.frame.size.height / 2
    }
    
    func configLikeBtn() {
        let width = likeBtn.superview!.frame.width / 8
        
        likeBtn.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(likeBtn.snp.width)
            make.centerY.equalTo(likeBtn.superview!).offset(likeBtn.superview!.frame.height / 4)
            make.centerX.equalTo(likeBtn.superview!).offset(Constants.defaultMargin * 2)
        }
        
        likeBtn.layoutIfNeeded()
        likeBtn.layer.cornerRadius = likeBtn.frame.size.height / 2
    }
    
    func setLapLblText(lapCount: Int) {
        let shouldPad = lapCount < 10
        let padding = shouldPad ? "0" : ""
        lapLbl.text = "\(padding)\(lapCount)"
    }

    func onStartTap() {
        stopWatchSrv.start()
        setLapLblText(lapCount: self.stopWatchSrv.lapTimes.count)
        
        animationSrv.animateFadeOutView(startBtn, duration: 0.0)
        helpBtn.alpha = 0
        likeBtn.alpha = 0
        animationSrv.animateWithSpring(lapLbl, fromAlphaZero: true)
        animationSrv.animateWithSpring(totalTimeLbl, duration: 0.8, fromAlphaZero: true)
        animationSrv.animateWithSpring(lapTimeLbl, duration: 0.8, fromAlphaZero: true)
        
//        helpText.showBriefly()
    }
    
    func onPauseTap() {
        stopWatchSrv.pause()
    }
    
    func onRestartTap() {
        stopWatchSrv.restart()
    }
    
    func onLapTableTap() {
        let lapTableController = LapTableController(lapTimes: stopWatchSrv.lapTimes.reversed())
        self.navigationController?.pushViewController(lapTableController, animated: true)
    }
    
    func onClearTap() {
        stopWatchSrv.stop()
        
//        animationSrv.animate({ self.view.backgroundColor = Constants.colorPalette["_black"] })
        
        animateFadeOutBtnsAndLbls()
        
        animationSrv.animateFadeInView(startBtn)
        animationSrv.animateFadeInView(helpBtn, delay: 0.3)
        animationSrv.animateFadeInView(likeBtn, delay: 0.3)
        
    }
    
    func onHelpTap() {
        print("tapped")
    }
    
    func animateFadeOutBtnsAndLbls() {
        animationSrv.animateFadeOutView(clearBtn, duration: 0.0)
        animationSrv.animateFadeOutView(lapTableBtn, duration: 0.0)
        animationSrv.animateFadeOutView(voiceNotificationsBtn, duration: 0.0)
        animationSrv.animateFadeOutView(restartBtn, duration: 0.0)
        animationSrv.animateFadeOutView(vibrationNotificationBtn, duration: 0.0)
        animationSrv.animateFadeOutView(lapLbl, duration: 0.0)
        animationSrv.animateFadeOutView(totalTimeLbl, duration: 0.0)
        animationSrv.animateFadeOutView(lapTimeLbl, duration: 0.0)
    }
    
    func animateFadeInBtnsAndLbls() {
        animationSrv.animateFadeInView(clearBtn, duration: 0.0)
        animationSrv.animateFadeInView(lapTableBtn, duration: 0.0)
        animationSrv.animateFadeInView(voiceNotificationsBtn, duration: 0.0)
        animationSrv.animateFadeInView(restartBtn, duration: 0.0)
        animationSrv.animateFadeInView(vibrationNotificationBtn, duration: 0.0)
        animationSrv.animateFadeInView(lapLbl, duration: 0.0)
        animationSrv.animateFadeInView(totalTimeLbl, duration: 0.0)
        animationSrv.animateFadeInView(lapTimeLbl, duration: 0.0)
    }
    
    func onVoiceNotificationsTap() {
        handleSettingsToggle(key: SettingsService.voiceNotificationsKey, btn: voiceNotificationsBtn, which: 0)
    }
    
    func onVibrationNotificationsTap() {
        handleSettingsToggle(key: SettingsService.vibrationNotificationsKey, btn: vibrationNotificationBtn, which: 1)
    }
    
    func handleSettingsToggle(key: String, btn: UIButton, which: Int) {
        let currentValue = Constants.storedSettings.bool(forKey: key)
        
        Constants.storedSettings.set(!currentValue, forKey: key)
        
        setSettingsBtnColor(btn: btn, enabled: !currentValue, which: which)
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

// MARK Animations
extension SingleViewController {
    func animateInButtons() {
        animationSrv.animateMoveVerticallyFromOffscreenBottom(voiceNotificationsBtn)
        animationSrv.animateMoveVerticallyFromOffscreenBottom(pauseBtn)
        animationSrv.animateMoveVerticallyFromOffscreenBottom(vibrationNotificationBtn)
    }
}


// MARK StopWatchServiceDelegate
extension SingleViewController: StopWatchServiceDelegate {
    func stopWatchStarted() {
        attachDoubleTapRecognizer()
        
        if stopWatchSrv.lapTimes.count == 1 {
            animateInButtons()
            notifyStarted()
        }
    }
    
    func stopWatchIntervalElapsed(totalTimeElapsed: TimeInterval) {
        DispatchQueue.main.async {
            let lapTime = self.stopWatchSrv.lapTimes.last!
            let lapTimeAsString = self.timeToTextSrv.timeAsSingleString(inputTime: lapTime)
            
            self.lapTimeLbl.text = "Lap   \(lapTimeAsString)"
            self.totalTimeLbl.text = "Total \(self.timeToTextSrv.timeAsSingleString(inputTime: totalTimeElapsed))"
        }
    }
    
    func stopWatchLapStored(lapTime: Double, lapNumber: Int, totalTime: Double) {
        DispatchQueue.main.async {
            self.setLapLblText(lapCount: self.stopWatchSrv.lapTimes.count)
        }
        
        notifyWithVibrationIfEnabled()
        
        notifyWithVoiceIfEnabled(lapTime: lapTime, lapNumber: lapNumber)
    }
    
    func stopWatchStopped() {
        notifyTimerCleared()
    }
    
    func stopWatchPaused() {
        pauseBtn.hide()
        restartBtn.show()
   
        animationSrv.animateMoveHorizontallyFromOffscreen(clearBtn, direction: .left)
        animationSrv.animateMoveHorizontallyFromOffscreen(lapTableBtn, direction: .right)
        
        notifyPaused()
    }
    
    func stopWatchRestarted() {
        restartBtn.hide()
        pauseBtn.show()
        
        animationSrv.animateFadeOutView(clearBtn)
        animationSrv.animateFadeOutView(lapTableBtn)
        
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

    func viewDoubleTapped() {
        if stopWatchSrv.timerRunning {
            stopWatchSrv.lap()
        }
    }
}

