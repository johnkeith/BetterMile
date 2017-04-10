//
//  Constants.swift
//  GoTime
//
//  Created by John Keith on 1/21/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

struct Constants {
    static let colorPalette: [String: UIColor] = [
        "blue-background": UIColor(red:0.01, green:0.53, blue:0.82, alpha:1.0),
        "gray": UIColor(red:0.42, green:0.48, blue:0.54, alpha:1.0),
        "light-orange": UIColor(red:0.97, green:0.36, blue:0.30, alpha:1.0),
        "dark-blue": UIColor(red:0.00, green:0.28, blue:0.56, alpha:1.0),
        "dark-gray": UIColor(red:0.06, green:0.15, blue:0.44, alpha:1.0),
        "dark-orange": UIColor(red:0.72, green:0.11, blue:0.05, alpha:1.0),
        "shadow-gray": UIColor(red:0.15, green:0.21, blue:0.21, alpha:1.0),
        "black": UIColor.black,
        "white": UIColor.white
    ]
    
    static let responsiveDefaultFont: UIFont = UIFont.systemFont(ofSize: 999, weight: UIFontWeightThin)
    static let responsiveDigitFont: UIFont = UIFont.monospacedDigitSystemFont(ofSize: 999, weight: UIFontWeightLight)
    
    static let defaultFrame: CGRect = CGRect()
    static let defaultMargin: Int = 20
    
    static let tableBottomInset: CGFloat = 204.0
}
