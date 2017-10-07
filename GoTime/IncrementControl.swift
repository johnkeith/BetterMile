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
    let minValue = 0
    let minusButton = UIButton()
    let plusButton = UIButton()
    let label = UILabel()
    
    var _value: Int
    var value: Int {
        get {
            return _value
        }
        set(newValue) {
            if(newValue < minValue) {
                _value = minValue
            } else {
                _value = newValue
            }
            updateLabel()
        }
    }
    
    var labelText: String
    var delegate: IncrementControlDelegate?
    
    init(value: Int, labelText: String) {
        self._value = value
        self.labelText = labelText
        
        super.init(frame: Constants.defaultFrame)
        
        configMinusButton()
        configPlusButton()
        configLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onMinusTap() {
        label.enlargeBriefly(duration: 0.4, scale: 1.1)
        value -= 1
    }
    
    @objc func onPlusTap() {
        label.enlargeBriefly(duration: 0.4, scale: 1.1)
        value += 1
    }
    
    func configConstraints() {
        let quarterOfFrame = self.frame.width / 4
        let buttonWidth = quarterOfFrame > 44 ? quarterOfFrame : 44
        let borderRadius = buttonWidth / 2
        let labelWidth = self.frame.width / 2
        
        minusButton.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.height.equalTo(buttonWidth)
            make.left.equalTo(self)
            make.width.equalTo(buttonWidth)
        }
        
        minusButton.layer.cornerRadius = borderRadius
        
        plusButton.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.height.equalTo(buttonWidth)
            make.right.equalTo(self)
            make.width.equalTo(buttonWidth)
        }
        
        plusButton.layer.cornerRadius = borderRadius
        
        label.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self)
            make.height.equalTo(self)
            make.width.equalTo(labelWidth)
        }
        
        plusButton.layoutIfNeeded()
        
        print("PLUS BUTTOn", plusButton.frame)
        label.layoutIfNeeded()
    }
    
    private func configMinusButton() {
        addSubview(minusButton)
        
        minusButton.setTitle("-", for: .normal)
        minusButton.setTitleColor(Constants.colorGreen, for: .normal)
        
        minusButton.layer.borderWidth = 1
        minusButton.layer.borderColor = Constants.colorGreen.cgColor
        minusButton.addTarget(self, action: #selector(onMinusTap), for: .touchDown)
    }
    
    private func configPlusButton() {
        addSubview(plusButton)
        
        plusButton.setTitle("+", for: .normal)
        plusButton.setTitleColor(Constants.colorGreen, for: .normal)
        
        plusButton.layer.borderWidth = 1
        plusButton.layer.borderColor = Constants.colorGreen.cgColor
        plusButton.addTarget(self, action: #selector(onPlusTap), for: .touchDown)
    }
    
    private func configLabel() {
        addSubview(label)
    
        label.textAlignment = .center
        label.textColor = Constants.colorBlack
        updateLabel()
    }
    
    private func updateLabel() {
        label.text = "\(value) \(labelText)"
    }
}
