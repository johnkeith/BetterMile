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
    
    init(startButton: StartButton = StartButton()) {
        self.startButton = startButton
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        startButton.delegate = self
        self.view.addSubview(startButton)
        
        applyConstraints()
    }
    
    func applyConstraints() {
        MainViewControllerConstraints.positionStartButton(startButton: startButton)
    }
}

extension MainViewController: StartButtonDelegate {
    func onStartTap(sender: StartButton) {
        print("Start tap has been delegated")
        
        sender.hide()
    }
}

