//
//  RestartButton.swift
//  GoTime
//
//  Created by John Keith on 4/30/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class RestartButton: UIButton {
    var stopWatchService: StopWatchService
    
    init(hidden: Bool = false, stopWatchService: StopWatchService) {
        let defaultFrame = CGRect()
        
        self.stopWatchService = stopWatchService

        super.init(frame: defaultFrame)
        
        self.isHidden = hidden
        self.tintColor = Constants.colorPalette["black"]
        
        addTarget(self, action:#selector(onTap), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    func onTap() {
        self.stopWatchService.restart()
    }
}
