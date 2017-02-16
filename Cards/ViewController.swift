//
//  ViewController.swift
//  Cards
//
//  Created by Sumit on 2/16/17.
//  Copyright © 2017 Sumit Mukhija. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cardContentView: PrimaryView!
    var origin: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.cardContentViewDragged(_:)))
        cardContentView.addGestureRecognizer(panGesture)
    }

    func cardContentViewDragged(sender: UIPanGestureRecognizer){
        let translateInX = (sender.translationInView(self.view)).x
        let translateInY = (sender.translationInView(self.view)).y
        switch sender.state {
        case .Began:
            self.origin = cardContentView.center
        case .Changed:
            let rotationMagnitude = Double(min(translateInX/320, 1))
            let rotationAngle = CGFloat(2 * M_PI * rotationMagnitude/16.0)
            let scaleMagnitude =  1 - fabsf(Float(min(translateInX/320, 1)))/4
            let scale = max(scaleMagnitude, 0.9)
            cardContentView.center = CGPointMake(origin!.x + translateInX, origin!.y + translateInY)
            let transform = CGAffineTransformMakeRotation(rotationAngle)
            let scaleTransform = CGAffineTransformScale(transform, CGFloat(scale), CGFloat(scale))
            cardContentView.transform = scaleTransform
            break
        case .Ended:
            self.resetAttribs()
            break
        default:
            return
        }
    }
    
    func resetAttribs(){
        UIView.animateWithDuration(0.2) { 
            self.cardContentView.center = self.origin!
            self.cardContentView.transform = CGAffineTransformMakeRotation(0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

