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
    
    var notificationManager: NotificationManager?

    var playerColor : UIColor!
    var playerMoney = 0
    var playerLoot = 0
    var playerCards:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        ConnectionManager.sharedInstance.setupConnectionWithOptions(UIDevice.currentDevice().name, active: true);
        GameManager.sharedInstance.iphonePlayerController = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerTurn:", name: "ConnectionManager_PlayerTurn", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openController:", name: "ConnectionManager_OpenController", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateMoney:", name: "ConnectionManager_UpdateMoney", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateLoot:", name: "ConnectionManager_UpdateLoot", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addCard:", name: "ConnectionManager_AddCard", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "removeCard:", name: "ConnectionManager_RemoveCard", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openStore:", name: "ConnectionManager_OpenStore", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "buyResponse:", name: "ConnectionManager_BuyResponse", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openEndGameScene:", name: "ConnectionManager_TheGameEnded", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeController:", name: "ConnectionManager_CloseController", object: nil)
        
        skView = self.view as? SKView
        skView?.showsFPS = false
        skView?.showsNodeCount = false
        skView?.ignoresSiblingOrder = true
        skView?.showsPhysics = false
        
//        playerCards = ["StealGoldCard","LoseCard","MoveBackCard","Skull","Lamp"]
      loadPartyModeScene()
 //       loadStore(["StealGoldCard","StealGoldCard","StealGoldCard","MoveBackCard","LoseCard"])
//        loadPlayerView()
    }
    
    // MARK: - Message Received Functions
    
    func playerTurn(data : NSNotification){
        
        if let scene = playerScene {
            if scene.carousel != nil {
                scene.carousel.canRemoveWithSwipeUp = true
                if !GlobalFlags.cardTaught {
                    scene.teachCardsUse()
                }
            }
            scene.dice.activateDice()
            if !GlobalFlags.diceTaught {
                scene.teachDice()
            }
        }
        let string = NotificationManager.loadStringsPlist("yourTurn", replaceable: "")
        setNotification(string)
        
    }
    
    func openController(data : NSNotification) {
        let gameData = data.userInfo!["gameName"] as! String
        let minigame = Minigame(rawValue: gameData)
        let playerColorDic = data.userInfo!["playerColorDic"] as! [String:UIColor]
        let playerName = ConnectionManager.sharedInstance.peerID!.displayName
        playerColor = playerColorDic[playerName]
        loadGamePad(minigame!)
    }
    
    func closeController(data : NSNotification) {
        loadPlayerView()
    }
    
    func updateMoney(data : NSNotification) {
        let dic = data.userInfo!["dataDic"] as! NSDictionary
        let playerName = dic["player"] as! String
        let value = dic["value"] as! Int
        if playerName == ConnectionManager.sharedInstance.peerID!.displayName {
            let string = NotificationManager.loadStringsPlist("gotMoney", replaceable: "\(value - playerMoney)")
            setNotification(string)
            playerMoney = value
            playerScene?.updateMoney(playerMoney)
        }
    }
    func updateLoot(data : NSNotification) {
        let dic = data.userInfo!["dataDic"] as! NSDictionary
        let playerName = dic["player"] as! String
        let value = dic["value"] as! Int
        if playerName == ConnectionManager.sharedInstance.peerID!.displayName {
            let string = NotificationManager.loadStringsPlist("gotLoot", replaceable: "\(value - playerLoot)")
            setNotification(string)
            playerLoot = value
            playerScene?.updateLoot(playerLoot)
        }
    }
    
    func addCard(data : NSNotification) {
        let dic = data.userInfo!["dataDic"] as! NSDictionary
        let playerName = dic["player"] as! String
        let card = dic["item"] as! String

        if playerName == ConnectionManager.sharedInstance.peerID!.displayName {
            playerCards.append(card)
            let string = NotificationManager.loadStringsPlist("gotCard", replaceable: card)
            setNotification(string)
            if playerScene != nil {
                playerScene!.addCard(card)
            }
            
        } else {

        }
    }
    
    func removeCard(data : NSNotification) {
        let dic = data.userInfo!["dataDic"] as! NSDictionary
        let playerName = dic["playerName"] as! String
        let card = dic["item"] as! String
        let status = dic["status"] as! String
        let sent = dic["sent"] as! Bool
        if playerName == ConnectionManager.sharedInstance.peerID!.displayName && sent {
            playerScene!.removeCard(card)
            playerCards.removeObject(card)
        }
        if playerName == ConnectionManager.sharedInstance.peerID!.displayName {
            let string = NotificationManager.loadStringsPlist(status, replaceable: "")
            setNotification(string)
        }
    }
    
    func openStore(data : NSNotification) {
        if storeScene == nil {
            let dic = data.userInfo!["dataDic"] as! NSDictionary
            let cards = dic["cards"] as! [String]
            let player = dic["player"] as! String
            if player == ConnectionManager.sharedInstance.peerID!.displayName {
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
                let string = NotificationManager.loadStringsPlist(status, replaceable: "")
                setNotification(string)
                
                playerMoney = dic["playerMoney"] as! Int
                if worked {
                    playerCards.append(card)
                }
                storeScene?.buyResponse(status, worked: worked, money: playerMoney, card: card)
            }
            
        }
    }
    
    func openEndGameScene(data:NSNotification){
        loadEndGameScene()
    }
    
    // MARK: - Scene Control
    
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
        playerScene?.updateLoot(playerLoot)
        setNotificationsInNewScene()
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
        setNotificationsInNewScene()
    }
    
    func loadPartyModeScene() {
        setAllScenesNil()
        
        partyModeScene = PartyModeScene(size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        
        partyModeScene?.viewController = self
        skView?.presentScene(partyModeScene)
        setNotificationsInNewScene()
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
        setNotificationsInNewScene()
    }
    
    func loadEndGameScene() {
        setAllScenesNil()
        endGameScene = EndGameIphoneScene(size: CGSize(width: 1334, height: 750))
        skView?.presentScene(endGameScene)
        setNotificationsInNewScene()
    }
    
    func setAllScenesNil() {
        playerScene = nil
        storeScene = nil
        partyModeScene = nil
        gamePadScene = nil
        endGameScene = nil
    }
    
    
    // MARK: - Aux Functions
    
    func setNotification(text:String) {
        if notificationManager == nil {
            notificationManager = NotificationManager(notifications: [text], scene: skView!.scene!)
        } else {
            notificationManager?.notifications.append(text)
            if !notificationManager!.isActive {
                notificationManager!.showInfo()
            }
        }
    }
    
    func setNotificationsInNewScene() {

        if notificationManager != nil {
            let notifications = notificationManager!.notifications
            notificationManager = NotificationManager(notifications: notifications, scene: skView!.scene!)
            notificationManager!.showInfo()
        }
        
    }

}