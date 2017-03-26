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
        self.setLineAttributes(line: line)
        
        self.contentView.addSubview(label)
        self.contentView.addSubview(line)
        
        self.addLabelAndLineConstraints(label: label, line: line)
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
    func setLineAttributes(line: UILabel) {
        line.backgroundColor = Constants.colorPalette["black"]
    }
    
    // TODO: UNTESTED
    func addLabelAndLineConstraints(label: UILabel, line: UILabel) {
        // TODO: FIX - there must be a better place for this
        label.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(label.superview!)
            make.height.equalTo(60)
        }
        
        line.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(line.superview!)
            make.height.equalTo(2)
        }
    }
}
