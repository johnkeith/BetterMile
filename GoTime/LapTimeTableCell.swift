//
//  LapTimeTableCell.swift
//  GoTime
//
//  Created by John Keith on 3/1/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class LapTimeTableCell: UITableViewCell {
    let label = UILabel(frame: CGRect())
    let line = UILabel(frame: CGRect())
    
    override init(style: UITableViewCellStyle = .default, reuseIdentifier: String? = "LapTimeTableCell") {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        self.setLabelAttributes(label: label)
        
        self.contentView.addSubview(label)
        self.contentView.addSubview(line)
                
        setColoration()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotificationOfDarkModeFlipped), name: Notification.Name(rawValue: Constants.notificationOfDarkModeToggle), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContent(labelText: String) {
        label.text = labelText
    }
    
    // TODO: UNTESTED
    func setLabelAttributes(label: UILabel) {
        label.font = Constants.responsiveDigitFont
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
    }
    
    // TODO: UNTESTED
    func addLabelAndLineConstraints(rowHeight: CGFloat) {
        // TODO: FIX - there must be a better place for this
        self.label.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(label.superview!)
            make.left.equalTo(label.superview!)
            make.height.equalTo(rowHeight)
        }
        
        self.line.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(line.superview!)
            make.height.equalTo(1)
        }
    }
}

extension LapTimeTableCell: RespondsToThemeChange {
    func handleNotificationOfDarkModeFlipped(notification: Notification) {
        let value = notification.userInfo?["value"] as! Bool
        
        setColoration(darkModeEnabled: value)
    }
    
    func setColoration(darkModeEnabled: Bool = Constants.storedSettings.bool(forKey: SettingsService.useDarkModeKey), animationDuration: Double = 0.0) {
        if darkModeEnabled {
            self.line.backgroundColor = Constants.colorPalette["white"]
        } else {
            self.line.backgroundColor = Constants.colorPalette["black"]
        }
        
        setTextColorBasedOnSettings(darkModeEnabled: darkModeEnabled)
    }
    
    func setTextColorBasedOnSettings(darkModeEnabled: Bool = Constants.storedSettings.bool(forKey: SettingsService.useDarkModeKey)) {
        if darkModeEnabled {
            self.label.textColor = Constants.colorPalette["white"]
            self.backgroundColor = Constants.colorPalette["black"]
        } else {
            self.label.textColor = Constants.colorPalette["black"]
            self.backgroundColor = Constants.colorPalette["white"]
        }
    }
}
