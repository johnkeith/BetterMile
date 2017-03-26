//
//  DividerLabel.swift
//  GoTime
//
//  Created by John Keith on 2/13/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class DividerLabel: UILabel {
    init(hidden: Bool = true) {
        let defaultFrame = CGRect()
        super.init(frame: defaultFrame)
        
        self.isHidden = hidden
        self.backgroundColor = Constants.colorPalette["black"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
}
