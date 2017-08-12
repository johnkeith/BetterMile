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
        
        setColoration()
        
        gradientLayer.locations = [0.0, 1.0]
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    func setColoration() {
        let firstColor = UIColor(white: 0, alpha: 0).cgColor
        let secondColor = UIColor(white: 0, alpha: 0.2).cgColor
        
        self.gradientLayer.colors = [firstColor, secondColor]
    }
    
    func setGradientSizeToMatchView(_ view: UIView) {
        snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottom)
            make.width.equalTo(view.snp.width)
            make.left.equalTo(view.snp.left)
        }
        
        layoutIfNeeded()
        
        gradientLayer.frame = bounds
    }
}
