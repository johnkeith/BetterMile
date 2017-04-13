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
         totalTimeLabel: TotalTimeLabel = TotalTimeLabel(hidden: true),
         dividerLabel: DividerLabel = DividerLabel(),
         timerHelpTextLabel: TimerHelpTextLabel = TimerHelpTextLabel()) {
        
        self.stopWatchService = stopWatchService
        self.timeToTextService = timeToTextService
        self.startButton = startButton
        self.totalTimeLabel = totalTimeLabel
        self.dividerLabel = dividerLabel
        self.timerHelpTextLabel = timerHelpTextLabel
        
        super.init(nibName: nil, bundle: nil)
        
        startButton.delegate = self
        stopWatchService.delegates.append(self)
        
        addSubviews([startButton, totalTimeLabel, dividerLabel, timerHelpTextLabel])
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Constants.colorPalette["white"]
        self.view.isUserInteractionEnabled = true
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
        
        stopWatchService.start()
    }
}

extension RunningViewController: StopWatchServiceDelegate {
    func stopWatchStarted() {
        
    }
    
    func stopWatchIntervalElapsed(totalTimeElapsed: TimeInterval) {
//        totalTimeLabel.text = timeToTextService.timeAsSingleString(inputTime: totalTimeElapsed)
        DispatchQueue.main.async {
            self.totalTimeLabel.setText(time: self.timeToTextService.timeAsSingleString(inputTime: totalTimeElapsed))
        }
    }
    
    func stopWatchStopped() {
        totalTimeLabel.hide()
        dividerLabel.hide()
        
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
