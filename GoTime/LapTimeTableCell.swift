//
//  LapTimeTableCell.swift
//  GoTime
//
//  Created by John Keith on 3/1/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class LapTimeTableCell: UITableViewCell {
    override init(style: UITableViewCellStyle = .default, reuseIdentifier: String? = "LapTimeTableCell") {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: UNTESTED
    func setContent(labelText: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        label.text = labelText
        label.font = Constants.responsiveDigitFont
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        
        contentView.addSubview(label)
        
        label.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(label.superview!)
            make.height.equalTo(50)
        }
    }
}
