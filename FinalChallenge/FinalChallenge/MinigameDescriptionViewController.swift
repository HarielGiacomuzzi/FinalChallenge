//
//  MinigameDescriptionViewController.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 9/1/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit


class MinigameDescriptionViewController: UIViewController {

    
    var minigame = Minigame.FlappyFish
    var scene : tutorialScene?
    
    @IBOutlet weak var miniGameTitle: UILabel!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var gameDesc: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // botao do minigame
        let versusButtonClickedImage = UIImage(named: "goOff")
        let versusButtonImage = UIImage(named: "goOn")
        goButton.setImage( versusButtonImage, forState: UIControlState.Normal)
        goButton.setImage(versusButtonClickedImage, forState: UIControlState.Highlighted)
        
        

        
        //
        
        
        scene = tutorialScene(size: CGSize(width: 1024, height: 768))
        scene!.viewController = self
        
        
        navigationController?.navigationBarHidden = true
        GameManager.sharedInstance.minigameDescriptionViewController = self
        if let path = NSBundle.mainBundle().pathForResource("MinigameDetails", ofType: "plist") {
            let dic = NSDictionary(contentsOfFile: path)
            switch minigame {
            case .FlappyFish:
                _ = dic?.objectForKey("FlappyFish") as! NSDictionary
                scene?.gameNumber = 1
                scene?.gameName = "Flappy Fish"
                miniGameTitle.text = "Flappy Fish"
                if(GameManager.sharedInstance.isMultiplayer){
                    gameDesc.text = "Avoid the rocks while swimming through the river. Grab bubbles to gain a little boost. \nCheck your device to check the game controls"
                } else{
                    gameDesc.text = "Avoid the rocks while swimming through the river. Grab bubbles to gain a little boost. \nPress on the upper part of the screen to swim up and the botton to swim down"
                }
         //       minigameDescription.text = game.objectForKey("description") as! String
            case .BombGame:
                _ = dic?.objectForKey("BombGame") as! NSDictionary
                scene?.gameNumber = 2
                scene?.gameName = "Bomb Bots"
                miniGameTitle.text = "Bomb Bots"
                if(GameManager.sharedInstance.isMultiplayer){
                    gameDesc.text = "Throw the bomb to other robots and don't let it explode on your hands! While traveling or left unchecked, the bomb timer will go down until some bot grab it. \nCheck your device to check the game controls"

                } else{
                    gameDesc.text = "Throw the bomb to other robots and don't let it explode on your hands! While traveling or left unchecked, the bomb timer will go down until some bot grab it again. \nWhile handling the bomb, swipe to throw to the desired angle"
                }


          //      minigameDescription.text = game.objectForKey("description") as! String

            }


        }
        
    
        
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.showsPhysics = false
        scene!.scaleMode = .AspectFit
        skView.presentScene(scene)
        print("apresentei a cena sem crashar")
        
        
    
    }

    @IBAction func gotoMinigameButtonPressed() {
        performSegueWithIdentifier("gotoMinigameVC", sender: nil)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotoMinigameVC" {
            let minivc = segue.destinationViewController as! MiniGameViewController
            minivc.minigame = minigame
        }
    }

}
