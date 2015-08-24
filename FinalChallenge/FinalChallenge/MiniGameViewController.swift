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

class MiniGameViewController: UIViewController{
    
    @IBOutlet weak var GameOverView: UIView!
    
    var scene = MinigameScene()
    
    var minigame = Minigame.FlappyFish
    
    var playerRank:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_DataReceived", object: nil);
        
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
        skView.showsPhysics = true
        scene.gameController = self
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
        
       // GameManager.sharedInstance.playerRank.append("Oh Yeah");
        
    }
    
    func messageReceived(data : NSNotification){
        var peerID = data.userInfo!["peerID"] as! MCPeerID
        var data = data.userInfo!["data"] as! NSData
//        var peerID = ((data.userInfo as! NSDictionary).valueForKey("peerID") as! MCPeerID);
//        var data = ((data.userInfo as! NSDictionary).valueForKey("data") as! NSData);
        var peerDisplayName = peerID.displayName
        var message = String(NSString(data: data, encoding: NSUTF8StringEncoding)!);
        let messageEnum = PlayerAction(rawValue: message)
        scene.messageReceived(peerDisplayName, action: messageEnum!)
    }
    
    func gameOverController(playerArray:[String]){
        self.playerRank = playerArray
        self.performSegueWithIdentifier("gotoGameOver", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var go : MinigameGameOverController = (segue.destinationViewController) as! MinigameGameOverController
        go.player = self.playerRank
    }
}
