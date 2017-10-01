//
//  SettingsView.swift
//  GoTime
//
//  Created by John Keith on 9/3/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

protocol SettingsViewDelegate: class {
    func onSave()
}

class SettingsView:UIView {
    let titleLabel = UILabel()
    let saveButton = UIView()
    let saveButtonLabel = UILabel()
    let mileSettingsRow = SettingsViewRow(labelText: "Speak mile pace", sublabelText: "Laps per mile", userDefaultsKey: SettingsService.milePaceKey)
    let intervalSettingsRow = SettingsViewRow(labelText: "Sound at intervals", sublabelText: "After every", userDefaultsKey: SettingsService.intervalKey)
    
    var settingsRows: [SettingsViewRow]
    
    weak var delegate: SettingsViewDelegate?
    
    init(isHidden: Bool = true) {
        settingsRows = [mileSettingsRow, intervalSettingsRow]
        super.init(frame: Constants.defaultFrame)
        
        self.isHidden = isHidden
        
        backgroundColor = Constants.colorWhite
        clipsToBounds = true
        
        layer.cornerRadius = 16.0
        
        addtitleLabel()
        addSaveButton()
        addSettingsRows()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configConstraints() {
        let _height = superview!.frame.height - CGFloat(Constants.defaultMargin * 4)
        let _width = superview!.frame.width - CGFloat(Constants.defaultMargin)
        
        snp.makeConstraints { make in
            make.center.equalTo(superview!)
            make.height.equalTo(_height)
            make.width.equalTo(_width)
        }
        
        layoutIfNeeded()
        
        configTitleLabelConstraints()
        configSaveButtonConstraints()
        configSettingsRowConstraints()
    }
    
    @objc func onSave() {
        delegate!.onSave()
    }
    
    private func configTitleLabelConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(titleLabel.superview!)
            make.height.equalTo(superview!.frame.height / Constants.tableRowHeightDivisor)
            make.width.equalTo(titleLabel.superview!)
            make.top.equalTo(titleLabel.superview!)
        }
    }
    
    private func configSaveButtonConstraints() {
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(saveButton.superview!)
            make.height.equalTo(superview!.frame.height / Constants.tableRowHeightDivisor)
            make.left.equalTo(saveButton.superview!)
            make.width.equalTo(saveButton.superview!)
        }
        
        saveButton.layoutIfNeeded()
        
        saveButtonLabel.snp.makeConstraints { make in
            make.center.equalTo(saveButton)
            make.height.equalTo(saveButton)
            make.width.equalTo(saveButton.frame.width / 4)
        }
    }
    
    private func configSettingsRowConstraints() {
        for (index, row) in settingsRows.enumerated() {
            row.snp.makeConstraints { make in
                if index == 0 {
                    make.top.equalTo(titleLabel.snp.bottom)
                } else {
                    let previousRow = settingsRows[index - 1]
                    make.top.equalTo(previousRow.snp.bottom)
                }
                
                let heightDivisor: CGFloat
                
                if(row.settingIsEnabled()) {
                    heightDivisor = Constants.tableRowHeightDivisor / 2
                } else {
                    heightDivisor = Constants.tableRowHeightDivisor
                }
                
//                let margin = CGFloat(Constants.defaultMargin)
//                make.edges.equalTo(UIEdgeInsetsMake(margin, margin, margin, margin))

                make.height.equalTo(self.frame.height / heightDivisor)
                make.right.equalTo(self.snp.right)
                make.width.equalTo(row.superview!.frame.width - CGFloat(Constants.defaultMargin))
            }
            
            row.layoutIfNeeded()
                    
            row.configConstraints()
        }
    }
    
    private func addtitleLabel() {
        addSubview(titleLabel)
        
        titleLabel.font = Constants.defaultHeaderFont
        titleLabel.text = "Advanced Settings"
        titleLabel.textAlignment = .center
        titleLabel.textColor = Constants.colorBlack
    }
    
    private func addSaveButton() {
        addSubview(saveButton)
        
        saveButton.addSubview(saveButtonLabel)
        saveButton.backgroundColor = Constants.colorGreen
        
        saveButtonLabel.text = "Done"
        saveButtonLabel.font = Constants.defaultHeaderFont
        saveButtonLabel.textAlignment = .center
        saveButtonLabel.textColor = Constants.colorWhite
        
        addSaveButtonTapRecognizer()
    }
    
    private func addSettingsRows() {
        for row in settingsRows {
            addSubview(row)
        }
    }
    
    private func addSaveButtonTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onSave))
        
        tapRecognizer.delegate = self as? UIGestureRecognizerDelegate
        
        saveButton.addGestureRecognizer(tapRecognizer)
    }
}
