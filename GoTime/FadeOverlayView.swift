//
//  FadeOverlayView.swift
//  GoTime
//
//  Created by John Keith on 3/22/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

// TODO: UNTESTED
class FadeOverlayView: UIView {
    let gradientLayer = CAGradientLayer()
    
    init(hidden: Bool = false) {
        super.init(frame: Constants.defaultFrame)
        
        self.isHidden = hidden
        self.isUserInteractionEnabled = false

        let firstColor = UIColor(white: 1, alpha: 0).cgColor
        let secondColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6).cgColor

        gradientLayer.colors = [firstColor, secondColor]
        gradientLayer.locations = [0.0, 1.0]
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    func hide() {
        isHidden = true
    }
    
    func show() {
        isHidden = false
    }
}
