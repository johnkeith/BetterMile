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
//    let shadowOpacity = Float(0.15)
    
    let vibrationOnText = "Vibration On"
    let vibrationOffText = "Vibration Off"
    let voiceOnText = "Voice On"
    let voiceOffText = "Voice Off"
    
    let shadowOpacity = Float(0.0)
    let startBtn = StartButton()
    let totalTimeLbl = UILabel()
    let lapTimeLbl = LapTimeLabel()
    let lapLbl = UILabel()
    let voiceNotificationsBtn = UIButton()
    let vibrationNotificationBtn = UIButton()
    let clearBtn = UIButton()
    let restartBtn = UIButton()
    let lapTableBtn = UIButton()
    let helpText = TimerHelpTextLabel()
    let fadingLapTimeLbl = LapTimeLabel()
    let blurOverlay = BlurOverlayView()
    
    var vibrationBarBtn: UIBarButtonItem!
    var voiceBarBtn: UIBarButtonItem!
    
    let container = UIView()
    let topContainer = UIView()
    let bottomContainer = UIView()
    let bottomInnerContainer = UIView()
    
    let helpBtn = UIButton()
    let likeBtn = LikeButton()
    
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
    let pauseBtn: PauseButton
    var settingsBtn: SettingsButton
    
    init(stopWatchSrv: StopWatchService = StopWatchService(),
         animationSrv: AnimationService = AnimationService(),
         timeToTextSrv: TimeToTextService = TimeToTextService(),
         speechSrv: SpeechService = SpeechService()) {
        self.stopWatchSrv = stopWatchSrv
        self.animationSrv = animationSrv
        self.timeToTextSrv = timeToTextSrv
        self.speechSrv = speechSrv
        self.pauseBtn = PauseButton(stopWatchSrv: stopWatchSrv)
        self.settingsBtn = SettingsButton(blurOverlay: blurOverlay, animationSrv: animationSrv)
        
        fgClr = Constants.colorBlack
        bgClr = Constants.colorBackground
        btnFgClr = fgClr
        btnBgClr = UIColor.clear // Constants.colorPalette["BTNBG"]!
        
        super.init(nibName: nil, bundle: nil)
        
        vibrationBarBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(onVibrationNotificationsTap))
        voiceBarBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(onVoiceNotificationsTap))
        
        stopWatchSrv.delegate = self
        
        view.backgroundColor = Constants.colorWhite
        
        addSubviews([container, topContainer, bottomContainer, startBtn, voiceNotificationsBtn, pauseBtn, vibrationNotificationBtn, clearBtn, restartBtn, lapTableBtn, helpText, helpBtn, likeBtn, fadingLapTimeLbl, settingsBtn, blurOverlay])
        
        settingsBtn.addSettingsView()
        
        configStartBtn()
        
        container.addSubview(lapLbl)
        bottomContainer.addSubview(bottomInnerContainer)
        container.addSubview(totalTimeLbl)
        container.addSubview(lapTimeLbl)
        
        askForReview()
        animationSrv.animateWithSpring(startBtn, duration: 0.8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("config(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configNavBar()
        
        UIApplication.shared.statusBarStyle = .default
        
        configContainer()
        configTopContainer()
        configBottomContainer()
        configBottomInnerContainer()
        
        configLapLbl()
        
        configTotalTimeLbl()
        //        configVoiceNotificationsBtn()
        //        configPauseBtn()
        //        configSettingsBtn()
        //        configVibrationNotificationBtn()
        configClearBtn()
        configRestartBtn()
        configLapTableBtn()
        configHelpText()
        //        configHelpBtn()
        //        configLikeBtn()
        configLapTimeLbl()
        //        configFadingLapTimeLbl()
        configBlurOverlay()
        configToolbar()
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
        let back = UIBarButtonItem()
        back.title = ""
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = back
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let clearBarBtn = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(onClearTap))
        let pauseBarBtn = UIBarButtonItem(title: "Pause", style: .plain, target: self, action: #selector(onPauseTap))
        
        clearBarBtn.tintColor = Constants.colorBlack
        pauseBarBtn.tintColor = Constants.colorBlack
        
        self.navigationItem.leftBarButtonItem = clearBarBtn
        self.navigationItem.rightBarButtonItem = pauseBarBtn
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = Constants.colorWhite
        self.navigationController?.view.backgroundColor = Constants.colorWhite
        self.navigationController?.navigationBar.tintColor = Constants.colorWhite
        
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
    
    func configStartBtn() {
        startBtn.isHidden = true
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
            make.width.equalTo(totalTimeLbl.superview!).offset(-Constants.defaultMargin)
            make.height.equalTo(self.view.frame.height / 10)
            make.centerX.equalTo(totalTimeLbl.superview!)
            make.top.equalTo(bottomInnerContainer.snp.top)
        }
    }
    
    func configLapTimeLbl() {
        lapTimeLbl.snp.makeConstraints { make in
            make.width.equalTo(lapTimeLbl.superview!).offset(-Constants.defaultMargin)
            make.height.equalTo(self.view.frame.height / 10)
            make.centerX.equalTo(lapTimeLbl.superview!)
            make.bottom.equalTo(bottomInnerContainer.snp.bottom)
        }
        
        lapTimeLbl.layoutIfNeeded()
    }
    
    func configFadingLapTimeLbl() {
        fadingLapTimeLbl.snp.makeConstraints { make in
            make.width.equalTo(fadingLapTimeLbl.superview!)
            make.height.equalTo(fadingLapTimeLbl.superview!.frame.height / 10)
            make.centerX.equalTo(fadingLapTimeLbl.superview!)
            make.top.equalTo(totalTimeLbl.snp.bottom)
        }
    }
    
    func configHelpText() {
        helpText.snp.makeConstraints { make in
            make.width.equalTo(helpText.superview!).offset(-Constants.defaultMargin)
            make.centerX.equalTo(helpText.superview!)
            make.top.equalTo(lapLbl.snp.bottom).offset(Constants.defaultMargin)
            make.height.equalTo(helpText.superview!.frame.height / 12)
        }
    }
    
    func configContainer() {
        let parentHeight = topContainer.superview!.frame.height
        let height = (parentHeight / 3) + (parentHeight / 5)
        
        container.snp.makeConstraints { make in
            make.width.equalTo(container.superview!)
            make.height.equalTo(height)
            make.center.equalTo(container.superview!)
        }
        
        topContainer.layoutIfNeeded()
    }
    
    func configTopContainer() {
        let offset = UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!
        let height = (topContainer.superview!.frame.height / 2)
        
        topContainer.snp.makeConstraints { make in
            make.width.equalTo(topContainer.superview!)
            make.height.equalTo(height)
            make.top.equalTo(topContainer.superview!)
            make.centerX.equalTo(topContainer.superview!)
        }
        
        topContainer.layoutIfNeeded()
    }
    
    func configBottomContainer() {
        let offset = UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!
        let height = (bottomContainer.superview!.frame.height / 2)
        
        bottomContainer.snp.makeConstraints { make in
            make.width.equalTo(bottomContainer.superview!)
            make.height.equalTo(height)
            make.bottom.equalTo(bottomContainer.superview!)
        }
        
        bottomContainer.layoutIfNeeded()
    }
    
    func configBottomInnerContainer() {
        let height = self.view.frame.height / 5
        
        bottomInnerContainer.snp.makeConstraints { make in
            make.width.equalTo(bottomInnerContainer.superview!)
            make.height.equalTo(height)
            make.center.equalTo(bottomInnerContainer.superview!)
        }
        
        bottomInnerContainer.layoutIfNeeded()
    }
    
    func configLapLbl() {
        lapLbl.isHidden = true
        lapLbl.text = "01"
        lapLbl.textAlignment = .center
        lapLbl.textColor = fgClr
        lapLbl.baselineAdjustment = .alignCenters
        
        lapLbl.snp.makeConstraints { make in
            make.width.equalTo(lapLbl.superview!).offset(-Constants.defaultMargin * 2)
            make.height.equalTo(self.view.frame.height / 3)
//            make.center.equalTo(lapLbl.superview!)
            make.centerX.equalTo(lapLbl.superview!)
            make.top.equalTo(container.snp.top).offset(-Constants.defaultMargin)
        }
        
        lapLbl.layoutIfNeeded()
        
        lapLbl.adjustsFontSizeToFitWidth = true
        lapLbl.numberOfLines = 1
        lapLbl.font = Constants.responsiveDigitFont
    }
    
    func configPauseBtn() {
        pauseBtn.snp.makeConstraints { make in
            make.width.equalTo(pauseBtn.superview!.frame.width / 2)
            make.height.equalTo(pauseBtn.superview!.frame.height / 10 + CGFloat(Constants.defaultMargin))
            make.bottom.equalTo(pauseBtn.superview!)
            make.left.equalTo(pauseBtn.superview!)
        }
        
//        pauseBtn.isHidden = true
//        pauseBtn.tintColor = btnFgClr
//        pauseBtn.backgroundColor = Constants.colorBackgroundDark
//        pauseBtn.layer.shadowOpacity = shadowOpacity
//        pauseBtn.addTarget(self, action:#selector(onPauseTap), for: .touchDown)
//        pauseBtn.setTitle("PAUSE", for: .normal)
//        
//        let width = clearBtn.superview!.frame.width / 5
        
//        pauseBtn.snp.makeConstraints { make in
//            make.width.equalTo(width)
//            make.height.equalTo(pauseBtn.snp.width)
//            make.bottom.equalTo(pauseBtn.superview!).offset(-width - CGFloat(Constants.defaultMargin / 2))
//            make.centerX.equalTo(pauseBtn.superview!)
//        }
        
        pauseBtn.layoutIfNeeded()
        
        pauseBtn.layer.cornerRadius = clearBtn.frame.size.height / 2
    }
    
    func onPauseTap() {
        stopWatchSrv.pause()
    }
    
    func configSettingsBtn() {
        settingsBtn.snp.makeConstraints { make in
            make.width.equalTo(settingsBtn.superview!.frame.width / 2)
            make.height.equalTo(settingsBtn.superview!.frame.height / 10 + CGFloat(Constants.defaultMargin))
            make.bottom.equalTo(settingsBtn.superview!)
            make.right.equalTo(settingsBtn.superview!)
        }
        
        settingsBtn.setLabelConstraints()
        
        settingsBtn.layoutIfNeeded()
        
//        pauseBtn.matchFontSize(of: settingsBtn)
    }
    
    func configVibrationNotificationBtn() {
        let buttonImage = UIImage(named: "ic_vibration_48pt")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        vibrationNotificationBtn.isHidden = true

        setSettingsBtnColor(btn: vibrationNotificationBtn, enabled: Constants.storedSettings.bool(forKey: SettingsService.vibrationNotificationsKey), which: 1)
        
        vibrationNotificationBtn.setImage(buttonImage, for: .normal)
        vibrationNotificationBtn.setImage(buttonImage, for: .highlighted)
        vibrationNotificationBtn.addTarget(self, action:#selector(onVibrationNotificationsTap), for: .touchDown)
        
        let width = voiceNotificationsBtn.superview!.frame.width / 5
        
        vibrationNotificationBtn.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(width)
            make.bottom.equalTo(vibrationNotificationBtn.superview!).offset(-Constants.defaultMargin)
            make.left.equalTo(vibrationNotificationBtn.superview!).offset(Constants.defaultMargin / 2)
        }
        
        vibrationNotificationBtn.layoutIfNeeded()
        
        vibrationNotificationBtn.layer.cornerRadius = vibrationNotificationBtn.frame.size.height / 2
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
            make.height.equalTo(width)
            make.bottom.equalTo(voiceNotificationsBtn.superview!).offset(-Constants.defaultMargin)
            make.right.equalTo(voiceNotificationsBtn.superview!).offset(-Constants.defaultMargin / 2)
        }
        
        voiceNotificationsBtn.layoutIfNeeded()
        
        voiceNotificationsBtn.layer.cornerRadius = voiceNotificationsBtn.frame.size.height / 2
    }
    
    func setSettingsBtnColor(btn: UIButton, enabled: Bool, which: Int) {
        btn.tintColor = btnFgClr
        btn.backgroundColor = btnBgClr
        btn.layer.shadowOpacity = shadowOpacity
        
        if !enabled {
            btn.tintColor = Constants.colorBackgroundDark
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
    
    func setTotalTimeLblText(totalTimeElapsed: TimeInterval) {
        self.totalTimeLbl.text = "Total \(self.timeToTextSrv.timeAsSingleString(inputTime: totalTimeElapsed))"
    }
    
    func setLapTimeLblText(lapTime: TimeInterval) {
        let lapTimeAsString = self.timeToTextSrv.timeAsSingleString(inputTime: lapTime)
        
        self.lapTimeLbl.setTextForLabel(lapTimeAsString)
    }

    func onStartTap() {
        stopWatchSrv.start()
        
        setLapLblText(lapCount: self.stopWatchSrv.lapTimes.count)
        
//        animationSrv.animate({ self.view.backgroundColor = Constants.colorBackground })
        animationSrv.animateFadeOutView(startBtn, duration: 0.0)
        
        helpBtn.alpha = 0
        likeBtn.alpha = 0
        
        animationSrv.animateWithSpring(lapLbl, fromAlphaZero: true)
        animationSrv.animateWithSpring(totalTimeLbl, duration: 0.8, fromAlphaZero: true)
        animationSrv.animateWithSpring(lapTimeLbl, duration: 0.8, fromAlphaZero: true)
        
//        animationSrv.animateWithSpring(helpText, duration: 0.8)
//        helpText.showBriefly()
    }
    
    func onRestartTap() {
        stopWatchSrv.restart()
    }
    
    func onLapTableTap() {
        let lapTableController = LapTableController(stopWatchSrv: stopWatchSrv)
        self.navigationController?.pushViewController(lapTableController, animated: true)
    }
    
    func onClearTap() {
        stopWatchSrv.stop()
        
        animateFadeOutBtnsAndLbls()
        
        animationSrv.animateWithSpring(startBtn, duration: 0.8)
        animationSrv.animateFadeInView(helpBtn, delay: 0.3)
        animationSrv.animateFadeInView(likeBtn, delay: 0.3)
        
//        animationSrv.animate({ self.view.backgroundColor = Constants.colorBlack }, duration: 0.0)
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
        let newValue = handleSettingsToggle(key: SettingsService.voiceNotificationsKey)
        
        voiceBarBtn.title = newValue ? voiceOnText : voiceOffText
    }
    
    func onVibrationNotificationsTap() {
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
        animationSrv.animateWithSpring(voiceNotificationsBtn, duration: 0.8, fromAlphaZero: true)
        animationSrv.animateWithSpring(pauseBtn, duration: 0.8, fromAlphaZero: true)
        animationSrv.animateWithSpring(settingsBtn, duration: 0.8, fromAlphaZero: true)
        animationSrv.animateWithSpring(vibrationNotificationBtn,duration: 0.8, fromAlphaZero: true)
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
            
            self.setLapTimeLblText(lapTime: lapTime)
            self.setTotalTimeLblText(totalTimeElapsed: totalTimeElapsed)
        }
    }
    
    func stopWatchLapStored(lapTime: Double, lapNumber: Int, totalTime: Double) {
        self.setLapLblText(lapCount: self.stopWatchSrv.lapTimes.count)
        
        let text = timeToTextSrv.timeAsSingleString(inputTime: lapTime)
        fadingLapTimeLbl.setTextForLabel(text)
        animationSrv.moveDownAndFade(fadingLapTimeLbl, duration: 1.0)
        
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
//        pauseBtn.hide()
//        restartBtn.show()
//
//        animationSrv.animateWithSpring(clearBtn, duration: 0.8, fromAlphaZero: true)
//        animationSrv.animateWithSpring(lapTableBtn, duration: 0.8, fromAlphaZero: true)
//
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
            animationSrv.enlargeBriefly(lapLbl)
        }
    }
}

