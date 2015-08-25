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

class MiniGameViewController: UIViewController {
    
    @IBOutlet weak var GameOverView: UIView!
    
    var scene = MinigameScene()
    
    var minigame = Minigame.BombGame
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_DataReceived", object: nil);
        
        switch minigame {
        case .FlappyFish:
            scene = FlappyGameScene(size: CGSize(width: 1024, height: 768))
        case .BombGame:
            scene = BombTGameScene(size: CGSize(width: 1024, height: 768))
        default:
            ()
        }
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.showsPhysics = false
        scene.gameController = self
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
        
    }
    
    
    func messageReceived(data : NSNotification){
        var peerID = data.userInfo!["peerID"] as! MCPeerID
        var peerDisplayName = peerID.displayName
        var data = data.userInfo!["data"] as! NSData
        
        if minigame == .FlappyFish {
            var message = String(NSString(data: data, encoding: NSUTF8StringEncoding)!);
            if let messageEnum = PlayerAction(rawValue: message) {
                scene.messageReceived(peerDisplayName, action: messageEnum)
            }
            
        } else {
            var message = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSDictionary
            scene.messageReceived(peerDisplayName, dictionary: message)
        }

    }
    
}
