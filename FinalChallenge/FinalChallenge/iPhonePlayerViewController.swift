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
    var gamePadScene : GamePadScene?
    var endGameScene : EndGameIphoneScene?

    var playerColor : UIColor!
    var playerMoney = 0
    var playerCards:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        ConnectionManager.sharedInstance.setupConnectionWithOptions(UIDevice.currentDevice().name, active: true);
        GameManager.sharedInstance.iphonePlayerController = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerTurn:", name: "ConnectionManager_PlayerTurn", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openController:", name: "ConnectionManager_OpenController", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateMoney:", name: "ConnectionManager_UpdateMoney", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addCard:", name: "ConnectionManager_AddCard", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "removeCard:", name: "ConnectionManager_RemoveCard", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openStore:", name: "ConnectionManager_OpenStore", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "buyResponse:", name: "ConnectionManager_BuyResponse", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openEndGameScene:", name: "ConnectionManager_TheGameEnded", object: nil)
        
        skView = self.view as? SKView
        skView?.showsFPS = false
        skView?.showsNodeCount = false
        skView?.ignoresSiblingOrder = true
        skView?.showsPhysics = false
//        playerCards = ["StealGoldCard","StealGoldCard","StealGoldCard","MoveBackCard","LoseCard"]
        loadPartyModeScene()
//        loadStore(["StealGoldCard","StealGoldCard","StealGoldCard","MoveBackCard","LoseCard"])
//        loadPlayerView()
    }
    
    // MARK: - Message Received Functions
    
    func playerTurn(data : NSNotification){
        if playerScene?.carousel != nil {
            playerScene?.carousel.canRemoveWithSwipeUp = true
        }
        playerScene?.dice.activateDice()
        setNotification("Your Turn")
        
    }
    
    func openController(data : NSNotification) {
        let gameData = data.userInfo!["gameName"] as! String
        let minigame = Minigame(rawValue: gameData)
        loadGamePad(minigame!)
    }
    
    func updateMoney(data : NSNotification) {
        let dic = data.userInfo!["dataDic"] as! NSDictionary
        let playerName = dic["player"] as! String
        let value = dic["value"] as! Int
        //print("mensagem para \(playerName)")
        //print("eu sou \(ConnectionManager.sharedInstance.peerID!.displayName)")
        if playerName == ConnectionManager.sharedInstance.peerID!.displayName {
            //print("playerscene = \(playerScene)")
            //print("gamepadscene = \(gamePadScene)")
            //print("era pra notificar aqui")
            //print("update moneys para \(value)")
            setNotification("You got \(playerMoney - value) moneys")
            playerMoney = value
            playerScene?.updateMoney(playerMoney)
        } else {
            //print("nao rola filho")
        }
    }
    
    func addCard(data : NSNotification) {
        let dic = data.userInfo!["dataDic"] as! NSDictionary
        //print("estou no iphone")
        //print(dic)
        let playerName = dic["player"] as! String
        let card = dic["item"] as! String
        //print("mensagem para \(playerName)")
        //print("eu sou \(ConnectionManager.sharedInstance.peerID!.displayName)")
        if playerName == ConnectionManager.sharedInstance.peerID!.displayName {
            playerCards.append(card)
            if playerScene != nil {
                playerScene!.addCard(card)
            }
            
        } else {
            //print("nao rola filho")
        }
    }
    
    func removeCard(data : NSNotification) {
        let dic = data.userInfo!["dataDic"] as! NSDictionary
        //print("estou no iphone")
        //print(dic)
        let playerName = dic["player"] as! String
        let card = dic["item"] as! String
        //print("mensagem para \(playerName)")
        //print("eu sou \(ConnectionManager.sharedInstance.peerID!.displayName)")
        if playerName == ConnectionManager.sharedInstance.peerID!.displayName {
            playerScene!.removeCard(card)
            playerCards.removeObject(card)
        } else {
            //print("nao rola filho")
        }
    }
    
    func openStore(data : NSNotification) {
        //print("OPEN STORE MENSAGEM RECEBI")
        if storeScene == nil {
            let dic = data.userInfo!["dataDic"] as! NSDictionary
            let cards = dic["cards"] as! [String]
            let player = dic["player"] as! String
            if player == ConnectionManager.sharedInstance.peerID!.displayName {
                //print(player)
                loadStore(cards)
            }
        }
    }
    
    func buyResponse(data : NSNotification) {
        if storeScene != nil {
            let dic = data.userInfo!["dataDic"] as! NSDictionary
            let worked = dic["worked"] as! Bool
            let status = dic["status"] as! String
            let player = dic["player"] as! String
            let card = dic["card"] as! String
            if player == ConnectionManager.sharedInstance.peerID!.displayName {
                playerMoney = dic["playerMoney"] as! Int
                if worked {
                    playerCards.append(card)
                }
                storeScene?.buyResponse(status, worked: worked, money: playerMoney, card: card)
            }
            
        }
    }
    
    // MARK: - Scene Control
    
    func openEndGameScene(data:NSNotification){
        endGameScene = EndGameIphoneScene(size: CGSize(width: 1334, height: 750))
        endGameScene?.scaleMode = .Fill
        skView?.presentScene(endGameScene)
    }
    
    func loadPlayerView() {
        setAllScenesNil()
        
        playerScene = PlayerControllerScene(size: CGSize(width: 1334, height: 750))
        playerScene?.viewController = self
        if let peerID = ConnectionManager.sharedInstance.peerID?.displayName {
            playerScene?.playerName = peerID
        }
        playerScene?.scaleMode = .AspectFit
        playerScene?.cardsString = playerCards
        skView?.presentScene(playerScene)
        playerScene?.updateMoney(playerMoney)
    }
    
    func loadStore(cards:[String]) {
        setAllScenesNil()
        
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
        setAllScenesNil()
        
        partyModeScene = PartyModeScene(size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        
        partyModeScene?.viewController = self
        skView?.presentScene(partyModeScene)
    }
    
    func loadGamePad(minigame:Minigame) {
        setAllScenesNil()
        
        switch minigame {
        case .FlappyFish:
            gamePadScene = AccelerometerScene(size: CGSize(width: 1334, height: 750))
        case .BombGame:
            gamePadScene = SwipeScene(size: CGSize(width: 1334, height: 750))
        }
        
        gamePadScene?.viewController = self
        skView?.presentScene(gamePadScene)
        gamePadScene?.backgroundColor = playerColor
    }
    
    func setAllScenesNil() {
        playerScene = nil
        storeScene = nil
        partyModeScene = nil
        gamePadScene = nil
    }
    
    
    // MARK: - Aux Functions
    
    func setNotification(text:String) {
//        let notification = NotificationNode(text: text)
//        notification.position = CGPointMake(skView!.scene!.frame.size.width/2, skView!.scene!.frame.size.height/2)
//        skView?.scene!.addChild(notification)
    }
}