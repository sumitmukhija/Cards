//
//  PrimaryView.swift
//  Cards
//
//  Created by Sumit on 2/16/17.
//  Copyright © 2017 Sumit Mukhija. All rights reserved.
//

import UIKit

class PrimaryView: UIView {
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 0.6
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSizeMake(0.3, 3.0);
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 3.0
    }
    
}
