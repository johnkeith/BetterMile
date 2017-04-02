//
//  SettingsButton.swift
//  GoTime
//
//  Created by John Keith on 3/26/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class SettingsButton: UIButton {
    enum ArcDirections {
        case right
        case left
    }
    
    // will need to have a method to animate
    // will need subclasses to define the where and when
    // will need method to toggle certain setting
    // will need subclasses to define which setting to toggle
    // need to store origin point before animation, then access the origin when moving back
    // All we will need a x mutlipler and y multipler floats and a direction
    
    lazy var xMultiple = 1.0
    lazy var yMultiple = 1.0
    lazy var arcDirection = ArcDirections.right
    
    var initialMiddlePoint: CGPoint! // smelly!
    
    init(hidden: Bool = false) {
        super.init(frame: Constants.defaultFrame)
        
        self.isHidden = hidden
        self.backgroundColor = Constants.colorPalette["black"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.bounds.size.height / 2.0
    }
    
//    func animateButtonFromOrigin(duration: Double = 1.0) {
//        UIView.animate(withDuration: duration, animations: {
//            let initialWidth = self.frame.width
//            let initialHeight = self.frame.height
//            let moveToPoint = self.constructMoveToPointFromSuperview()
//
//            self.snp.remakeConstraints { (make) -> Void in
//                make.top.equalTo(moveToPoint.y)
//                make.left.equalTo(moveToPoint.x)
//                make.height.equalTo(initialHeight * 3)
//                make.width.equalTo(initialWidth * 3)
//            }
//            
//            self.superview!.layoutIfNeeded()
//        })
//    }
    
    func animateButtonFromOrigin(duration: Double = 0.3) {
        if self.initialMiddlePoint == nil {
            self.initialMiddlePoint = self.frame.origin
        }
        
        let anim = CAKeyframeAnimation(keyPath: "position")
        let path = UIBezierPath()
        let moveToPoint = self.constructMoveToPointFromSuperview()
        
        path.move(to: initialMiddlePoint)
        
        path.addQuadCurve(to: moveToPoint, controlPoint: CGPoint(x: 0, y: 0))
        
        anim.path = path.cgPath
        anim.duration = duration
        anim.calculationMode = kCAAnimationCubicPaced
        
        self.layer.add(anim, forKey: "testing animating")
        
        let newButtonSize = self.superview!.frame.width * (1/6)
        
        self.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(moveToPoint.y - (newButtonSize / 2))
            make.left.equalTo(moveToPoint.x - (newButtonSize / 2))
            make.height.equalTo(newButtonSize)
            make.width.equalTo(newButtonSize)
        }
        
        print("Frame after remaking constraints", self.frame)
//        print(self.layer.frame)
    }
    
    func constructMoveToPointFromSuperview() -> CGPoint {
        let x = Double(self.superview!.frame.width) * xMultiple
        let y = Double(self.superview!.frame.height) * yMultiple
        
        return CGPoint(x: x, y: y)
    }
    
    func animateButtonToOrigin(duration: Double = 0.3) {
        let currentMiddlePoint = self.frame.origin
        let anim = CAKeyframeAnimation(keyPath: "position")
        let path = UIBezierPath()
        
        path.move(to: currentMiddlePoint)
        
        path.addQuadCurve(to: initialMiddlePoint, controlPoint: CGPoint(x: 0, y: 0))
        
        anim.path = path.cgPath
        anim.duration = duration
        anim.calculationMode = kCAAnimationCubicPaced
        
        self.layer.add(anim, forKey: "testing animating")
        
        let newButtonSize = self.superview!.frame.width * (1/10) / 5

        self.snp.remakeConstraints { (make) -> Void in
//            print("Middle Point X ", initialMiddlePoint.x, " Middle Point Y ", initialMiddlePoint.y)
            make.top.equalTo(initialMiddlePoint.y)
            make.left.equalTo(initialMiddlePoint.x)
//            make.right.equalTo(100)
            make.height.equalTo(newButtonSize)
            make.width.equalTo(newButtonSize)
        }
        
        self.superview!.layoutIfNeeded()

        self.layoutIfNeeded()
        
        print("Frame after remaking constraints", self.frame)
//        self.frame.origin = initialMiddlePoint
//        print(initialMiddlePoint, self.layer.frame, self.bounds, self.frame.origin)
    }
}
