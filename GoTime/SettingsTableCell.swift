//
//  SettingsTableCell.swift
//  GoTime
//
//  Created by John Keith on 4/9/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class SettingsTableCell: UITableViewCell {
    let label = UILabel(frame: CGRect())
    let toggleSwitch = UISwitch(frame: CGRect())
    
    override init(style: UITableViewCellStyle = .default, reuseIdentifier: String? = "SettingsTableCell") {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        self.contentView.addSubview(label)
        self.contentView.addSubview(toggleSwitch)
        
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContent(displayName: String, toggleFn: () -> ()) {
        label.text = displayName
    }
    
    func addConstraints() {
//        label.snp.makeConstraints { (make) in
//            make.height.equalTo(self.frame.size.height)
//            make.width.equalTo(self.frame.size.width - self.toggleSwitch.frame.size.width)
//        }
    }
}

