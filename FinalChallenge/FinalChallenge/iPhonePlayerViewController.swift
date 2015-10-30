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
    
    var notificationArray : [NotificationNode] = []

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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeController:", name: "ConnectionManager_CloseController", object: nil)
        
        skView = self.view as? SKView
        skView?.showsFPS = false
        skView?.showsNodeCount = false
        skView?.ignoresSiblingOrder = true
        skView?.showsPhysics = false
//        playerCards = ["StealGoldCard","StealGoldCard","StealGoldCard","Skull","Lamp"]
//        loadPartyModeScene()
//        loadStore(["StealGoldCard","StealGoldCard","StealGoldCard","MoveBackCard","LoseCard"])
       loadPlayerView()
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

            setNotification("You got \(value - playerMoney) moneys")
            playerMoney = value
            playerScene?.updateMoney(playerMoney)
        } else {

        }
    }
    
    func addCard(data : NSNotification) {
        let dic = data.userInfo!["dataDic"] as! NSDictionary
        let playerName = dic["player"] as! String
        let card = dic["item"] as! String

        if playerName == ConnectionManager.sharedInstance.peerID!.displayName {
            playerCards.append(card)
            setNotification("You got teh card \(card) :)")
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
        } else {
            
        }
        setNotification(status)
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
                setNotification(status)
                
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for notification in notificationArray {
            notification.removeFromParent()
        }
        notificationArray = []
    }
    
    
    // MARK: - Aux Functions
    
    func setNotification(text:String) {
        let notification = NotificationNode(text: text)
        notificationArray.append(notification)

        setNotificationsInNewScene()
    }
    
    func setNotificationsInNewScene() {
        
        //adds notifications to scene
        for notification in notificationArray {
            if notification.parent != nil {
                notification.removeFromParent()
            }
            skView?.scene?.addChild(notification)
        }
        
        //fixes notifications positions
        let notificationHeight = notificationArray.first?.calculateAccumulatedFrame().height
        var fullsize:CGFloat = 0.0
        var start:CGFloat = 0.0
        for _ in notificationArray {
            fullsize += notificationHeight!
        }
        start = skView!.scene!.frame.size.height/2 - fullsize/2
        
        for notification in notificationArray {
            let positionY = start + notificationHeight!/2
            notification.position = CGPointMake(skView!.scene!.frame.size.width/2, positionY)
            start = positionY + notificationHeight!/2
        }
        
    }

}