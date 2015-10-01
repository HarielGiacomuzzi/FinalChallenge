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
    var playerScene : PlayerControllerScene?
    var storeScene : StoreScene?
    var partyModeScene : PartyModeScene?
    
    override func viewDidLoad() {
        super.viewDidLoad();
        ConnectionManager.sharedInstance.setupConnectionWithOptions(UIDevice.currentDevice().name, active: true);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerTurn:", name: "ConnectionManager_PlayerTurn", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openController:", name: "ConnectionManager_OpenController", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateMoney:", name: "ConnectionManager_UpdateMoney", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addCard:", name: "ConnectionManager_AddCard", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "removeCard:", name: "ConnectionManager_RemoveCard", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openStore:", name: "ConnectionManager_OpenStore", object: nil)
        
        skView = self.view as? SKView
        skView?.showsFPS = true
        skView?.showsNodeCount = true
        skView?.ignoresSiblingOrder = true
        skView?.showsPhysics = false
        
        loadPartyModeScene()
//        loadStore(["stealgold","stealgold","losecard","returnSquares","losecard"])
//        loadPlayerView()
    }
    
    // MARK: - Message Received Functions
    
    func playerTurn(data : NSNotification){
        playerScene?.carousel.canRemoveWithSwipeUp = true
        playerScene?.testButton.text = "DICE"
        
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
            playerScene?.updateMoney(value)
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
            playerScene!.addCard(card)
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
            playerScene!.removeCard(card)
        } else {
            print("nao rola filho")
        }
    }
    
    func openStore(data : NSNotification) {
        if storeScene == nil {
            let dic = data.userInfo!["dataDic"] as! NSDictionary
            let cards = dic["cards"] as! [String]
            let player = dic["player"] as! String
            if player == ConnectionManager.sharedInstance.peerID!.displayName {
                print(player)
                loadStore(cards)
            }
        }
    }
    
    // MARK: - Scene Control
    
    func loadPlayerView() {
        storeScene = nil
        partyModeScene = nil
        
        playerScene = PlayerControllerScene(size: CGSize(width: 1334, height: 750))
        playerScene?.viewController = self
        if let peerID = ConnectionManager.sharedInstance.peerID?.displayName {
            playerScene?.playerName = peerID
        }
        playerScene?.scaleMode = .AspectFit
        skView?.presentScene(playerScene)
    }
    
    func loadStore(cards:[String]) {
        playerScene = nil
        partyModeScene = nil
        
        storeScene = StoreScene(size: CGSize(width: 1334, height: 750))
        storeScene?.cardsString = cards
        storeScene?.viewController = self
        if let peerID = ConnectionManager.sharedInstance.peerID?.displayName {
            storeScene?.playerName = peerID
        }
        storeScene?.scaleMode = .AspectFit
        skView?.presentScene(storeScene)
    }
    
    func loadPartyModeScene() {
        playerScene = nil
        storeScene = nil
        
        partyModeScene = PartyModeScene(size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        
        partyModeScene?.viewController = self
        skView?.presentScene(partyModeScene)
    }
}