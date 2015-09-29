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
    
    //@IBOutlet weak var GameOverView: UIView!
    
    var scene : MinigameScene?
    
    var minigame = Minigame.FlappyFish
   // var minigame = Minigame.BombGame
    
    var playerRank:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Dei load na minigameview controller")
        GameManager.sharedInstance.minigameViewController = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_ControlAction", object: nil);
        var name = String()
        
        switch minigame {
        case .FlappyFish:
        //    scene = FlappyGameScene(size: CGSize(width: 1024, height: 768))
            name = "FlappyFish"
        case .BombGame:
        //    scene = BombTGameScene(size: CGSize(width: 1024, height: 768))
            name = "BombGame"
        }
        
        scene = TutorialScene(size: CGSize(width: 1024, height: 768))
        scene!.gameName = name
        
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.showsPhysics = true
        scene!.gameController = self
        scene!.scaleMode = .Fill
        skView.presentScene(scene)
        //print("apresentei a cena sem crashar")
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func messageReceived(data : NSNotification){
        let peerDisplayName = data.userInfo!["peerID"] as! String
        let data = data.userInfo!["actionReceived"] as! NSDictionary
        scene!.messageReceived(peerDisplayName, dictionary: data)
    }

    func dismissScene(){
        scene = nil
    }
    
}
