//
//  SettingsButton.swift
//  GoTime
//
//  Created by John Keith on 3/26/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class SettingsButton: UIButton {
    // will need to have a method to animate
    // will need subclasses to define the where and when
    // will need method to toggle certain setting
    // will need subclasses to define which setting to toggle
    lazy var finishX = 0
    lazy var finishY = 0
    
    // need to store origin point before animation, then access the origin when moving back
    
    init(hidden: Bool = false) {
        super.init(frame: Constants.defaultFrame)
        
        self.isHidden = hidden
        self.backgroundColor = Constants.colorPalette["black"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.bounds.size.height / 2.0
    }
    
    func animateButtonFromOrigin(duration: Double = 0.3) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.transform = CGAffineTransform(translationX: -50, y: -50)
//            self.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        })
    }
    
    func animateButtonToOrigin(duration: Double = 0.3) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform.identity
        })
    }
}
