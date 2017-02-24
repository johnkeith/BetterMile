//
//  TotalTimeLabel.swift
//  GoTime
//
//  Created by John Keith on 2/5/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class TotalTimeLabel: UILabel {
    init(hidden: Bool = false) {
        let defaultFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
        super.init(frame: defaultFrame)

        self.isHidden = hidden
        
        self.text = "00:00.00"
        
        self.font = Constants.responsiveDigitFont
        self.adjustsFontSizeToFitWidth = true
        self.numberOfLines = 1
        self.baselineAdjustment = .alignCenters
        self.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    func setText(time: String) {
        self.text = time
    }
    
    func hide() {
        isHidden = true
    }
    
    func show() {
        isHidden = false
    }
}

