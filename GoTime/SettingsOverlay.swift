//
//  SettingsOverlay.swift
//  GoTime
//
//  Created by John Keith on 3/18/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

// TODO: UNTESTED
class SettingsOverlay: UIView {
    init(hidden: Bool = true) {
        let defaultFrame = CGRect()
        
        super.init(frame: defaultFrame)
        
        self.isHidden = hidden
        
        self.backgroundColor = Constants.colorPalette["white"]
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
