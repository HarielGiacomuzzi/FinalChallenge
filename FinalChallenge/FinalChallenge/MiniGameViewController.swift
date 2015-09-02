//
//  MiniGamesViewController.swift
//  FinalChallenge
//
//  Created by Jonathas Hernandes on 21/08/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit
import MultipeerConnectivity
import Foundation

class MiniGameViewController: UIViewController, UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var GameOverView: UIView!
    
    var scene = MinigameScene()
    
    var minigame = Minigame.FlappyFish
   // var minigame = Minigame.BombGame
    
    var playerRank:[String] = []
    
    var stb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var popup: MinigameGameOverController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("Dei load na minigameview controller")
        GameManager.sharedInstance.minigameViewController = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_ControlAction", object: nil);
        
        popup = stb.instantiateViewControllerWithIdentifier("MinigameGameOverController") as! MinigameGameOverController
        popup.modalPresentationStyle = .Popover
        //popup.preferredContentSize = CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.height/2)
        
        switch minigame {
        case .FlappyFish:
            scene = FlappyGameScene(size: CGSize(width: 1024, height: 768))
        case .BombGame:
            scene = BombTGameScene(size: CGSize(width: 1024, height: 768))
        default:
            println("porraaaa")
        }
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.showsPhysics = false
        scene.gameController = self
        scene.scaleMode = .AspectFit
        skView.presentScene(scene)
        println("apresentei a cena sem crashar")
        
    }
    
    func messageReceived(data : NSNotification){
        var peerDisplayName = data.userInfo!["peerID"] as! String
        var data = data.userInfo!["actionReceived"] as! NSDictionary
        scene.messageReceived(peerDisplayName, dictionary: data)
    }
    
    func gameOverController(playerArray:[String]){
        self.playerRank = playerArray
        popup.player = playerRank.reverse()
        let popoverMenuViewController = popup.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Any
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = self.view
        popoverMenuViewController?.sourceRect = CGRect(
            x: 0,
            y: 0,
            width: 1,
            height: 1)
        presentViewController(popup, animated: true,completion: nil)


        //self.performSegueWithIdentifier("gotoGameOver", sender: nil)
        //var go = MinigameGameOverController()
        //go.player = self.playerRank
        
    }
    
   // override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     //   var go : MinigameGameOverController = (segue.destinationViewController) as! MinigameGameOverController
       // go.player = self.playerRank
    //}
    
}
