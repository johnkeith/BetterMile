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
    
    var stopWatchService: StopWatchService
    var timeToTextService: TimeToTextService
    
    var doubleTapRecognizer: UITapGestureRecognizer!
    var longPressRecognizer: UILongPressGestureRecognizer!
    
    init(startButton: StartButton = StartButton(),
         totalTimeLabel: TotalTimeLabel = TotalTimeLabel(hidden: true),
         lapTimeTable: LapTimeTable = LapTimeTable(hidden: true),
         stopWatchService: StopWatchService = StopWatchService(),
         timeToTextService: TimeToTextService = TimeToTextService(),
         dividerLabel: DividerLabel = DividerLabel(hidden: true),
         timerHelpTextLabel: TimerHelpTextLabel = TimerHelpTextLabel(hidden: true)) {
        
        self.startButton = startButton
        self.totalTimeLabel = totalTimeLabel
        self.lapTimeTable = lapTimeTable
        self.dividerLabel = dividerLabel
        self.timerHelpTextLabel = timerHelpTextLabel // TODO: UNTESTED
        
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
        self.view.addSubview(timerHelpTextLabel) // TODO: UNTESTED
    }
    
    func applyConstraints() { // TODO: UNTESTED
        MainViewControllerConstraints.positionStartButton(startButton: startButton)
        MainViewControllerConstraints.positionTotalTimeLabel(totalTimeLabel: totalTimeLabel)
        MainViewControllerConstraints.positionLapTimeTable(lapTimeTable: lapTimeTable, totalTimeLabel: totalTimeLabel)
        MainViewControllerConstraints.positionDividerLabel(dividerLabel: dividerLabel, lapTimeTable: lapTimeTable)
        MainViewControllerConstraints.positionTimerHelpTextLabel(timerHelpTextLabel: timerHelpTextLabel)
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
            // TODO: REVERSE UNTESTED
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
        longPressRecognizer.minimumPressDuration = 1.0
        
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
        timerHelpTextLabel.showBriefly() // TODO: UNTESTED
        
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
    }
}

