//
//  UIViewExtension.swift
//  GoTime
//
//  Created by John Keith on 3/26/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

protocol GTComponent: class {
    func hide()
    
    func show()
}

extension UIView: GTComponent {
    func hide() {
        self.isHidden = true
    }
    
    func show() {
        self.isHidden = false
    }
}

protocol GTController: class {
    func addSubviews(_ viewsToAdd: [UIView])
}

extension UIViewController: GTController {
    func addSubviews(_ viewsToAdd: [UIView]) {
        for _view in viewsToAdd {
            self.view.addSubview(_view)
        }
    }
}

