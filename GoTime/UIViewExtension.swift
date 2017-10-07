//
//  UIViewExtension.swift
//  GoTime
//
//  Created by John Keith on 3/26/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

protocol GTComponent: class {
    func hide()
    
    func show()
}

extension UIView: GTComponent {
    func hide() {
        self.isHidden = true
    }
    
    func show() {
        self.isHidden = false
    }
    
    func addDebuggingBorders() {
        self.layer.borderColor = UIColor.purple.cgColor
        self.layer.borderWidth = 1
    }
}

protocol GTController: class {
    func addSubviews(_ viewsToAdd: [UIView])
}

extension UIViewController: GTController {
    func addSubviews(_ viewsToAdd: [UIView]) {
        for _view in viewsToAdd {
            self.view.addSubview(_view)
        }
    }
}

protocol GTAnimation: class {
    func enlargeBriefly(duration: Double, scale: CGFloat)
}

extension UIView: GTAnimation {
    func enlargeBriefly(duration: Double = 0.3, scale: CGFloat = 1.2) {
        UIView.animateKeyframes(withDuration: duration, delay: 0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.transform = .identity
            })
        }, completion: nil)
    }
}

