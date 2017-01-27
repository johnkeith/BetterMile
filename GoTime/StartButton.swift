//
//  StartButtonView.swift
//  GoTime
//
//  Created by John Keith on 1/21/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class StartButton: UIButton {
    var delegate: StartButtonDelegate?
    
    // this is the init for when no frame is passed - StartButton()
    init() {
        let defaultFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
        super.init(frame: defaultFrame)
        
        sharedInit()
    }
    
    // this allows us to call StartButton(frame: ...) with a frame argument
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sharedInit()
    }
    
    // this allows us to create a StartButton through the Storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        sharedInit()
    }
    
    func sharedInit() {
        backgroundColor = Constants.colorPalette["white"]
        
        layer.borderWidth = 2
        layer.cornerRadius = 0
        layer.borderColor = Constants.colorPalette["black"]?.cgColor
        
        setTitle("START", for: UIControlState.normal)
        setTitleColor(Constants.colorPalette["black"], for: UIControlState.normal)
        
        addTarget(self, action:#selector(onStartTap), for: .touchUpInside)
    }
    
    func onStartTap(sender: StartButton) {
        delegate?.onStartTap(sender: sender)
    }
    
    func hide() {
        isHidden = true
    }
    
    func show() {
        isHidden = false
    }
}
