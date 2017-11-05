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
    var animationService: AnimationService
    
    init(hidden: Bool = true, animationService: AnimationService = AnimationService()) {
        let defaultFrame = CGRect()
        
        self.animationService = animationService

        super.init(frame: defaultFrame)
        
        self.isHidden = hidden
        
        self.text = "Double-tap to lap!"
        self.font = UIFont.preferredFont(forTextStyle: .title1)
        self.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    func showBriefly() {
        self.animationService.animateWithSpring(self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.animationService.animateFadeOutView(self, duration: 2.0)
        }
    }
}
