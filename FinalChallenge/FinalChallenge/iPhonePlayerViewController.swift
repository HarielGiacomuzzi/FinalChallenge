//
//  iPhonePlayerViewController.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 8/25/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import UIKit
import SpriteKit

class iPhonePlayerViewController: UIViewController {
    
    var scene : PlayerControllerScene?
    
    override func viewDidLoad() {
        super.viewDidLoad();
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerTurn:", name: "ConnectionManager_PlayerTurn", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openController:", name: "ConnectionManager_OpenController", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateMoney:", name: "ConnectionManager_UpdateMoney", object: nil)
        
        scene = PlayerControllerScene(size: CGSize(width: 1334, height: 750))
        
        if let peerID = ConnectionManager.sharedInstance.peerID?.displayName {
            scene?.playerName = peerID
        }
        
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.showsPhysics = false
        scene!.scaleMode = .AspectFit
        skView.presentScene(scene)
    }
    
    func playerTurn(data : NSNotification){
        self.performSegueWithIdentifier("gotoDiceView", sender: nil)
        
    }
    
    func openController(data : NSNotification) {
        let gameData = data.userInfo!["gameName"] as! String
        let minigame = Minigame(rawValue: gameData)
        switch minigame! {
        case .FlappyFish:
            performSegueWithIdentifier("gotoAcelePad", sender: nil)
            print("gotoAcelePad")
        case .BombGame:
            performSegueWithIdentifier("gotoSwipePad", sender: nil)
            print("gotoSwipePad")
        }
    }
    
    func updateMoney(data : NSNotification) {
        let dic = data.userInfo!["dataDic"] as! NSDictionary
        let playerName = dic["player"] as! String
        let value = dic["value"] as! Int
        print("mensagem para \(playerName)")
        print("eu sou \(ConnectionManager.sharedInstance.peerID!.displayName)")
        if playerName == ConnectionManager.sharedInstance.peerID!.displayName {
            print("update moneys para \(value)")
        } else {
            print("nao rola filho")
        }
    }
}