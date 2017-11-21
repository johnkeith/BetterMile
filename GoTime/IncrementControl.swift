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

// TODO: UNTESTED
class IncrementControl: UIView {
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
            
            delegate?.onIncrementChangeHandler(newValue: newValue)
        }
    }
    
    var labelText: String
    var minValue: Int
    var delegate: IncrementControlDelegate?
    
    var btnColor: UIColor? {
        didSet {
            minusButton.setTitleColor(btnColor, for: .normal)
            minusButton.layer.borderColor = btnColor!.cgColor
            plusButton.setTitleColor(btnColor, for: .normal)
            plusButton.layer.borderColor = btnColor!.cgColor
        }
    }
    
    var textColor: UIColor? {
        didSet {
            label.textColor = textColor
        }
    }
    
    var usesDarkMode: Bool = Constants.storedSettings.bool(forKey: SettingsService.darkModeKey) {
        didSet {
            self.setColorConstants()
        }
    }
    
    init(value: Int, labelText: String, minValue: Int) {
        self._value = value
        self.labelText = labelText
        self.minValue = minValue
        
        super.init(frame: Constants.defaultFrame)
        
        setColorConstants()
        
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
    }
    
    func refreshUsesDarkMode() {
        usesDarkMode = Constants.storedSettings.bool(forKey: SettingsService.darkModeKey)
    }
    
    private func setColorConstants() {
        btnColor = usesDarkMode ? Constants.colorWhite : Constants.colorGreen
        textColor = usesDarkMode ? Constants.colorWhite : Constants.colorBlack
    }
    
    private func configMinusButton() {
        addSubview(minusButton)
        
        minusButton.setTitle("-", for: .normal)
        
        minusButton.layer.borderWidth = 1
        
        minusButton.addTarget(self, action: #selector(onMinusTap), for: .touchDown)
    }
    
    private func configPlusButton() {
        addSubview(plusButton)
        
        plusButton.setTitle("+", for: .normal)
        
        plusButton.layer.borderWidth = 1
        
        plusButton.addTarget(self, action: #selector(onPlusTap), for: .touchDown)
    }
    
    private func configLabel() {
        addSubview(label)
    
        label.textAlignment = .center
        
        updateLabel()
    }
    
    private func updateLabel() {
        label.text = "\(value) \(labelText)"
    }
}
