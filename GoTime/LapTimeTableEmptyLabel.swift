//
//  LapTimeTableEmptyLabel.swift
//  GoTime
//
//  Created by John Keith on 4/9/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

// TODO: UNTESTED
class LapTimeTableEmptyLabel: UILabel {
    var animationService: AnimationService
    
    init(hidden: Bool = false, animationService: AnimationService = AnimationService()) {
        let defaultFrame = CGRect()
        
        self.animationService = animationService
        
        super.init(frame: defaultFrame)
        
        self.isHidden = hidden
        
        self.text = "No lap times to display"
        
        self.font = Constants.defaultSmallFont
        self.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    func fadeIn() {
        self.alpha = 0
        self.isHidden = false
        
        animationService.animateFadeInView(viewToFadeIn: self)
    }
    
    func fadeOut() {
        animationService.animateFadeOutView(viewToFadeOut: self)
    }
}
