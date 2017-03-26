//
//  OpenSettingsButton.swift
//  GoTime
//
//  Created by John Keith on 3/18/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

protocol OpenSettingsButtonDelegate: class {
    func onSettingsTap(sender: OpenSettingsButton)
}

class OpenSettingsButton: UIButton {
    var delegate: OpenSettingsButtonDelegate!
    
    init(hidden: Bool = false) {
        let defaultFrame = CGRect()
        let buttonImage = UIImage(named: "ic_more_horiz")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)

        super.init(frame: defaultFrame)
        
        self.isHidden = hidden
        
        self.tintColor = Constants.colorPalette["black"]
//        self.setImage(buttonImage, for: UIControlState.normal)
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        self.layer.borderWidth = 1.0
        
        addTarget(self, action:#selector(onSettingsTap), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    func onSettingsTap(sender: OpenSettingsButton) {
        delegate.onSettingsTap(sender: sender)
    }
}
