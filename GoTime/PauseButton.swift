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
    var stopWatchSrv: StopWatchService
    
    init(stopWatchSrv: StopWatchService, frame: CGRect = Constants.defaultFrame) {
        self.stopWatchSrv = stopWatchSrv
        
        super.init(frame: frame)
        
        backgroundColor = Constants.colorBackgroundDark
        
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
        stopWatchSrv.pause()
    }
    
    private func addLabel() {
        addSubview(label)
        
        setLabelDefaultAttrs()
    }
    
    private func setLabelDefaultAttrs() {
        label.text = "PAUSE"
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

