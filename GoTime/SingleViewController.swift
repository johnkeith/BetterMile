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
    let startBtn = UIButton()
    let totalTimeLbl = UILabel()
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
    
    
    var doubleTapRecognizer: UITapGestureRecognizer! // TODO: FIX
    
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
        
        super.init(nibName: nil, bundle: nil)
        
        stopWatchSrv.delegate = self
        
        view.backgroundColor = Constants.colorPalette["_white"]
        
        addSubviews([startBtn, totalTimeLbl, lapLbl, voiceNotificationsBtn, pauseBtn, vibrationNotificationBtn, clearBtn, restartBtn, lapTableBtn, helpText, helpBtn])
        
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
        configHelpBtn()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("config(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func configStartBtn() {
        startBtn.isHidden = false
        startBtn.setTitle("START", for: UIControlState.normal)
        startBtn.setTitleColor(Constants.colorPalette["black"], for: UIControlState.normal)
        startBtn.titleLabel?.font = Constants.responsiveDefaultFont
        startBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        startBtn.titleLabel?.numberOfLines = 1
        startBtn.titleLabel?.baselineAdjustment = .alignCenters
        startBtn.titleLabel?.textAlignment = .center
        
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
        totalTimeLbl.textColor = Constants.colorPalette["_white"]
        
        totalTimeLbl.snp.makeConstraints { make in
            make.width.equalTo(totalTimeLbl.superview!).offset(-Constants.defaultMargin)
            make.left.equalTo(totalTimeLbl.superview!).offset(Constants.defaultMargin / 2)
            make.right.equalTo(totalTimeLbl.superview!).offset(-Constants.defaultMargin / 2)
            make.height.equalTo(totalTimeLbl.superview!.frame.height / 6)
//            make.centerX.equalTo(totalTimeLbl.superview!)
            make.top.equalTo(totalTimeLbl.superview!).offset(Constants.defaultMargin)
        }
    }
    
    func configHelpText() {
        helpText.snp.makeConstraints { make in
            make.width.equalTo(helpText.superview!).offset(-Constants.defaultMargin * 2)
            make.centerX.equalTo(helpText.superview!)
            make.top.equalTo(totalTimeLbl.snp.bottom).offset(Constants.defaultMargin)
            make.height.equalTo(helpText.superview!.frame.height / 12)
        }
    }
    
    func configLapLbl() {
        lapLbl.isHidden = true
        lapLbl.text = "1"
        lapLbl.textAlignment = .center
        lapLbl.textColor = Constants.colorPalette["_white"]
        
        lapLbl.snp.makeConstraints { make in
            make.width.equalTo(lapLbl.superview!)
            make.height.equalTo(lapLbl.superview!.frame.height / 3)
            make.center.equalTo(lapLbl.superview!)
        }
        
        lapLbl.layoutIfNeeded()
        
        lapLbl.font = UIFont.systemFont(ofSize: lapLbl.frame.size.height, weight: UIFontWeightThin)
    }
    
    func configVoiceNotificationsBtn() {
        let buttonImage = UIImage(named: "ic_volume_up_48pt")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        voiceNotificationsBtn.isHidden = true
        
        setSettingsBtnColor(btn: voiceNotificationsBtn, enabled: Constants.storedSettings.bool(forKey: SettingsService.voiceNotificationsKey))
        
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
        pauseBtn.tintColor = Constants.colorPalette["_white"]
        pauseBtn.backgroundColor = Constants.colorPalette["_red"]
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
        
        pauseBtn.layer.cornerRadius = pauseBtn.frame.size.height / 2
    }
    
    func configVibrationNotificationBtn() {
        let buttonImage = UIImage(named: "ic_vibration_48pt")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        vibrationNotificationBtn.isHidden = true

        setSettingsBtnColor(btn: vibrationNotificationBtn, enabled: Constants.storedSettings.bool(forKey: SettingsService.vibrationNotificationsKey))
        
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
    
    func setSettingsBtnColor(btn: UIButton, enabled: Bool) {
        if enabled {
            btn.tintColor = Constants.colorPalette["_white"]
            btn.backgroundColor = Constants.colorPalette["_blue"]
        } else {
            btn.tintColor = Constants.colorPalette["_black"]
            btn.backgroundColor = Constants.colorPalette["_white"]
        }
    }
    
    func configClearBtn() {
        let buttonImage = UIImage(named: "ic_clear_48pt")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        clearBtn.isHidden = true
        clearBtn.tintColor = Constants.colorPalette["_white"]
        clearBtn.backgroundColor = Constants.colorPalette["_red"]
        clearBtn.setImage(buttonImage, for: .normal)
        clearBtn.setImage(buttonImage, for: .highlighted)
        clearBtn.addTarget(self, action:#selector(onClearTap), for: .touchDown)
        
        let width = clearBtn.superview!.frame.width / 5
        
        clearBtn.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(clearBtn.snp.width)
            make.bottom.equalTo(clearBtn.superview!).offset(-width - CGFloat(Constants.defaultMargin))
            make.left.equalTo(clearBtn.superview!).offset(width + CGFloat(Constants.defaultMargin / 2))
        }
        
        clearBtn.layoutIfNeeded()
        
        clearBtn.layer.cornerRadius = clearBtn.frame.size.height / 2
    }
    
    func configRestartBtn() {
        let buttonImage = UIImage(named: "ic_play_arrow_48pt")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        restartBtn.isHidden = true
        restartBtn.tintColor = Constants.colorPalette["_white"]
        restartBtn.backgroundColor = Constants.colorPalette["_green"]
        restartBtn.setImage(buttonImage, for: .normal)
        restartBtn.setImage(buttonImage, for: .highlighted)
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
        lapTableBtn.tintColor = Constants.colorPalette["_white"]
        lapTableBtn.backgroundColor = Constants.colorPalette["_blue"]
        lapTableBtn.setImage(buttonImage, for: .normal)
        lapTableBtn.setImage(buttonImage, for: .highlighted)
        lapTableBtn.addTarget(self, action:#selector(onLapTableTap), for: .touchDown)
        
        let width = lapTableBtn.superview!.frame.width / 5
        
        lapTableBtn.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(lapTableBtn.snp.width)
            make.bottom.equalTo(lapTableBtn.superview!).offset(-width - CGFloat(Constants.defaultMargin))
            make.right.equalTo(lapTableBtn.superview!).offset(-width - CGFloat(Constants.defaultMargin / 2))
        }
        
        lapTableBtn.layoutIfNeeded()
        
        lapTableBtn.layer.cornerRadius = lapTableBtn.frame.size.height / 2
    }
    
    func configHelpBtn() {
        let buttonImage = UIImage(named: "ic_help_outline_48pt")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        helpBtn.isHidden = true
        helpBtn.tintColor = Constants.colorPalette["_black"]
        helpBtn.backgroundColor = Constants.colorPalette["_white"]
        helpBtn.setImage(buttonImage, for: .normal)
        helpBtn.setImage(buttonImage, for: .highlighted)
        helpBtn.addTarget(self, action:#selector(onHelpTap), for: .touchDown)
        
        let width = helpBtn.superview!.frame.width / 8

        print(width)
        helpBtn.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(helpBtn.snp.width)
            make.top.equalTo(helpBtn.superview!).offset(Constants.defaultMargin)
            make.right.equalTo(helpBtn.superview!).offset(-Constants.defaultMargin / 2)
        }
        
        helpBtn.layoutIfNeeded()
        
        helpBtn.layer.cornerRadius = helpBtn.frame.size.height / 2
    }

    func onStartTap() {
        stopWatchSrv.start()
        lapLbl.text = "\(self.stopWatchSrv.lapTimes.count)"
        
        animationSrv.animateFadeOutView(startBtn)
        animationSrv.animateWithSpring(lapLbl, fromAlphaZero: true)
        animationSrv.animateWithSpring(totalTimeLbl, duration: 0.8, fromAlphaZero: true)
        
        animationSrv.animate({ self.view.backgroundColor = Constants.colorPalette["_black"] })
        helpText.showBriefly()
        UIApplication.shared.statusBarStyle = .lightContent
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
        
        animationSrv.animate({ self.view.backgroundColor = Constants.colorPalette["_white"] })

        animateFadeOutBtnsAndLbls()
        
        animationSrv.animateFadeInView(startBtn)
        
        UIApplication.shared.statusBarStyle = .default
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
    }
    
    func animateFadeInBtnsAndLbls() {
        animationSrv.animateFadeInView(clearBtn, duration: 0.0)
        animationSrv.animateFadeInView(lapTableBtn, duration: 0.0)
        animationSrv.animateFadeInView(voiceNotificationsBtn, duration: 0.0)
        animationSrv.animateFadeInView(restartBtn, duration: 0.0)
        animationSrv.animateFadeInView(vibrationNotificationBtn, duration: 0.0)
        animationSrv.animateFadeInView(lapLbl, duration: 0.0)
        animationSrv.animateFadeInView(totalTimeLbl, duration: 0.0)
    }
    
    func onVoiceNotificationsTap() {
        handleSettingsToggle(key: SettingsService.voiceNotificationsKey, btn: voiceNotificationsBtn)
    }
    
    func onVibrationNotificationsTap() {
        handleSettingsToggle(key: SettingsService.vibrationNotificationsKey, btn: vibrationNotificationBtn)
    }
    
    func handleSettingsToggle(key: String, btn: UIButton) {
        let currentValue = Constants.storedSettings.bool(forKey: key)
        
        Constants.storedSettings.set(!currentValue, forKey: key)
        
        setSettingsBtnColor(btn: btn, enabled: !currentValue)
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
            let averageLapTime = stopWatchSrv.calculateAverageLapTime()
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
        }
        
        notifyStarted()
    }
    
    func stopWatchIntervalElapsed(totalTimeElapsed: TimeInterval) {
        DispatchQueue.main.async {
            self.totalTimeLbl.text = self.timeToTextSrv.timeAsSingleString(inputTime: totalTimeElapsed)
        }
    }
    
    func stopWatchLapStored(lapTime: Double, lapNumber: Int, totalTime: Double) {
        DispatchQueue.main.async {
            self.lapLbl.text = "\(self.stopWatchSrv.lapTimes.count)"
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
