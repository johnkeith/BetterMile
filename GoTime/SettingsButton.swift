//
//  SettingsButton.swift
//  GoTime
//
//  Created by John Keith on 3/18/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class SettingsButton: UIButton {
    let image = UIImage(named: "#imageLiteral(resourceName: \"ic_more_horiz\")")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    
    init() {
        let defaultFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
        super.init(frame: defaultFrame)
        
//        self.tintColor = Constants.colorPalette["black"]
//        self.setImage(image, for: UIControlState.normal)
        
        setTitle("TEST", for: UIControlState.normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    func hide() {
        isHidden = true
    }
    
    func show() {
        isHidden = false
    }
}
