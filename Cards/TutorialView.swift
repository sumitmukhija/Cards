//
//  TutorialView.swift
//  Cards
//
//  Created by Sumit on 2/16/17.
//  Copyright © 2017 Sumit Mukhija. All rights reserved.
//

import UIKit

protocol TutorialViewHelper {
    func dismissTutorial()
}

class TutorialView: UIView {
    
    var delegate: TutorialViewHelper?
    
    @IBAction func dismissTutorialTapped(sender: AnyObject) {
        delegate?.dismissTutorial()
    }
}