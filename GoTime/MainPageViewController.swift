//
//  MainPageViewController.swift
//  GoTime
//
//  Created by John Keith on 4/8/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

// TODO: UNTESTED
class MainPageViewController: UIPageViewController {
    var stopWatchService: StopWatchService
    var timeToTextService: TimeToTextService
    
    var pageControl = UIPageControl()
    var doubleTapRecognizer: UITapGestureRecognizer! // TODO: SMELLY
    var longPressRecognizer: UILongPressGestureRecognizer! // TODO: SMELLY
    
    lazy var orderedViewControllers: [UIViewController] = {
        return [LapTimeViewController(stopWatchService: self.stopWatchService),
                RunningViewController(stopWatchService: self.stopWatchService),
                SettingsViewController()]
    }()
    
    init(stopWatchService: StopWatchService = StopWatchService(),
         timeToTextService: TimeToTextService = TimeToTextService()) {
        self.stopWatchService = stopWatchService
        self.timeToTextService = timeToTextService

        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Constants.colorPalette["white"]
        self.delegate = self
        self.dataSource = self
        self.stopWatchService.delegates.append(self)
        
        configurePageControl()
    
        setViewControllers([orderedViewControllers[1]],
                           direction: .forward,
                           animated: true,
                           completion: nil)
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 40, width: UIScreen.main.bounds.width, height: 40))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 1
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.gray
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        
        self.view.addSubview(pageControl)
    }
}

extension MainPageViewController: StopWatchServiceDelegate {
    func stopWatchStarted() {
        attachDoubleTapRecognizer()
        attachLongPressRecognizer()
    }
    
    func stopWatchIntervalElapsed(totalTimeElapsed: TimeInterval) {}
    
    func stopWatchStopped() {
        removeViewRecognizers()
    }
    
    func stopWatchPaused() {}
    func stopWatchRestarted() {}
    func stopWatchLapStored(lapTime: Double, lapNumber: Int) {
        let timeTuple = timeToTextService.timeAsMultipleStrings(inputTime: lapTime)
        
        let shouldSpeakPreviousLap = Constants.storedSettings.bool(forKey: SettingsService.previousLapTimeKey)
        let shouldSpeakAverageLap = Constants.storedSettings.bool(forKey: SettingsService.averageLapTimeKey)
        let shouldSpeakTotalTime = Constants.storedSettings.bool(forKey: SettingsService.totalTimeKey)
        
        if shouldSpeakPreviousLap {
//            ...
        }
        
//        use TimeToTextService to get the tuple with timeAsMultipleStrings
//        check and see what to speak from the UserDefaults
//        use the SpeechService to call the appropriate funcs
    }
}

extension MainPageViewController {
    func refreshLapTableData() {
        DispatchQueue.main.async {
            // TODO: UNTESTED (the reversing)
            let lapTimeViewController = self.orderedViewControllers[0] as! LapTimeViewController
            
            lapTimeViewController.lapTimeTable.setLapData(lapData: self.stopWatchService.lapTimes.reversed())
            lapTimeViewController.lapTimeTable.reloadData()
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
        longPressRecognizer.minimumPressDuration = 0.6
        
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

extension MainPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
       
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }
}

extension MainPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
             return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
             return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
}
