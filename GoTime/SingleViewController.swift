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
        
        addSubviews([startBtn, totalTimeLbl, lapLbl])

        configStartBtn()
        configTotalTimeLbl()
        configLapLbl()
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
            make.top.equalTo(totalTimeLbl.superview!).offset(Constants.defaultMargin * 2)
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
