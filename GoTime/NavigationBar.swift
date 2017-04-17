//
//  NavigationBar.swift
//  GoTime
//
//  Created by John Keith on 4/16/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class NavigationBar: UINavigationBar {
    init(title: String) {
        super.init(frame: Constants.defaultFrame)
    
        setNavItem(title: title)
    }

    func setNavItem(title: String) {
        let navItem = UINavigationItem()
        navItem.title = title
        
        self.items = [navItem]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
