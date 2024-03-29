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
    var gameLogo = UIImageView()
    var opened = false
    
    // MARK: - ViewController Lifecycle
    
   override func viewDidLoad() {
        super.viewDidLoad()
        let buttonImage = UIImage(named: "titleButtonOn")
        let pressedButtonImage = UIImage(named: "titleButtonOff")

        partyModeButton.setBackgroundImage(buttonImage, forState: UIControlState.Normal)
        singlePlayerButton.setBackgroundImage(buttonImage, forState: UIControlState.Normal)
        
        partyModeButton.setBackgroundImage(pressedButtonImage, forState: UIControlState.Highlighted)
        singlePlayerButton.setBackgroundImage(pressedButtonImage, forState: UIControlState.Highlighted)
        
        setupView()

    }
    
    override func viewDidAppear(animated: Bool) {
        if self.opened{
            self.closeBook(1.0, strapTime: 1.0, coverTime: 2.0, completion: {()})
        }
    }
    
    @IBAction func partyModeButtonPressed() {
        //not ready yet
        
        //partyModeButton.removeFromSuperview()
        //singlePlayerButton.removeFromSuperview()
        GameManager.sharedInstance.isMultiplayer = true
        openBook(1.0, strapTime: 1.0, coverTime: 2.0, completion: {() in
            if self.idiom == self.iPad {
                self.performSegueWithIdentifier("ipadSegue", sender: nil)
            } else {
                self.performSegueWithIdentifier("iphoneSegue", sender: nil)
            }
        })

        
    }

    @IBAction func singlePlayerButton(sender: AnyObject) {
        GameManager.sharedInstance.isMultiplayer = false
        self.performSegueWithIdentifier("minigameSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    // MARK: - View Setup
    
    func setupView() {
        
        setupCovers()
        
        setupPin()
        
        setupStrap()
        
        setupLogo()
        
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
        
        let ly = screenHeight / 2 - (leftCoverImage!.size.height * xScale) / 2
        
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
    
    func openBook(pinTime:NSTimeInterval, strapTime:NSTimeInterval, coverTime: NSTimeInterval, completion:() -> ()) {
        UIView.animateWithDuration(pinTime, animations: {
            self.removePin()
            }, completion: { (value: Bool) in
                UIView.animateWithDuration(strapTime, animations: {
                    self.removeStrap()
                    }, completion: {(value: Bool) in
                        UIView.animateWithDuration(coverTime, animations: {
                            self.removeCover()
                            }, completion: {(value: Bool) in
                                completion()
                        })
                        UIView.animateWithDuration(coverTime * 0.75, delay: coverTime * 0.25, options: [], animations: {
                                self.zoomIn()
                            }, completion: nil)
                        
                })
        })
        hideLogo()
        self.opened = true
    }
    
    func closeBook(pinTime:NSTimeInterval, strapTime:NSTimeInterval, coverTime: NSTimeInterval, completion:() -> ()) {
        UIView.animateWithDuration(pinTime, animations: {
            self.addCover()
            }, completion: { (value: Bool) in
                UIView.animateWithDuration(strapTime, animations: {
                    self.addStrap()
                    }, completion: {(value: Bool) in
                        UIView.animateWithDuration(coverTime, animations: {
                            self.addPin()
                            }, completion: {(value: Bool) in
                                completion()
                        })
                        
                })
        })
        showLogo()
        self.opened = false
        
    }
    
    func removePin() {
        pin.frame = CGRectMake(0, -pin.frame.height * 0.70, pin.frame.width, pin.frame.height)
    }
    
    func removeStrap() {
        strap.alpha = 0.0
    }
    
    func removeCover() {
        leftCover.frame = CGRectMake(-leftCover.frame.size.width / 2, leftCover.frame.origin.y, leftCover.frame.size.width, leftCover.frame.size.height)
        rightCover.frame = CGRectMake(screenWidth / 2, rightCover.frame.origin.y, rightCover.frame.size.width, rightCover.frame.size.height)
    }
    
    func zoomIn() {
        let aux = screenHeight / 2 - leftCover.frame.height
        
        leftCover.frame = CGRectMake(leftCover.frame.origin.x * 2, aux, leftCover.frame.size.width * 2, leftCover.frame.size.height * 2)
        rightCover.frame = CGRectMake(0.0, aux, rightCover.frame.size.width * 2, rightCover.frame.size.height * 2)

    }
    
    func addPin() {
        let pinImage = UIImage(named: "pin")
        
        let xScale = screenWidth / pinImage!.size.width
        
        let pinY = screenHeight / 2 - (pinImage!.size.height * xScale) / 2
        
        let pinRect = CGRectMake(0, pinY, screenWidth, pinImage!.size.height * xScale)
        
        pin.frame = pinRect
    }
    
    func addStrap() {
        strap.alpha = 1.0
    }
    
    func addCover() {
        let leftCoverImage = UIImage(named: "cover esq")
        let rightCoverImage = UIImage(named: "cover dir")
        
        let xScale = screenWidth / leftCoverImage!.size.width
        
        let ly = screenHeight / 2 - (leftCoverImage!.size.height * xScale) / 2
        
        let leftCoverRect = CGRectMake(0, ly, screenWidth, leftCoverImage!.size.height * xScale)
        let rightCoverRect = CGRectMake(0, ly, screenWidth, rightCoverImage!.size.height * xScale)
        
        rightCover.frame = rightCoverRect
        leftCover.frame = leftCoverRect
    }

    deinit{
        //print("Retirou a initialviewcontroller")
    }
    
    func setupLogo(){
        
        let logo = UIImage(named: "dalogo")
        let logoHeight = logo!.size.height
        let logoWidth = logo!.size.width
        
        let xScale = screenWidth / logoWidth
        let yScale = screenHeight / logoHeight
        let xPosition = screenWidth/2
        let yPosition = screenHeight/2
        
        let finalWidth = logoWidth  * xScale * 0.65
        let finalHeigth = logoHeight * yScale * 0.65

        let logoRect = CGRectMake(xPosition - finalWidth/2, yPosition - finalHeigth/2 , finalWidth, finalHeigth)
        
        gameLogo = UIImageView(frame: logoRect)
        gameLogo.image = logo
        gameLogo.contentMode = .ScaleAspectFit
        gameLogo.clipsToBounds = true
        
        
        mainView.addSubview(gameLogo)

    }
    
    func showLogo(){
        UIView.animateWithDuration(0.7, delay: 0.8, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.gameLogo.alpha = 1.0
            }, completion: nil)
    }
    
    func hideLogo(){
        UIView.animateWithDuration(0.7, delay: 0.8, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.gameLogo.alpha = 0
            }, completion: nil)

    }
    
}
