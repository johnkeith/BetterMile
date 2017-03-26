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
        
        self.text = "Double tap to lap.\nHold to pause."
        
        self.font = Constants.responsiveDefaultFont
        self.adjustsFontSizeToFitWidth = true
        self.numberOfLines = 2
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.animationService.animateFadeOutView(viewToFadeOut: self, duration: 2.0)
        }
    }
}
