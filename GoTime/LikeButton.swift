//
//  LikeButton.swift
//  GoTime
//
//  Created by John Keith on 7/31/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class LikeButton:UIButton {
    override init(frame: CGRect = Constants.defaultFrame) {
        super.init(frame: frame)
        
        setAttrs()
        
        addTarget(self, action:#selector(onTap), for: .touchDown)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onTap() {
        print("Time to review")
    }
    
    private func setAttrs() {
        let buttonImage = UIImage(named: "ic_favorite_border_48pt")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        tintColor = Constants.colorPalette["_white"]
        backgroundColor = Constants.colorPalette["_black"]
        setImage(buttonImage, for: .normal)
        setImage(buttonImage, for: .highlighted)
    }
}

