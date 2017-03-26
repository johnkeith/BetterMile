//
//  VoiceNotificationsButton.swift
//  GoTime
//
//  Created by John Keith on 3/26/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class VoiceNotificationsButton: UIButton {
    init(hidden: Bool = false) {
        super.init(frame: Constants.defaultFrame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
}

extension VoiceNotificationsButton: GTComponent {
    func hide() {
        self.isHidden = true
    }
    
    func show() {
        self.isHidden = false
    }
}
