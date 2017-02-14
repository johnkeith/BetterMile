//
//  ViewController.swift
//  GoTime
//
//  Created by John Keith on 1/17/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var startButton: StartButton
    var totalTimeLabel: TotalTimeLabel
    var lapTimeTable: LapTimeTable
    var dividerLabel: DividerLabel
    
    var stopWatchService: StopWatchService
    var timeToTextService: TimeToTextService
    
    var lapDoubleTap: UITapGestureRecognizer!
    
    init(startButton: StartButton = StartButton(),
         totalTimeLabel: TotalTimeLabel = TotalTimeLabel(hidden: true),
         lapTimeTable: LapTimeTable = LapTimeTable(hidden: true),
         stopWatchService: StopWatchService = StopWatchService(),
         timeToTextService: TimeToTextService = TimeToTextService(),
         dividerLabel: DividerLabel = DividerLabel(hidden: true)) {
        
        self.startButton = startButton
        self.totalTimeLabel = totalTimeLabel
        self.lapTimeTable = lapTimeTable
        self.dividerLabel = dividerLabel
        
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
    }
    
    func setBackgroundColor() {
        self.view.backgroundColor = UIColor.white
    }
    
    func addSubviews() {
        self.view.addSubview(startButton)
        self.view.addSubview(totalTimeLabel)
        self.view.addSubview(lapTimeTable) // TODO: UNTESTED
        self.view.addSubview(dividerLabel) // TODO: UNTESTED
    }
    
    func applyConstraints() { // TODO: UNTESTED
        MainViewControllerConstraints.positionStartButton(startButton: startButton)
        MainViewControllerConstraints.positionTotalTimeLabel(totalTimeLabel: totalTimeLabel)
        MainViewControllerConstraints.positionLapTimeTable(lapTimeTable: lapTimeTable, totalTimeLabel: totalTimeLabel)
        MainViewControllerConstraints.positionDividerLabel(dividerLabel: dividerLabel, lapTimeTable: lapTimeTable)
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
    func viewDoubleTapped() {
        stopWatchService.lap()
        
        // TODO: UNTESTED!
        DispatchQueue.main.async {
            self.lapTimeTable.setLapData(lapData: self.stopWatchService.lapTimes)
        }
        
    }
    
    func attachLapDoubleTapRecognizer() {
        lapDoubleTap = UITapGestureRecognizer(target: self, action: #selector(self.viewDoubleTapped))
        lapDoubleTap.numberOfTapsRequired = 2
        
        self.view.addGestureRecognizer(lapDoubleTap)
        self.view.isUserInteractionEnabled = true
    }
}

extension MainViewController: StartButtonDelegate {
    func onStartTap(sender: StartButton) {
        sender.hide()
        
        totalTimeLabel.show()
        lapTimeTable.show() // TODO: UNTESTED
        dividerLabel.show() // TODO: UNTESTED
        
        attachLapDoubleTapRecognizer()

        stopWatchService.start()
    }
}

extension MainViewController: StopWatchServiceDelegate {
    func stopWatchIntervalElapsed(totalTimeElapsed: TimeInterval) {
        totalTimeLabel.text = timeToTextService.timeAsSingleString(inputTime: totalTimeElapsed)
    }
    
    func stopWatchStopped() {
        
    }
    
    func stopWatchPaused() {
        
    }
    
    func stopWatchRestarted() {
        
    }
    
    func lapStored() {
        
    }
}

