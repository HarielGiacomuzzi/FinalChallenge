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
    
    //var minigame = Minigame.BombGame
    var minigame = Minigame.FlappyFish
    
    var playerRank:[String] = []
    
    var stb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var popup: MinigameGameOverController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_DataReceived", object: nil);
        
        popup = stb.instantiateViewControllerWithIdentifier("MinigameGameOverController") as! MinigameGameOverController
        popup.modalPresentationStyle = .Popover
        popup.preferredContentSize = CGSizeMake(100, 200)
        
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
        
    }
    
    func messageReceived(data : NSNotification){
        var peerID = data.userInfo!["peerID"] as! MCPeerID
        var peerDisplayName = peerID.displayName
        var data = data.userInfo!["data"] as! NSData
        
        if minigame == .FlappyFish {
            //movimento pelo gamePad
            var message = String(NSString(data: data, encoding: NSUTF8StringEncoding)!);
            if let messageEnum = PlayerAction(rawValue: message) {
               scene.messageReceived(peerDisplayName, action: messageEnum)
            }
            
        } else {
            var message = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSDictionary
            //scene.messageReceived(peerDisplayName, dictionary: message)
        }
    }
    
    func gameOverController(playerArray:[String]){
        self.playerRank = playerArray
        popup.player = playerRank.reverse()
        let popoverMenuViewController = popup.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Any
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = self.view
        popoverMenuViewController?.sourceRect = CGRect(
            x: 50,
            y: 100,
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
