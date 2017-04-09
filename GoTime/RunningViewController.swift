//
//  RunningViewController.swift
//  GoTime
//
//  Created by John Keith on 4/8/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit
import AudioToolbox

// TODO: UNTESTED
class RunningViewController: UIViewController {
    var stopWatchService: StopWatchService
    var timeToTextService: TimeToTextService
    var startButton: StartButton
    var totalTimeLabel: TotalTimeLabel
    var dividerLabel: DividerLabel
    var timerHelpTextLabel: TimerHelpTextLabel
    
    init(stopWatchService: StopWatchService,
         timeToTextService: TimeToTextService = TimeToTextService(),
         startButton: StartButton = StartButton(),
         totalTimeLabel: TotalTimeLabel = TotalTimeLabel(),
         dividerLabel: DividerLabel = DividerLabel(),
         timerHelpTextLabel: TimerHelpTextLabel = TimerHelpTextLabel()) {
        
        self.stopWatchService = stopWatchService
        self.timeToTextService = timeToTextService
        self.startButton = startButton
        self.totalTimeLabel = totalTimeLabel
        self.dividerLabel = dividerLabel
        self.timerHelpTextLabel = timerHelpTextLabel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.view.isUserInteractionEnabled = true

        startButton.delegate = self
        stopWatchService.delegate = self
        
        addSubviews()
        addConstraints()
    }
    
    func addSubviews() {
        for _view in [startButton, totalTimeLabel, dividerLabel, timerHelpTextLabel] as [UIView] {
            self.view.addSubview(_view)
        }
    }
    
    func addConstraints() {
        RunningViewControllerConstraints.positionStartButton(startButton: startButton)
        RunningViewControllerConstraints.positionTotalTimeLabel(totalTimeLabel: totalTimeLabel)
        RunningViewControllerConstraints.positionDividerLabel(dividerLabel: dividerLabel, totalTimeLabel: totalTimeLabel)
        RunningViewControllerConstraints.positionTimerHelpTextLabel(timerHelpTextLabel: timerHelpTextLabel)
    }
}

extension RunningViewController: StartButtonDelegate {
    func onStartTap(sender: StartButton) {
        sender.hide()
        
        totalTimeLabel.show()
        dividerLabel.show()
        timerHelpTextLabel.showBriefly()
        
//        attachDoubleTapRecognizer()
//        attachLongPressRecognizer()
        
        stopWatchService.start()
    }
}

extension RunningViewController: StopWatchServiceDelegate {
    func stopWatchIntervalElapsed(totalTimeElapsed: TimeInterval) {
        totalTimeLabel.text = timeToTextService.timeAsSingleString(inputTime: totalTimeElapsed)
        
//        DispatchQueue.main.async {
//            self.lapTimeTable.setLapData(lapData: self.stopWatchService.lapTimes.reversed())
//        }
    }
    
    func stopWatchStopped() {
//        removeViewRecognizers()
        
        totalTimeLabel.hide()
        dividerLabel.hide()
        
//        lapTimeTable.clearLapData()
        
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
