//
//  LapTimeViewController.swift
//  GoTime
//
//  Created by John Keith on 4/8/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

// TODO: UNTESTED
class LapTimeViewController: UIViewController {
    var stopWatchService: StopWatchService
    var lapTimeTable: LapTimeTable
    var fadeOverlayView: FadeOverlayView
    var bottomDividerLabel: DividerLabel
    var topDividerLabel: DividerLabel
    var lapTimeTableEmptyLabel: LapTimeTableEmptyLabel
    
    init(stopWatchService: StopWatchService,
         lapTimeTable: LapTimeTable = LapTimeTable(hidden: false),
         fadeOverlayView: FadeOverlayView = FadeOverlayView(),
         bottomDividerLabel: DividerLabel = DividerLabel(hidden: false),
         topDividerLabel: DividerLabel = DividerLabel(hidden: false),
         lapTimeTableEmptyLabel: LapTimeTableEmptyLabel = LapTimeTableEmptyLabel()) {
        
        self.stopWatchService = stopWatchService
        self.lapTimeTable = lapTimeTable
        self.fadeOverlayView = fadeOverlayView
        self.bottomDividerLabel = bottomDividerLabel
        self.topDividerLabel = topDividerLabel
        self.lapTimeTableEmptyLabel = lapTimeTableEmptyLabel
    
        super.init(nibName: nil, bundle: nil)
        
        self.stopWatchService.delegates.append(self)
        
        addSubviews([lapTimeTable, fadeOverlayView, bottomDividerLabel, topDividerLabel, lapTimeTableEmptyLabel])
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = Constants.colorPalette["white"]
        self.view.isUserInteractionEnabled = true
    }
    
    func addConstraints() {
        LapTimeViewControllerConstraints.positionLapTimeTable(lapTimeTable: lapTimeTable)
        LapTimeViewControllerConstraints.positionFadeOverlayView(fadeOverlayView: fadeOverlayView, lapTimeTable: lapTimeTable)
        LapTimeViewControllerConstraints.positionBottomDividerLabel(dividerLabel: bottomDividerLabel)
        LapTimeViewControllerConstraints.positionTopDividerLabel(dividerLabel: topDividerLabel)
        LapTimeViewControllerConstraints.positionLapTimeTableEmptyLabel(lapTimeTableEmptyLabel: lapTimeTableEmptyLabel, lapTimeTable: lapTimeTable)
    }
}

extension LapTimeViewController: StopWatchServiceDelegate {
    func stopWatchStarted() {
        lapTimeTableEmptyLabel.fadeOut()
        
        DispatchQueue.main.async {
            self.lapTimeTable.setLapData(lapData: self.stopWatchService.lapTimes.reversed())
            self.lapTimeTable.reloadData()
        }
    }
    
    func stopWatchIntervalElapsed(totalTimeElapsed: TimeInterval) {
        DispatchQueue.main.async {
            self.lapTimeTable.setLapData(lapData: self.stopWatchService.lapTimes.reversed())
            self.lapTimeTable.reloadCurrentLapRow()
        }
    }
    
    func stopWatchStopped() {
        lapTimeTable.clearLapData()
        
        lapTimeTableEmptyLabel.fadeIn()
    }
    
    func stopWatchPaused() {}
    func stopWatchRestarted() {}
    func stopWatchLapStored(lapTime: Double, lapNumber: Int) {}
}
