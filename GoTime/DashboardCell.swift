//
//  DashboardCell.swift
//  GoTime
//
//  Created by John Keith on 4/15/17.
//  Copyright © 2017 John Keith. All rights reserved.
//

import UIKit

class DashboardCell: UIView {
    var title: UILabel
    var content: UILabel
    
    init(title: UILabel = UILabel(),
         content: UILabel = UILabel()) {
        self.title = title
        self.content = content
        
        super.init(frame: Constants.defaultFrame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//  could place internal constraints upon the elements in the view, then let external constraints control the overall size
}
