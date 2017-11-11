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

// TODO: UNTESTED
class SettingsView: UIView {
    let titleLabel = UILabel()
    let saveButton = UIView()
    let saveButtonLabel = UILabel()
    let scrollView = UIScrollView()
    
    var settingsRows: [SettingsViewRow]
    var averageLapSettingsRow: SettingsViewRow
    var vibrationSettingsRow: SettingsViewRow
    var mileSettingsRow: SettingsViewRow
    var intervalSettingsRow: SettingsViewRow
    var previousLapSettingsRow: SettingsViewRow
    var startStopSettingsRow: SettingsViewRow
    
    weak var saveDelegate: SettingsViewDelegate?
    
    init(isHidden: Bool = true) {
        let milePaceIncrementValue: Int = Constants.storedSettings.integer(forKey: SettingsService.milePaceAmountKey)
        let intervalAmount: Int = Constants.storedSettings.integer(forKey: SettingsService.intervalAmountKey)
        
        vibrationSettingsRow = SettingsViewRow(labelText: "Vibrate after lap", userDefaultsKey: SettingsService.vibrationNotificationsKey, kind: SettingsViewRowKind.vibration)
        startStopSettingsRow = SettingsViewRow(labelText: "Speak run start / stop", userDefaultsKey: SettingsService.speakStartStopKey, kind: SettingsViewRowKind.startStop)
        previousLapSettingsRow = SettingsViewRow(labelText: "Speak previous lap pace", userDefaultsKey: SettingsService.previousLapTimeKey, kind: SettingsViewRowKind.previousLap)
        averageLapSettingsRow = SettingsViewRow(labelText: "Speak average lap pace", userDefaultsKey: SettingsService.averageLapTimeKey, kind: SettingsViewRowKind.averageLap)
        mileSettingsRow = SettingsViewRow(labelText: "Speak mile pace", userDefaultsKey: SettingsService.milePaceKey, kind: SettingsViewRowKind.milePace, sublabelText: "Laps / mile", incrementValue: milePaceIncrementValue, incrementLabel: "", incrementMin: 1, incrementUserDefaultsKey: SettingsService.milePaceAmountKey)
        intervalSettingsRow = SettingsViewRow(labelText: "Notify at interval", userDefaultsKey: SettingsService.intervalKey, kind: SettingsViewRowKind.intervalPing, sublabelText: "Of every", incrementValue: intervalAmount, incrementLabel: "secs.", incrementMin: 1, incrementUserDefaultsKey: SettingsService.intervalAmountKey)
        
        settingsRows = [vibrationSettingsRow, startStopSettingsRow, previousLapSettingsRow, averageLapSettingsRow, mileSettingsRow, intervalSettingsRow]

        super.init(frame: Constants.defaultFrame)
        
        self.isHidden = isHidden
        
        backgroundColor = Constants.colorWhite
        clipsToBounds = true
        
        layer.cornerRadius = 16.0
        
        addtitleLabel()
        addSaveButton()
        addScrollView()
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
        configScrollViewConstraints()
        configSettingsRowConstraints()
        
        setScrollViewContentSize()
        scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
    }
    
    @objc func onSave() {
        saveDelegate!.onSave()
    }
    
    private func configTitleLabelConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(titleLabel.superview!)
            make.height.equalTo(superview!.frame.height / Constants.tableRowHeightDivisor)
            make.width.equalTo(titleLabel.superview!)
            make.top.equalTo(titleLabel.superview!)
        }
        
        titleLabel.layoutIfNeeded()
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
    
    private func configScrollViewConstraints() {
        scrollView.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(saveButton.snp.top)
            make.width.equalTo(self)
        }
        
        scrollView.layoutIfNeeded()
    }
    
    private func configSettingsRowConstraints() {
        for (index, row) in settingsRows.enumerated() {
            row.snp.remakeConstraints { make in
                if index == 0 {
                    make.top.equalTo(row.superview!.snp.top)
                } else {
                    let previousRow = settingsRows[index - 1]
                    make.top.equalTo(previousRow.snp.bottom)
                }
                
                let heightDivisor: CGFloat
                
                if(row.settingIsEnabled() && row.incrementControl != nil) {
                    heightDivisor = Constants.tableRowHeightDivisor / 2
                } else {
                    heightDivisor = Constants.tableRowHeightDivisor
                }

                make.height.equalTo(self.frame.height / heightDivisor)
                make.right.equalTo(self)
                
                let baseMargin = CGFloat(Constants.defaultMargin)
                
                make.width.equalTo(row.superview!.frame.width - baseMargin)
            }
            
            row.layoutIfNeeded()
                    
            row.configConstraints()
            
            if row.incrementControl != nil {
                row.incrementControl!.configConstraints()
            }
        }
    }
    
    private func addtitleLabel() {
        addSubview(titleLabel)
        
        titleLabel.font = Constants.defaultHeaderFont
        titleLabel.text = "Settings"
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
            scrollView.addSubview(row)
            row.settingsToggleDelegate = self
        }
    }
    
    private func addScrollView() {
        addSubview(scrollView)
        
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
    }
    
    private func sumOfRowHeights() -> CGFloat {
        return settingsRows.reduce(0.0) { memo, row in row.frame.height + memo }
    }
    
    private func addSaveButtonTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onSave))
        
        tapRecognizer.delegate = self as? UIGestureRecognizerDelegate
        
        saveButton.addGestureRecognizer(tapRecognizer)
    }
    
    private func setScrollViewContentSize() {
        let rowHeights = sumOfRowHeights()
        
        scrollView.contentSize = CGSize(width: self.frame.width, height: rowHeights)
    }
}

extension SettingsView: UIScrollViewDelegate {
    
}

extension SettingsView: SettingsViewToggleDelegate {
    func onSettingsToggle(_ this: SettingsViewRow, kind: SettingsViewRowKind, newValue: Bool) {
        if newValue && this.incrementControl != nil {
            this.snp.updateConstraints { make in
                make.height.equalTo(self.frame.height / (Constants.tableRowHeightDivisor / 2))
            }
        } else {
            this.snp.updateConstraints { make in
                make.height.equalTo(self.frame.height / Constants.tableRowHeightDivisor)
            }
        }
    
        this.layoutIfNeeded()
        
        setScrollViewContentSize()
    }
}
