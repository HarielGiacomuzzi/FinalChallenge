//
//  InitialViewController.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 8/13/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class InitialViewController: UIViewController
    {

    let idiom = UI_USER_INTERFACE_IDIOM()
    let iPad = UIUserInterfaceIdiom.Pad
    
    // MARK: - View Setup Variables
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var partyModeButton: UIButton!
    @IBOutlet weak var singlePlayerButton: UIButton!
    var screenHeight = UIScreen.mainScreen().bounds.height
    var screenWidth = UIScreen.mainScreen().bounds.width
    var leftCover = UIImageView()
    var rightCover = UIImageView()
    var strap = UIImageView()
    var pin = UIImageView()

    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenHeight = UIScreen.mainScreen().bounds.height
        screenWidth = UIScreen.mainScreen().bounds.width
        
        setupView()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        screenHeight = UIScreen.mainScreen().bounds.height
        screenWidth = UIScreen.mainScreen().bounds.width
        
        removeImagesFromScreen()
        setupView()
        
    }
    
    @IBAction func partyModeButtonPressed() {
        if idiom == iPad {
            performSegueWithIdentifier("ipadSegue", sender: nil)
        } else {
            performSegueWithIdentifier("iphoneSegue", sender: nil)
        }
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    // MARK: - View Setup
    
    func setupView() {
        let screenHeight = UIScreen.mainScreen().bounds.height
        let screenWidth = UIScreen.mainScreen().bounds.width
        
        setupCovers()
        
        setupPin()
        
        setupStrap()
        
        mainView.bringSubviewToFront(singlePlayerButton)
        mainView.bringSubviewToFront(partyModeButton)
    }
    
    func removeImagesFromScreen() {
        rightCover.removeFromSuperview()
        leftCover.removeFromSuperview()
        strap.removeFromSuperview()
        pin.removeFromSuperview()
        
    }
    
    func setupCovers() {
        let leftCoverImage = UIImage(named: "cover esq")
        let rightCoverImage = UIImage(named: "cover dir")
        
        let xScale = screenWidth / leftCoverImage!.size.width
        
        var ly = screenHeight / 2 - (leftCoverImage!.size.height * xScale) / 2
        
        let leftCoverRect = CGRectMake(0, ly, screenWidth, leftCoverImage!.size.height * xScale)
        let rightCoverRect = CGRectMake(0, ly, screenWidth, leftCoverImage!.size.height * xScale)
        leftCover = UIImageView(frame: leftCoverRect)
        rightCover = UIImageView(frame: rightCoverRect)
        
        rightCover.image = rightCoverImage
        leftCover.image = leftCoverImage
        
        mainView.addSubview(rightCover)
        mainView.addSubview(leftCover)
    }
    
    func setupStrap() {
        let strapImage = UIImage(named: "strap")
        let strapHeight = strapImage!.size.height
        let strapWidth = strapImage!.size.width
        
        
        let xScale = screenWidth / strapWidth
        
        let strapY = (screenHeight / 2) - ((strapHeight * xScale) / 2)
        
        let strapRect = CGRectMake(0, strapY, screenWidth, strapHeight * xScale)
        
        strap = UIImageView(frame: strapRect)
        strap.image = strapImage
        
        mainView.addSubview(strap)
    }
    
    func setupPin() {
        let pinImage = UIImage(named: "pin")
        
        let xScale = screenWidth / pinImage!.size.width
        
        let pinY = screenHeight / 2 - (pinImage!.size.height * xScale) / 2
        
        let pinRect = CGRectMake(0, pinY, screenWidth, pinImage!.size.height * xScale)
        
        pin = UIImageView(frame: pinRect)
        pin.image = pinImage
        
        mainView.addSubview(pin)
    }
    
    // MARK: - Animation
    
    func openBook(pinTime:NSTimeInterval, strapTime:NSTimeInterval, coverTime: NSTimeInterval) {
        
        UIView.animateWithDuration(pinTime, animations: {
            self.removePin()
            }, completion: { (value: Bool) in
                UIView.animateWithDuration(strapTime, animations: {
                    self.removeStrap()
                    }, completion: {(value: Bool) in
                        UIView.animateWithDuration(coverTime, animations: {
                            self.removeCover()
                            }, completion: {(value: Bool) in
                                
                        })
                        
                })
        })
        
    }
    
    func removePin() {
        pin.frame = CGRectMake(0, -screenHeight, pin.frame.width, pin.frame.height)
    }
    
    func removeStrap() {
        strap.alpha = 0.0
    }
    
    func removeCover() {
        leftCover.frame = CGRectMake(-leftCover.frame.size.width / 2, leftCover.frame.origin.y, leftCover.frame.size.width, leftCover.frame.size.height)
        rightCover.frame = CGRectMake(screenWidth / 2, leftCover.frame.origin.y, rightCover.frame.size.width, rightCover.frame.size.height)
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        openBook(2.0, strapTime: 1.0, coverTime: 2.0)
        
    }

}
