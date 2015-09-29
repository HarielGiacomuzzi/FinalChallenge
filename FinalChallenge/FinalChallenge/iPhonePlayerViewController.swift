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
    
    var skView : SKView?
    var scene : PlayerControllerScene?
    var storeScene : StoreScene?
    
    override func viewDidLoad() {
        super.viewDidLoad();
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerTurn:", name: "ConnectionManager_PlayerTurn", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openController:", name: "ConnectionManager_OpenController", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateMoney:", name: "ConnectionManager_UpdateMoney", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addCard:", name: "ConnectionManager_AddCard", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "removeCard:", name: "ConnectionManager_RemoveCard", object: nil)
        
        scene = PlayerControllerScene(size: CGSize(width: 1334, height: 750))
        scene?.viewController = self
        
        if let peerID = ConnectionManager.sharedInstance.peerID?.displayName {
            scene?.playerName = peerID
        }
        
        skView = self.view as? SKView
        skView?.showsFPS = true
        skView?.showsNodeCount = true
        skView?.ignoresSiblingOrder = true
        skView?.showsPhysics = false
        scene?.scaleMode = .AspectFit
        skView?.presentScene(scene)
    }
    
    func playerTurn(data : NSNotification){
        scene?.carousel.canRemoveWithSwipeUp = true
        scene?.testButton.text = "DICE"
        
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
            scene?.updateMoney(value)
        } else {
            print("nao rola filho")
        }
    }
    
    func addCard(data : NSNotification) {
        let dic = data.userInfo!["dataDic"] as! NSDictionary
        print("estou no iphone")
        print(dic)
        let playerName = dic["player"] as! String
        let card = dic["item"] as! String
        print("mensagem para \(playerName)")
        print("eu sou \(ConnectionManager.sharedInstance.peerID!.displayName)")
        if playerName == ConnectionManager.sharedInstance.peerID!.displayName {
            scene!.addCard(card)
        } else {
            print("nao rola filho")
        }
    }
    
    func removeCard(data : NSNotification) {
        let dic = data.userInfo!["dataDic"] as! NSDictionary
        print("estou no iphone")
        print(dic)
        let playerName = dic["player"] as! String
        let card = dic["item"] as! String
        print("mensagem para \(playerName)")
        print("eu sou \(ConnectionManager.sharedInstance.peerID!.displayName)")
        if playerName == ConnectionManager.sharedInstance.peerID!.displayName {
            scene!.removeCard(card)
        } else {
            print("nao rola filho")
        }
    }
    
    func openPlayerView() {
        storeScene = nil
        scene = PlayerControllerScene(size: CGSize(width: 1334, height: 750))
        scene?.viewController = self
        if let peerID = ConnectionManager.sharedInstance.peerID?.displayName {
            scene?.playerName = peerID
        }
        scene?.scaleMode = .AspectFit
        skView?.presentScene(scene)
    }
    
    func openStore() {
        scene = nil
        storeScene = StoreScene(size: CGSize(width: 1334, height: 750))
        storeScene?.viewController = self
        if let peerID = ConnectionManager.sharedInstance.peerID?.displayName {
            storeScene?.playerName = peerID
        }
        storeScene?.scaleMode = .AspectFit
        skView?.presentScene(storeScene)
    }
}