//
//  SettingsButton.swift
//  GoTime
//
//  Created by John Keith on 9/3/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class SettingsButton:UIView {
    let label = UILabel()
    
    init(isHidden: Bool = true, frame: CGRect = Constants.defaultFrame) {
        super.init(frame: frame)
        
        self.isHidden = isHidden
        backgroundColor = Constants.colorBackgroundMedium
        
        addLabel()
        addTapRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabelConstraints() {
        label.snp.makeConstraints { make in
            make.width.equalTo(label.superview!.snp.width).offset(-Constants.defaultMargin * 2)
            make.height.equalTo(label.superview!.snp.height).offset(-Constants.defaultMargin)
            make.center.equalTo(label.superview!)
        }
    }
    
    @objc private func onTap() {
        print("SHOW SETTINGS MODAL")
    }
    
    private func addLabel() {
        addSubview(label)
        
        setLabelDefaultAttrs()
    }
    
    private func setLabelDefaultAttrs() {
        label.text = "SETTINGS"
//        label.font = UIFont.monospacedDigitSystemFont(ofSize: 25, weight: Constants.responsiveDigitFontWeight)
        label.font = Constants.responsiveDigitFont
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.textColor = Constants.colorWhite
        label.backgroundColor = Constants.colorClear
    }
    
    private func addTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        
        tapRecognizer.delegate = self as? UIGestureRecognizerDelegate
        
        addGestureRecognizer(tapRecognizer)
    }
}


