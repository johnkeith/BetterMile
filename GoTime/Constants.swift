//
//  Constants.swift
//  GoTime
//
//  Created by John Keith on 1/21/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

struct Constants {
    static let colorBackground = UIColor(hex: "FC5130")
    static let colorBackgroundMedium = colorBackground.darker(by: 20)
    static let colorBackgroundDark = colorBackground.darker(by: 50)
    static let colorWhite = UIColor.white
    static let colorClear = UIColor.clear
    static let colorBlack = UIColor(hex: "050401")
    static let colorGreen = UIColor(red:0.40, green:0.75, blue:0.65, alpha:1.0)
    static let colorDivider = UIColor(red:0.14, green:0.14, blue:0.14, alpha:1.0)
    static let colorGray = UIColor(hex: "D8D8D8")
    static let colorDarkModeBorderGray = UIColor(hex: "2A2927")
    static let colorRed = UIColor(hex: "FC5130")
    
    static let responsiveDefaultFontWeight = UIFont.Weight.regular
    static let responsiveDefaultFont: UIFont = UIFont.systemFont(ofSize: 999, weight: responsiveDefaultFontWeight)
    static let responsiveBoldDigitFont: UIFont = UIFont.monospacedDigitSystemFont(ofSize: 999, weight: UIFont.Weight.bold)
    static let responsiveFancyFont = UIFont.italicSystemFont(ofSize: 999)
    static let responsiveDigitFontWeight = UIFont.Weight.light
    static let responsiveDigitFont: UIFont = UIFont.monospacedDigitSystemFont(ofSize: 999, weight: responsiveDigitFontWeight)
    static let defaultSmallFont: UIFont = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.thin)
    static let defaultHeaderFont: UIFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
    static let defaultHeadlineFont: UIFont = UIFont.preferredFont(forTextStyle: .headline)
    static let defaultSubtextFont: UIFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
    
    static let defaultFrame: CGRect = CGRect()
    static let defaultMargin: Int = 20
    
    static let tableBottomInset: CGFloat = 204.0
    static let lapTimeTableCellHeight: CGFloat = 60.0
    
    static let storedSettings = UserDefaults.standard
    
    static let tableRowHeightDivisor = CGFloat(9)
    
    static let notificationOfDarkModeToggle = "com.goTime.notificationOfDarkModeToggle"
    static let appRunTimes = "com.goTime.appRuns"
    
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
