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
        print("show alert")
        let message = "Do you love the Better Mile app?  Please rate us on the App Store!"
        let rateAlert = UIAlertController(title: "Rate Us", message: message, preferredStyle: .alert)
        let goToAppStoreAction = UIAlertAction(title: "Rate Us", style: .default, handler: { (action) in
            let url = URL(string: "itms-apps://itunes.apple.com/app/id1241810607")
            
            UIApplication.shared.open(url!)
        })
        
        let cancelAction = UIAlertAction(title: "Not Now", style: .cancel, handler: { (action) in
            print("cancel rating dialog")
        })
        
        rateAlert.addAction(cancelAction)
        rateAlert.addAction(goToAppStoreAction)
        
        DispatchQueue.main.async {
            //            TODO: NEED TO CALL FROM INSIDE THIS COMPONENT
//            let window = UIApplication.windows[0]
//            self.presentViewController(rateAlert, animated: true, completion: nil)
        }
    }
    
    private func setAttrs() {
        let buttonImage = UIImage(named: "ic_favorite_border_48pt")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        tintColor = Constants.colorPalette["FG"]
        backgroundColor = Constants.colorPalette["BG"]
        setImage(buttonImage, for: .normal)
        setImage(buttonImage, for: .highlighted)
    }
}

