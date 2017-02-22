//
//  ViewController.swift
//  Cards
//
//  Created by Sumit on 2/16/17.
//  Copyright © 2017 Sumit Mukhija. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController, TutorialViewHelper {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var txtViewCard: UITextView!
    @IBOutlet weak var cardContentView: PrimaryView!
    var origin: CGPoint?
    var tView: TutorialView?
    
    
    //data source
    var numberOfCards: Int? = 0
    var dataArray: Array<String>?{
        didSet(newValue){
            self.numberOfCards = dataArray!.count
            self.getRandomCard()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.boolForKey("isTutShown") != true && tView == nil
        {
            tView = NSBundle.mainBundle().loadNibNamed("TutorialView", owner: self, options: nil)[0] as! TutorialView
            tView?.delegate = self
            tView!.frame = self.view.frame
            tView!.center = self.view.center
            self.view.addSubview(tView!)
            userDefaults.setBool(true, forKey: "isTutShown")
        }
        else{
            getCardsFromServer()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.stopAnimating()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.cardContentViewDragged(_:)))
        cardContentView.addGestureRecognizer(panGesture)
    }
    
    func getCardsFromServer()
    {
        activityIndicator.startAnimating()
        Alamofire.request(.GET, "https://tinyurl.com/jcgxwkk").responseJSON { response in
            if let JSON = response.result.value
            {
                self.activityIndicator.stopAnimating()
                self.dataArray = JSON as? Array<String>
                self.getRandomCard()
            }
        }
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
            self.getRandomCard()
            break
        default:
            return
        }
    }
    
    func resetAttribs(){
        UIView.animateWithDuration(0.2) { 
            self.cardContentView.center = self.origin!
            self.cardContentView.transform = CGAffineTransformMakeRotation(0)
            self.cardContentView.layer.shadowColor = self.getRandomColor().CGColor
        }
    }
    
    @IBAction func infoButtonTapped(sender: AnyObject) {
       let infoAlert = UIAlertController(title: "FYI", message: "This application uses a JSON to pull the latest general awareness cards. The data is scrapped from AffairsCloud. If you don't find the cards up to date with current affairs, please feel free to request for the JSON file, make changes and submit it back.\n\n\nFind code on github.com/sumitmukhija", preferredStyle: .Alert)
        infoAlert.addAction(UIAlertAction(title: "Cool!", style: .Destructive, handler: nil))
        presentViewController(infoAlert, animated: true, completion: nil)
    }
    
    func getRandomCard(){
        let randomNum = Int(arc4random_uniform(UInt32(self.dataArray!.count)))
        let activeCard = self.dataArray![randomNum]
        txtViewCard.text = activeCard
    }
    
    
    //Delegate method for tutorial
    func dismissTutorial() {
        tView?.removeFromSuperview()
        getCardsFromServer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getRandomColor() -> UIColor{
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
}

