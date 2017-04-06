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
    
    lazy var xMultiple = 1.0
    lazy var yMultiple = 1.0
    lazy var arcDirection = ArcDirections.right
    lazy var titleText = "OFF"
    
    var initialMiddlePoint: CGPoint! // TODO: Smelly!
    
    init(hidden: Bool = false) {
        super.init(frame: Constants.defaultFrame)
        
        self.isHidden = hidden
        self.backgroundColor = Constants.colorPalette["black"]
        self.setTitle(titleText, for: UIControlState.normal)
        
        hideTitle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.bounds.size.height / 2.0
    }
    
    func animateButtonFromOrigin(duration: Double = 0.3) {
        if self.initialMiddlePoint == nil {
            self.initialMiddlePoint = self.frame.origin
        }
        
        let anim = CAKeyframeAnimation(keyPath: "position")
        let path = UIBezierPath()
        let moveToPoint = self.constructMoveToPointFromSuperview()
        let newButtonSize = self.superview!.frame.width * (1/6)
        
        path.move(to: initialMiddlePoint)
        
        path.addQuadCurve(to: moveToPoint, controlPoint: CGPoint(x: 0, y: 0))
        
        anim.path = path.cgPath
        anim.duration = duration
        anim.calculationMode = kCAAnimationCubicPaced
        
        self.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(moveToPoint.y)
            make.left.equalTo(moveToPoint.x)
            make.height.equalTo(newButtonSize)
            make.width.equalTo(newButtonSize)
        }
        
        self.setTitleColor(Constants.colorPalette["white"], for: UIControlState.normal)
        
        self.layer.add(anim, forKey: "testing animating")
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
            make.top.equalTo(initialMiddlePoint.y)
            make.left.equalTo(initialMiddlePoint.x)
            make.height.equalTo(newButtonSize)
            make.width.equalTo(newButtonSize)
        }
        
        hideTitle()
    }
    
    private func constructMoveToPointFromSuperview() -> CGPoint {
        let x = Double(self.superview!.frame.width) * xMultiple
        let y = Double(self.superview!.frame.height) * yMultiple
        
        return CGPoint(x: x, y: y)
    }
    
    private func hideTitle() {
        self.setTitleColor(UIColor.clear, for: UIControlState.normal)
    }
}
