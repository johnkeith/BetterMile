//
//  SettingsButton.swift
//  GoTime
//
//  Created by John Keith on 3/18/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class SettingsButton: UIButton {
    init() {
        let defaultFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let buttonImage = UIImage(named: "ic_more_horiz")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)

        super.init(frame: defaultFrame)
        
        self.tintColor = Constants.colorPalette["black"]
        self.setImage(buttonImage, for: UIControlState.normal)
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
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
