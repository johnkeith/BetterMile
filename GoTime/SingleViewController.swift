//
//  SingleViewController.swift
//  GoTime
//
//  Created by John Keith on 5/1/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit
import AudioToolbox

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
    
    var doubleTapRecognizer: UITapGestureRecognizer! // TODO: FIX
    
//  DI
    var stopWatchSrv: StopWatchService
    var animationSrv: AnimationService
    var timeToTextSrv: TimeToTextService
    
    init(stopWatchSrv: StopWatchService = StopWatchService(),
         animationSrv: AnimationService = AnimationService(),
         timeToTextSrv: TimeToTextService = TimeToTextService()) {
        self.stopWatchSrv = stopWatchSrv
        self.animationSrv = animationSrv
        self.timeToTextSrv = timeToTextSrv
        
        super.init(nibName: nil, bundle: nil)
        
        stopWatchSrv.delegate = self
        
        view.backgroundColor = Constants.colorPalette["white"]
        
        addSubviews([startBtn, totalTimeLbl, lapLbl, voiceNotificationsBtn, pauseBtn, vibrationNotificationBtn, clearBtn, restartBtn, lapTableBtn])

        configStartBtn()
        configTotalTimeLbl()
        configLapLbl()
        configVoiceNotificationsBtn()
        configPauseBtn()
        configVibrationNotificationBtn()
        configClearBtn()
        configRestartBtn()
        configLapTableBtn()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("config(coder:) has not been implemented")
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
        
        startBtn.addTarget(self, action:#selector(onStartTap), for: .touchUpInside)
        
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
        
        totalTimeLbl.snp.makeConstraints { make in
            make.width.equalTo(totalTimeLbl.superview!).offset(-Constants.defaultMargin)
            make.height.equalTo(totalTimeLbl.superview!.frame.height / 6)
            make.centerX.equalTo(totalTimeLbl.superview!)
            make.top.equalTo(totalTimeLbl.superview!).offset(Constants.defaultMargin)
        }
    }
    
    func configLapLbl() {
        lapLbl.isHidden = true
        lapLbl.text = "1"
        lapLbl.textAlignment = .center
        
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
        
        voiceNotificationsBtn.isHidden = false
        voiceNotificationsBtn.tintColor = Constants.colorPalette["white"]
        voiceNotificationsBtn.backgroundColor = Constants.colorPalette["black"]
        voiceNotificationsBtn.setImage(buttonImage, for: UIControlState.normal)
        
        let width = voiceNotificationsBtn.superview!.frame.width / 5
        
        voiceNotificationsBtn.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(voiceNotificationsBtn.snp.width)
            make.bottom.equalTo(voiceNotificationsBtn.superview!).offset(-Constants.defaultMargin)
            make.right.equalTo(voiceNotificationsBtn.superview!).offset(-Constants.defaultMargin)
        }
        
        voiceNotificationsBtn.layer.borderWidth = 2.0
        
        voiceNotificationsBtn.layoutIfNeeded()
        
        voiceNotificationsBtn.layer.cornerRadius = voiceNotificationsBtn.frame.size.height / 2
    }
    
    func configPauseBtn() {
        let buttonImage = UIImage(named: "ic_pause_48pt")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        pauseBtn.isHidden = false
        pauseBtn.tintColor = Constants.colorPalette["white"]
        pauseBtn.backgroundColor = Constants.colorPalette["black"]
        pauseBtn.setImage(buttonImage, for: UIControlState.normal)
        
        let width = pauseBtn.superview!.frame.width / 5
       
        pauseBtn.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(pauseBtn.snp.width)
            make.bottom.equalTo(pauseBtn.superview!).offset(-Constants.defaultMargin)
            make.centerX.equalTo(pauseBtn.superview!)
        }
        
        pauseBtn.layer.borderWidth = 2.0
        
        pauseBtn.layoutIfNeeded()
        
        pauseBtn.layer.cornerRadius = pauseBtn.frame.size.height / 2
    }
    
    func configVibrationNotificationBtn() {
        let buttonImage = UIImage(named: "ic_vibration_48pt")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        vibrationNotificationBtn.isHidden = false
        vibrationNotificationBtn.tintColor = Constants.colorPalette["white"]
        vibrationNotificationBtn.backgroundColor = Constants.colorPalette["black"]
        vibrationNotificationBtn.setImage(buttonImage, for: UIControlState.normal)
        
        let width = vibrationNotificationBtn.superview!.frame.width / 5
        vibrationNotificationBtn.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(vibrationNotificationBtn.snp.width)
            make.bottom.equalTo(vibrationNotificationBtn.superview!).offset(-Constants.defaultMargin)
            make.left.equalTo(vibrationNotificationBtn.superview!).offset(Constants.defaultMargin)
        }
        
        vibrationNotificationBtn.layer.borderWidth = 2.0
        
        vibrationNotificationBtn.layoutIfNeeded()
        
        vibrationNotificationBtn.layer.cornerRadius = vibrationNotificationBtn.frame.size.height / 2
    }
    
    func configClearBtn() {
        let buttonImage = UIImage(named: "ic_clear_48pt")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        clearBtn.isHidden = false
        clearBtn.tintColor = Constants.colorPalette["white"]
        clearBtn.backgroundColor = Constants.colorPalette["black"]
        clearBtn.setImage(buttonImage, for: UIControlState.normal)
        
        let width = clearBtn.superview!.frame.width / 5
        
        clearBtn.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(clearBtn.snp.width)
            make.bottom.equalTo(clearBtn.superview!).offset(-width - CGFloat(Constants.defaultMargin))
            make.left.equalTo(clearBtn.superview!).offset(width + CGFloat(Constants.defaultMargin / 2))
        }
        
        clearBtn.layer.borderWidth = 2.0
        
        clearBtn.layoutIfNeeded()
        
        clearBtn.layer.cornerRadius = clearBtn.frame.size.height / 2
    }
    
    func configRestartBtn() {
        let buttonImage = UIImage(named: "ic_play_arrow_48pt")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        restartBtn.isHidden = false
        restartBtn.tintColor = Constants.colorPalette["white"]
        restartBtn.backgroundColor = Constants.colorPalette["black"]
        restartBtn.setImage(buttonImage, for: UIControlState.normal)
        
        let width = restartBtn.superview!.frame.width / 5
        
        restartBtn.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(restartBtn.snp.width)
            make.bottom.equalTo(restartBtn.superview!).offset(-Constants.defaultMargin)
            make.centerX.equalTo(restartBtn.superview!)
        }
        
        restartBtn.layer.borderWidth = 2.0
        
        restartBtn.layoutIfNeeded()
        
        restartBtn.layer.cornerRadius = restartBtn.frame.size.height / 2
    }
    
    func configLapTableBtn() {
        let buttonImage = UIImage(named: "ic_format_list_numbered_48pt")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        lapTableBtn.isHidden = false
        lapTableBtn.tintColor = Constants.colorPalette["white"]
        lapTableBtn.backgroundColor = Constants.colorPalette["black"]
        lapTableBtn.setImage(buttonImage, for: UIControlState.normal)
        
        let width = lapTableBtn.superview!.frame.width / 5
        
        lapTableBtn.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(lapTableBtn.snp.width)
            make.bottom.equalTo(lapTableBtn.superview!).offset(-width - CGFloat(Constants.defaultMargin))
            make.right.equalTo(lapTableBtn.superview!).offset(-width - CGFloat(Constants.defaultMargin / 2))
        }
        
        lapTableBtn.layer.borderWidth = 2.0
        
        lapTableBtn.layoutIfNeeded()
        
        lapTableBtn.layer.cornerRadius = lapTableBtn.frame.size.height / 2
    }
    
    func onStartTap() {
        print("start tapped")
                
        animationSrv.animateFadeOutView(startBtn)
        animationSrv.animateWithSpring(lapLbl, fromAlphaZero: true)
        animationSrv.animateWithSpring(totalTimeLbl, duration: 0.8, fromAlphaZero: true)
        
        stopWatchSrv.start()
    }
}

// MARK StopWatchServiceDelegate
extension SingleViewController: StopWatchServiceDelegate {
    func stopWatchStarted() {
        attachDoubleTapRecognizer()
    }
    
    func stopWatchIntervalElapsed(totalTimeElapsed: TimeInterval) {
        DispatchQueue.main.async {
            self.totalTimeLbl.text = self.timeToTextSrv.timeAsSingleString(inputTime: totalTimeElapsed)
        }
    }
    
    func stopWatchLapStored(lapTime: Double, lapNumber: Int, totalTime: Double) {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        DispatchQueue.main.async {
            self.lapLbl.text = "\(self.stopWatchSrv.lapTimes.count)"
        }
    }
    
    func stopWatchStopped() {

    }
    
    func stopWatchPaused() {
        
    }
    
    func stopWatchRestarted() {
    
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
