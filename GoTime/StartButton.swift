//
//  StartButton.swift
//  GoTime
//
//  Created by John Keith on 7/15/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class StartButton:UIButton {
    override init(frame: CGRect = Constants.defaultFrame) {
        super.init(frame: frame)
        setTitleLabelDefaultAttrs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTitleLabelDefaultAttrs() {
        setTitle("START", for: UIControlState.normal)
        setTitleColor(Constants.colorPalette["FG"], for: UIControlState.normal)
    
        titleLabel?.font = Constants.responsiveDigitFont
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.numberOfLines = 1
        titleLabel?.baselineAdjustment = .alignCenters
        titleLabel?.textAlignment = .center
    }
}
