//
//  SettingsOverlay.swift
//  GoTime
//
//  Created by John Keith on 3/18/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

// TODO: UNTESTED
class SettingsOverlay: UIView {
    var singleTapRecognizer: UITapGestureRecognizer! // TODO: SMELLY
    
    init(hidden: Bool = true) {
        super.init(frame: Constants.defaultFrame)
        
        self.isHidden = hidden
        self.backgroundColor = Constants.colorPalette["gray"]
        
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
        
        isHidden = true
    }
    
    override func show() {
        attachMenuDismissRecognizer()
        
        isHidden = false
    }
}
