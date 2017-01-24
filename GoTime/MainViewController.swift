//
//  ViewController.swift
//  GoTime
//
//  Created by John Keith on 1/17/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    let startButton = StartButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

