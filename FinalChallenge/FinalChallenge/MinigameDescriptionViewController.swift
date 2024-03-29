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
    
    var scene : TutorialScene?
    
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet var gameDescription: [UITextView]!
    
    @IBOutlet var gameTitle: [UILabel]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // botao do minigame
        let versusButtonClickedImage = UIImage(named: "goOff")
        let versusButtonImage = UIImage(named: "goOn")
        goButton.setImage( versusButtonImage, forState: UIControlState.Normal)
        goButton.setImage(versusButtonClickedImage, forState: UIControlState.Highlighted)
        
        for textviews in gameDescription{
            while(textviews.contentSize.height > textviews.frame.size.height){
                textviews.font = textviews.font?.fontWithSize(textviews.font!.pointSize - 1)
                
            }
        }
        
        //
        
        
        scene = TutorialScene(size: CGSize(width: 1024, height: 768))
        //scene!.viewController = self
        
        
        GameManager.sharedInstance.minigameDescriptionViewController = self
       /* switch minigame {
        case .FlappyFish:
            //scene?.gameNumber = 1
            scene?.gameName = "Flappy Fish"
            for miniGameTitle in gameTitle {
                miniGameTitle.text = "Flappy Fish"
            }
            if(GameManager.sharedInstance.isMultiplayer){
                for gameDesc in gameDescription{
                    gameDesc.text = "Avoid the rocks while swimming through the river. Grab bubbles to gain a little boost. \nCheck your device to check the game controls"
                }
            } else{
                for gameDesc in gameDescription{
                    gameDesc.text = "Avoid the rocks while swimming through the river. Grab bubbles to gain a little boost. \nPress on the upper part of the screen to swim up and the botton to swim down"
                }
            }
            //       minigameDescription.text = game.objectForKey("description") as! String
        case .BombGame:
            //scene?.gameNumber = 2
            scene?.gameName = "Bomb Bots"
            for miniGameTitle in gameTitle{
                miniGameTitle.text = "Bomb Bots"
            }
            if(GameManager.sharedInstance.isMultiplayer){
                for gameDesc in gameDescription{
                    gameDesc.text = "Throw the bomb to other robots and don't let it explode on your hands! While traveling or left unchecked, the bomb timer will go down until some bot grab it. \nCheck your device to check the game controls"
                }
                
            } else{
                for gameDesc in gameDescription{
                    gameDesc.text = "Throw the bomb to other robots and don't let it explode on your hands! While traveling or left unchecked, the bomb timer will go down until some bot grab it again. \nWhile handling the bomb, swipe to throw to the desired angle"
                }
            }
            
            
            //      minigameDescription.text = game.objectForKey("description") as! String
        case .RopeGame:
            scene?.gameName = "Tightrope"
            for miniGameTitle in gameTitle{
                miniGameTitle.text = "Tightrope"
            }
            if(GameManager.sharedInstance.isMultiplayer){
                for gameDesc in gameDescription{
                    gameDesc.text = ""
                }
            } else {
                
            }
        }*/
        
        
        
        let skView = view as! SKView
        
        //debug configs
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.showsPhysics = false
        
        skView.ignoresSiblingOrder = true
        scene!.scaleMode = .AspectFit
        skView.presentScene(scene)
        //print("apresentei a cena sem crashar")
        
        
        
    }
    
    @IBAction func gotoMinigameButtonPressed() {
        performSegueWithIdentifier("gotoMinigameVC", sender: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotoMinigameVC" {
            let minivc = segue.destinationViewController as! MiniGameViewController
            minivc.minigame = minigame
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        performSegueWithIdentifier("gotoMinigameVC", sender: nil)
    }
    
}