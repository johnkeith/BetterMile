//
//  SettingsView.swift
//  GoTime
//
//  Created by John Keith on 9/3/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class SettingsView:UIView {
    init(isHidden: Bool = true) {
        super.init(frame: Constants.defaultFrame)
        
        self.isHidden = isHidden
        
        backgroundColor = Constants.colorWhite
        layer.cornerRadius = 8.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configConstraints() {
        let _height = superview!.frame.height - CGFloat(Constants.defaultMargin * 4)
        let _width = superview!.frame.width - CGFloat(Constants.defaultMargin * 2)
        snp.makeConstraints { make in
            make.center.equalTo(superview!)
            make.height.equalTo(_height)
            make.width.equalTo(_width)
        }
    }
}
