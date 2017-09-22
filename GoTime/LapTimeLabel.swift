//
//  LapTimeLabel.swift
//  GoTime
//
//  Created by John Keith on 8/18/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class LapTimeLabel:UILabel {
    let defaultText = "Lap   00:00.00"
    
    override init(frame: CGRect = Constants.defaultFrame) {
        super.init(frame: frame)
        setTitleLabelDefaultAttrs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTextForLabel(_ txt: String) {
        text = "Lap   \(txt)"
    }
    
    private func setTitleLabelDefaultAttrs() {
        isHidden = true
        text = defaultText
        font = Constants.responsiveDigitFont
        adjustsFontSizeToFitWidth = true
        numberOfLines = 1
        baselineAdjustment = .alignCenters
        textAlignment = .center
        textColor = Constants.colorBlack
    }
}
