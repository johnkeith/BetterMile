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
    
    init(stopWatchService: StopWatchService) {
        self.stopWatchService = stopWatchService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
    }
}
