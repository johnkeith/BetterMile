//
//  AnimationService.swift
//  GoTime
//
//  Created by John Keith on 3/6/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class AnimationService {
    let screenBounds = UIScreen.main.bounds
    var screenHeight: CGFloat
    var screenWidth: CGFloat
    
    enum AnimationDirection {
        case left
        case right
    }
    
    init() {
        screenWidth = screenBounds.width
        screenHeight = screenBounds.height
    }
    
    func animate(_ fn: @escaping (() -> Void), duration: Double = 0.3) {
        UIView.animate(withDuration: duration, animations: fn)
    }
    
//    Works - just need to make sure the view has 0 alpha and is not hidden when launched
    func animateFadeInView(_ viewToFadeIn: UIView, duration: Double = 0.3, delay: Double = 0.0) {
        UIView.animate(withDuration: duration, delay: delay, animations: {
            viewToFadeIn.alpha = 1.0
        }, completion: { finished in
            viewToFadeIn.isHidden = false
        })
    }
    
    func animateFadeOutView(_ viewToFadeOut: UIView, duration: Double = 0.3, delay: Double = 0.0) {
        UIView.animate(withDuration: duration, delay: delay, animations: {
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

    func animateMoveVerticallyFromOffscreenBottom(_ view: UIView, duration: Double = 0.5) {
        view.isHidden = false
        
        let position =  CGAffineTransform(translationX: 0, y: screenHeight)
        
        view.transform = position
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 16.0,
                       options: .allowUserInteraction,
            animations: {
                view.transform = .identity
        })
    }
    
    func animateMoveVerticallyToOffscreenBottom(_ view: UIView, duration: Double = 0.5, completion: @escaping (Bool) -> Void = { success in }) {
        view.isHidden = false
        
        let position =  CGAffineTransform(translationX: 0, y: screenHeight)
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 16.0,
                       options: .allowUserInteraction,
                       animations: {
                        view.transform = position
        }, completion: completion)
    }
    
    func animateMoveHorizontallyFromOffscreen(_ view: UIView, direction: AnimationDirection, duration: Double = 0.5) {
        view.isHidden = false
        
        let position: CGAffineTransform
        
        if direction == AnimationDirection.left {
            position = CGAffineTransform(translationX: -1000, y: 0)
        } else {
            position = CGAffineTransform(translationX: 1000, y: 0)
        }
        
        view.transform = position
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 16.0,
                       options: .allowUserInteraction,
                       animations: {
                        view.transform = .identity
        })
    }
    
    func shakeBriefly(_ view: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 0
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 10, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 10, y: view.center.y))
        view.layer.add(animation, forKey: "position")
    }
    
    func enlargeBriefly(_ view: UIView, duration: Double = 0.3) {
        UIView.animateKeyframes(withDuration: duration, delay: 0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                view.transform = .identity
            })
        }, completion: nil)
    }
    
    func moveDownAndFade(_ view: UIView, duration: Double = 0.3) {
        view.isHidden = false
        view.alpha = 1
        
        let viewHeight = view.frame.height
        let transform = CGAffineTransform(translationX: 0, y: viewHeight / 2)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                view.transform = transform
                view.alpha = 0
            })
        }, completion: { complete in
            view.transform = .identity
        })
    }
    
    func animateTextChange(_ view: UIView, duration: CFTimeInterval = 0.8) {
//        NOT WORKING :(
//        let animation:CATransition = CATransition()
//        animation.timingFunction = CAMediaTimingFunction(name:
//            kCAMediaTimingFunctionEaseInEaseOut)
//        animation.type = kCATransitionReveal
//        animation.subtype = kCATransitionFromBottom
//        animation.duration = duration
//        view.layer.add(animation, forKey: kCATransitionPush)
    }
}
