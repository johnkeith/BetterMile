//
//  AnimationService.swift
//  GoTime
//
//  Created by John Keith on 3/6/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class AnimationService {
    func animateFadeInView(_ viewToFadeIn: UIView, duration: Double = 0.3) {
        UIView.animate(withDuration: duration, animations: {
            viewToFadeIn.alpha = 1.0
        }, completion: { finished in
            viewToFadeIn.isHidden = false
        })
    }
    
    func animateFadeOutView(_ viewToFadeOut: UIView, duration: Double = 0.3) {
        UIView.animate(withDuration: duration, animations: {
            viewToFadeOut.alpha = 0.0
        }, completion: { finished in
            viewToFadeOut.isHidden = true
            viewToFadeOut.alpha = 1.0
        })
    }
    
//    TODO: UNTESTED
    func animateWithSpring(_ view: UIView, duration: Double = 0.3, fromAlphaZero: Bool = false) {
        view.isHidden = false
        view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        
        UIView.animate(withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 16.0,
            options: .allowUserInteraction,
            animations: {
                view.transform = .identity
                view.alpha = 1.0
        }, completion: nil)
    }

}
