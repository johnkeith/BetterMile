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
    
    func setColoration() {
        self.line.backgroundColor = UIColor(red:0.14, green:0.14, blue:0.14, alpha:1.0)
        self.label.textColor = Constants.colorPalette["_white"]
        self.backgroundColor = Constants.colorPalette["_black"]
    }
}
