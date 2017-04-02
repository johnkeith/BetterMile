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
    
    func animateButtonFromOrigin(duration: Double = 1.0) {
        self.initialMiddlePoint = self.frame.origin
        
        let initialWidth = self.frame.width
        let initialHeight = self.frame.height
        
        let anim = CAKeyframeAnimation(keyPath: "position")
        let path = UIBezierPath()
        let moveToPoint = self.constructMoveToPointFromSuperview()
        print(moveToPoint)
        path.move(to: initialMiddlePoint)
        
        // use below function with control points of top left and top right depending on the enum
        path.addQuadCurve(to: moveToPoint, controlPoint: CGPoint(x: 0, y: 0))
//        path.addCurve(to: moveToPoint, controlPoint1: CGPoint(x: 100, y: 100), controlPoint2: CGPoint(x: 150, y:150))
        
        anim.path = path.cgPath
        anim.duration = duration
        
        print(self.layer.frame)
        self.layer.add(anim, forKey: "testing animating")
        
        self.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(moveToPoint.y)
            make.left.equalTo(moveToPoint.x)
            make.height.equalTo(initialHeight * 3)
            make.width.equalTo(initialWidth * 3)
        }
        
        UIView.animate(withDuration: duration, animations: {
//            self.transform = CGAffineTransform(scaleX: 4, y: 4)
//            self.transform = CGAffineTransform(translationX: -50, y: -50)
//            self.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        })
    }
    
    func constructMoveToPointFromSuperview() -> CGPoint {
        let x = Double(self.superview!.frame.width) * xMultiple
        let y = Double(self.superview!.frame.width) * yMultiple
        
        return CGPoint(x: x, y: y)
    }
    
    func animateButtonToOrigin(duration: Double = 0.3) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform.identity
        })
    }
}
