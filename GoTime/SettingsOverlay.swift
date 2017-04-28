//
//  SettingsOverlay.swift
//  GoTime
//
//  Created by John Keith on 3/18/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

protocol SettingsOverlayDelegate: class  {
    func onSettingsOverlayHide()
}

// TODO: UNTESTED - REMOVE?
class SettingsOverlay: UIView {
    var delegate: SettingsOverlayDelegate!
    
    var singleTapRecognizer: UITapGestureRecognizer! // TODO: SMELLY
    
    init(hidden: Bool = true) {
        super.init(frame: Constants.defaultFrame)
        
        self.isHidden = hidden
        self.backgroundColor = UIColor.clear
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.addSubview(blurEffectView)
        
        singleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hide))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    func attachMenuDismissRecognizer() {
        self.addGestureRecognizer(singleTapRecognizer)
    }
    
    func removeMenuDismissRecognizer() {
        self.removeGestureRecognizer(singleTapRecognizer)
    }
    
    override func hide() {
        removeMenuDismissRecognizer()
        
        delegate.onSettingsOverlayHide()
        
        isHidden = true
    }
    
    override func show() {
        attachMenuDismissRecognizer()
        
        isHidden = false
    }
}
