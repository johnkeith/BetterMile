//
//  AnimationService.swift
//  GoTime
//
//  Created by John Keith on 3/6/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class AnimationService {
    func animateFadeInView(viewToFadeIn: UIView, duration: Double = 0.3) {
        UIView.animate(withDuration: duration, animations: {
            viewToFadeIn.alpha = 1.0
        })
    }
    
    func animateFadeOutView(viewToFadeOut: UIView, duration: Double = 0.3) {
        UIView.animate(withDuration: duration, animations: {
            viewToFadeOut.alpha = 0.0
        }, completion: { finished in
            viewToFadeOut.isHidden = true
            viewToFadeOut.alpha = 1.0
        })
    }
}
