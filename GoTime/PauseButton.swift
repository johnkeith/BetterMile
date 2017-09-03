//
//  PauseButton.swift
//  GoTime
//
//  Created by John Keith on 9/2/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class PauseButton:UIView {
    let label = UILabel()
    
    override init(frame: CGRect = Constants.defaultFrame) {
        super.init(frame: frame)
        
        backgroundColor = Constants.colorBackgroundDark
        
        addLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLabel() {
        addSubview(label)
        
        setLabelConstraints()
        setLabelDefaultAttrs()
    }
    
    private func setLabelConstraints() {
        label.snp.makeConstraints { make in
            make.width.equalTo(superview!.snp.width)
            make.height.equalTo(superview!.snp.height)
        }
    }
    
    private func setLabelDefaultAttrs() {
        label.text = "Pause"
        label.font = Constants.responsiveDigitFont
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.textColor = Constants.colorWhite
        label.backgroundColor = Constants.colorClear
    }
}

