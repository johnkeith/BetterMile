//
//  Constants.swift
//  GoTime
//
//  Created by John Keith on 1/21/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

// TODO: UNTESTED
struct Constants {
    static let colorPalette: [String: UIColor] = [
        "blue-background": UIColor(red:0.01, green:0.53, blue:0.82, alpha:1.0),
        "gray": UIColor(red:0.50, green:0.55, blue:0.55, alpha:1.0),
        "light-orange": UIColor(red:0.97, green:0.36, blue:0.30, alpha:1.0),
        "dark-blue": UIColor(red:0.00, green:0.28, blue:0.56, alpha:1.0),
        "dark-gray": UIColor(red:0.06, green:0.15, blue:0.44, alpha:1.0),
        "dark-orange": UIColor(red:0.72, green:0.11, blue:0.05, alpha:1.0),
        "shadow-gray": UIColor(red:0.15, green:0.21, blue:0.21, alpha:1.0),
//        "black": UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0),
        "black": UIColor.black,
        "white": UIColor.white,
        "flat-green": UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.0),
        "flat-red": UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0),
        "_green": UIColor(red:0.40, green:0.75, blue:0.65, alpha:1.0),
        "_blue": UIColor(red:0.38, green:0.67, blue:0.90, alpha:1.0),
        "_red": UIColor(red:0.90, green:0.38, blue:0.55, alpha:1.0),
//        "_white": UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0),
        "_white": UIColor.white,
//        "_black": UIColor(red:0.14, green:0.14, blue:0.14, alpha:1.0),
        "_black": UIColor.black
    ]
    
    static let responsiveDefaultFont: UIFont = UIFont.systemFont(ofSize: 999, weight: UIFontWeightThin)
    static let responsiveBoldDigitFont: UIFont = UIFont.monospacedDigitSystemFont(ofSize: 999, weight: UIFontWeightBold)
    static let responsiveFancyFont = UIFont.italicSystemFont(ofSize: 999)
    static let responsiveDigitFont: UIFont = UIFont.monospacedDigitSystemFont(ofSize: 999, weight: UIFontWeightThin)
    static let defaultSmallFont: UIFont = UIFont.systemFont(ofSize: 18, weight: UIFontWeightThin)
    
    static let defaultFrame: CGRect = CGRect()
    static let defaultMargin: Int = 20
    
    static let tableBottomInset: CGFloat = 204.0
    static let lapTimeTableCellHeight: CGFloat = 60.0
    
    static let storedSettings = UserDefaults.standard
    
    static let timeBetweenVibrations = 0.8
    
    static let notificationOfSettingsToggle = "com.goTime.notificationOfSettingsToggle"
    static let notificationOfSubSettingsToggle = "com.goTime.notificationOfSubSettingsToggle"
    static let notificationOfDarkModeToggle = "com.goTime.notificationOfDarkModeToggle"
    
    // TODO: UNTESTED
    static func ordinalSuffixForNumber(number: Int) -> String {
        switch (number) {
        case 1:
            return "st"
        case 2:
            return "nd"
        case 3:
            return "rd"
        default:
            return "th"
        }
    }
}
