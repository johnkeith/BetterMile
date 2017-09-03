//
//  UILabelExtension.swift
//  GoTime
//
//  Created by John Keith on 9/3/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// The receiver’s font size, including any adjustment made to fit to width. (read-only)
    ///
    /// If `adjustsFontSizeToFitWidth` is not `true`, this is just an alias for
    /// `.font.pointSize`. If it is `true`, it returns the adjusted font size.
    ///
    /// Derived from: [http://stackoverflow.com/a/28285447/5191100](http://stackoverflow.com/a/28285447/5191100)
    var fontSize: CGFloat {
        get {
            if adjustsFontSizeToFitWidth {
                var currentFont: UIFont = font
                let originalFontSize = currentFont.pointSize
                var currentSize: CGSize = (text! as NSString).size(attributes: [NSFontAttributeName: currentFont])
                
                while currentSize.width > frame.size.width && currentFont.pointSize > (originalFontSize * minimumScaleFactor) {
                    currentFont = currentFont.withSize(currentFont.pointSize - 1)
                    currentSize = (text! as NSString).size(attributes: [NSFontAttributeName: currentFont])
                }
                
                return currentFont.pointSize
            }
            
            return font.pointSize
        }
    }
}
