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

        isHidden = hidden
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setText(time: String) {
        self.text = time
    }
    
    func hide() { // UNTESTED
        isHidden = true
    }
    
    func show() { // UNTESTED
        isHidden = false
    }
}

