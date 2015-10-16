//
//  MinigameCollectionViewController.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 8/31/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class MinigameCollectionViewController : UIViewController {
    
    var minigameCollection = [Minigame]()
    var scene : MinigameCollectionScene!
    
    override func viewDidLoad() {
        
        minigameCollection = GameManager.sharedInstance.allMinigames
        
        ConnectionManager.sharedInstance.setupConnectionWithOptions(UIDevice.currentDevice().name, active: true);
        
        scene = MinigameCollectionScene(size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        
        let skView = self.view as! SKView
        
        //debug configs
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.showsPhysics = false
        
        skView.ignoresSiblingOrder = true
        scene.viewController = self
        scene.scaleMode = .AspectFit
        skView.presentScene(scene)

    }
    
    func gameSelected(game:String!){
        performSegueWithIdentifier("minigameSegue", sender: game)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "minigameSegue" {
            let minivc = segue.destinationViewController as! MiniGameViewController
            switch sender as! String {
            case "flap":
                minivc.minigame = .FlappyFish
            case "bomb":
                minivc.minigame = .BombGame
            default:
                ()
            }
        }
    }
    
    func backToMain(){
        scene = nil
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    deinit{
        //print("MinigameCollectionViewController did deinit")
    }
}