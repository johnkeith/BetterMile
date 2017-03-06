//
//  TimerHelpTextLabel.swift
//  GoTime
//
//  Created by John Keith on 3/5/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

// TODO: UNTESTED
class TimerHelpTextLabel: UILabel {
    init(hidden: Bool = false) {
        let defaultFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
        super.init(frame: defaultFrame)
        
        self.isHidden = hidden
        
        self.text = "Double tap to lap.\nPress and hold to pause."
        
        self.font = Constants.responsiveDefaultFont
        self.adjustsFontSizeToFitWidth = true
        self.numberOfLines = 0
        self.baselineAdjustment = .alignCenters
        self.textAlignment = .center
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
    
    func showBriefly() {
        show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
            self.hide()
        }
    }
}
