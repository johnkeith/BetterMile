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
    var speechService: SpeechService
    
    var pageControl = UIPageControl()
    var doubleTapRecognizer: UITapGestureRecognizer! // TODO: SMELLY
    var longPressRecognizer: UILongPressGestureRecognizer! // TODO: SMELLY
        
    lazy var orderedViewControllers: [UIViewController] = {
        return [DashboardViewController(stopWatchService: self.stopWatchService),
                SettingsViewController()]
    }()
    
    init(stopWatchService: StopWatchService = StopWatchService(),
         timeToTextService: TimeToTextService = TimeToTextService(),
         speechService: SpeechService = SpeechService()) {
        self.stopWatchService = stopWatchService
        self.timeToTextService = timeToTextService
        self.speechService = speechService

        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotificationOfDarkModeFlipped), name: Notification.Name(rawValue: Constants.notificationOfDarkModeToggle), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        self.stopWatchService.delegates.append(self)
        
        configurePageControl()
        setColoration()
    
        setViewControllers([orderedViewControllers[0]],
                           direction: .forward,
                           animated: true,
                           completion: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotificationOfDarkModeFlipped), name: Notification.Name(rawValue: Constants.notificationOfDarkModeToggle), object: nil)
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 40, width: UIScreen.main.bounds.width, height: 40))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
        
        self.view.addSubview(pageControl)
    }
}

extension MainPageViewController: RespondsToThemeChange {
    func handleNotificationOfDarkModeFlipped(notification: Notification) {
        let value = notification.userInfo?["value"] as! Bool
        
        setColoration(darkModeEnabled: value)
    }
    
    func setColoration(darkModeEnabled: Bool = Constants.storedSettings.bool(forKey: SettingsService.useDarkModeKey), animationDuration: Double = 0.0) {
        if darkModeEnabled {
            self.view.backgroundColor = Constants.colorPalette["black"]
            self.pageControl.tintColor = Constants.colorPalette["white"]
            self.pageControl.pageIndicatorTintColor = Constants.colorPalette["gray"]
            self.pageControl.currentPageIndicatorTintColor = Constants.colorPalette["white"]
        } else {
            self.view.backgroundColor = Constants.colorPalette["white"]
            self.pageControl.tintColor = Constants.colorPalette["black"]
            self.pageControl.pageIndicatorTintColor = Constants.colorPalette["gray"]
            self.pageControl.currentPageIndicatorTintColor = Constants.colorPalette["black"]
        }
    }
}

extension MainPageViewController: StopWatchServiceDelegate {
    func stopWatchStarted() {
        attachDoubleTapRecognizer()
        attachLongPressRecognizer()
    }
    
    func stopWatchIntervalElapsed(totalTimeElapsed: TimeInterval) {}
    
    func stopWatchStopped() {
        if Constants.storedSettings.bool(forKey: SettingsService.timerClearedKey) {
            speechService.speakTimerCleared()
        }
        
        removeViewRecognizers()
    }
    
    func stopWatchPaused() {
        if Constants.storedSettings.bool(forKey: SettingsService.timerPausedKey) {
            speechService.speakTimerPaused()
        }
        
//        unregister long press
    }
    
    func stopWatchRestarted() {
//        attach long press
    }
    func stopWatchLapStored(lapTime: Double, lapNumber: Int, totalTime: Double) {
        let timeTuple = timeToTextService.timeAsMultipleStrings(inputTime: lapTime)
        let averageLapTime = stopWatchService.calculateAverageLapTime()
        let averageLapTimeTuple = timeToTextService.timeAsMultipleStrings(inputTime: averageLapTime)
        let totalTimeTuple = timeToTextService.timeAsMultipleStrings(inputTime: totalTime)
        
        let shouldSpeakPreviousLap = Constants.storedSettings.bool(forKey: SettingsService.previousLapTimeKey)
        let shouldSpeakAverageLap = Constants.storedSettings.bool(forKey: SettingsService.averageLapTimeKey)
        let shouldSpeakTotalTime = Constants.storedSettings.bool(forKey: SettingsService.totalTimeKey)
        
        if shouldSpeakPreviousLap {
            speechService.speakPreviousLapTime(timeTuple: timeTuple, lapNumber: lapNumber)
        }
        
        if shouldSpeakAverageLap {
            speechService.speakAverageLapTime(timeTuple: averageLapTimeTuple)
        }
        
        if shouldSpeakTotalTime {
            speechService.speakTotalTime(timeTuple: totalTimeTuple)
        }
    }
}

extension MainPageViewController {
    func refreshLapTableData() {
        let ctrl = self.orderedViewControllers[0] as! DashboardViewController
        
        ctrl.lapTimeTable.setLapData(lapData: self.stopWatchService.lapTimes.reversed())
        ctrl.lapTimeTable.reloadData()
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
