//
//  MainViewControllerConstraints.swift
//  GoTime
//
//  Created by John Keith on 1/22/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit
import SnapKit

class MainViewControllerConstraints {
    static let sharedInstance = MainViewControllerConstraints()
    private init() {}
    
    class func positionStartButton(startButton: UIButton) {
        startButton.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(startButton.superview!)
            make.height.equalTo(startButton.superview!.frame.height / 5)
            make.width.equalTo(startButton.superview!).offset(-40)
        }
    }
}
