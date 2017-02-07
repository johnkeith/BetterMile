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
    var stopWatchService: StopWatchService
    var timeToTextService: TimeToTextService
    var lapDoubleTap: UITapGestureRecognizer!
    
    init(startButton: StartButton = StartButton(),
         totalTimeLabel: TotalTimeLabel = TotalTimeLabel(hidden: true),
         stopWatchService: StopWatchService = StopWatchService(),
         timeToTextService: TimeToTextService = TimeToTextService()) {
        
        self.startButton = startButton
        self.totalTimeLabel = totalTimeLabel
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
    
    func viewDoubleTapped() { // TODO: UNTESTED
        stopWatchService.lap()
    }
    
    func setBackgroundColor() { // TODO: UNTESTED
        self.view.backgroundColor = UIColor.white
    }
    
    func addSubviews() { // TODO: UNTESTED
        self.view.addSubview(startButton)
        self.view.addSubview(totalTimeLabel)
    }
    
    func applyConstraints() { // TODO: UNTESTED
        MainViewControllerConstraints.positionStartButton(startButton: startButton)
        MainViewControllerConstraints.positionTotalTimeLabel(totalTimeLabel: totalTimeLabel)
    }
    
    func attachLapDoubleTapRecognizer() { // TODO: UNTESTED
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

