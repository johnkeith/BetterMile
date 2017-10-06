//
//  IncrementControl.swift
//  GoTime
//
//  Created by John Keith on 10/5/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

protocol IncrementControlDelegate: class {
    func onIncrementChangeHandler(newValue: Int)
}

class IncrementControl: UIView {
    let minusButton = UIButton()
    let plusButton = UIButton()
    let value = UILabel()
    let label = UILabel()
    var delegate: IncrementControlDelegate?
    
    init(val: Int, lbl: String) {
        super.init(frame: Constants.defaultFrame)
        
        configMinusButton()
        configPlusButton()
        configValue(val: val)
        configLabel(lbl: lbl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onMinusTap() {
        
    }
    
    func onPlusTap() {
        
    }
    
    func addConstraints() {
        let buttonWidth = self.frame.width / 4
        let borderRadius = buttonWidth / 2
        let valueWidth = self.frame.width / 6
        let labelWidth = self.frame.width / 3
        
        minusButton.snp.makeConstraints { make in
            make.height.equalTo(buttonWidth)
            make.left.equalTo(self)
            make.width.equalTo(buttonWidth)
        }
        
        minusButton.layer.cornerRadius = borderRadius
        
        plusButton.snp.makeConstraints { make in
            make.height.equalTo(buttonWidth)
            make.right.equalTo(self)
            make.width.equalTo(buttonWidth)
        }
        
        plusButton.layer.cornerRadius = borderRadius
    
        value.snp.makeConstraints { make in
            make.height.equalTo(self)
            make.left.equalTo(minusButton)
            make.width.equalTo(valueWidth)
        }
        
        label.snp.makeConstraints { make in
            make.height.equalTo(self)
            make.right.equalTo(plusButton)
            make.width.equalTo(labelWidth)
        }
    }
    
    private func configMinusButton() {
        addSubview(minusButton)
        
        minusButton.titleLabel?.text = "-"
        minusButton.titleLabel?.tintColor = Constants.colorGreen
        
        minusButton.layer.borderWidth = 1
        minusButton.layer.borderColor = Constants.colorGreen.cgColor
    }
    
    private func configPlusButton() {
        addSubview(plusButton)
        
        plusButton.titleLabel?.text = "+"
        plusButton.titleLabel?.tintColor = Constants.colorGreen
        
        plusButton.layer.borderWidth = 1
        plusButton.layer.borderColor = Constants.colorGreen.cgColor
    }
    
    private func configValue(val: Int) {
        addSubview(value)
        
        value.text = String(val)
        value.textAlignment = .center
    }
    
    private func configLabel(lbl: String) {
        addSubview(label)
        
        label.text = String(lbl)
        label.textAlignment = .center
    }
}
