//
//  StoreScene.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 9/28/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class StoreScene: SKScene, StoreButtonDelegate, CardShowDelegate {
    
    var tutorialManager: TutorialManager!
    
    weak var viewController : iPhonePlayerViewController?
    var playerName = "Player Name"
    var topBarLimit:CGFloat = 0.0
    
    var buyButton:StoreButtonNode!
    var leaveButton:StoreButtonNode!
    var moneyLabel:SKLabelNode!
    
    var cardsString : [String]!
    var chosenCard:CardSprite?
    var cardShow:CardShowNode!
    
    // MARK: - View Lifecicle
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        let backgroundTexture = SKTexture(imageNamed: "backscreen")
        let background = SKSpriteNode(texture: backgroundTexture)
        background.position = CGPointMake(frame.size.width / 2, frame.size.height  / 2)
        background.setScale(2.0)
        addChild(background)
        
        self.backgroundColor = UIColor.whiteColor()
        
        createSquaresAndAnimate()
        setupTopBar()
        setupButtons()
        setupMindingoSalesman()
        setupCards()
        
        setTutorial()
    }
    
    deinit {
        //print("store scene deinit")
    }

    // MARK: - View Setup
    
    func createSquaresAndAnimate() {
        
        let squareTexture = SKTexture(imageNamed: "squares")
        
        var pos = CGPointMake(frame.size.width / 2, frame.size.height + squareTexture.size().height / 2)
        
        let movement = SKAction.moveByX(0.0, y: -squareTexture.size().height, duration: 2.0)
        let reset = SKAction.moveByX(0.0, y: squareTexture.size().height, duration: 0.0)
        let sequence = SKAction.sequence([movement,reset])
        
        while(pos.y > -squareTexture.size().height/2) {
            let squaresNode = SKSpriteNode(texture: squareTexture)
            squaresNode.zPosition = 1
            squaresNode.alpha = 0.5
            
            squaresNode.position = pos
            addChild(squaresNode)
            pos.y -= squareTexture.size().height
            squaresNode.runAction(SKAction.repeatActionForever(sequence))
        }
        
        
    }
    
    func setupTopBar() {
        let topBarTexture = SKTexture(imageNamed: "setUpBanner")
        let topBarSprite = SKSpriteNode(texture: topBarTexture)
        topBarSprite.position = CGPointMake(frame.size.width / 2, frame.size.height - topBarSprite.size.height / 2)
        topBarSprite.zPosition = 20
        
        addChild(topBarSprite)
        let text = SKLabelNode(text: playerName)
        text.position = CGPointMake(topBarSprite.position.x, topBarSprite.position.y)
        text.fontSize = 75.0
        text.fontName = "GillSans-Bold"
        text.zPosition = 30
        addChild(text)
        
        moneyLabel = SKLabelNode(text: "$\(viewController!.playerMoney)")
        moneyLabel.position = topBarSprite.position
        moneyLabel.position.x = frame.size.width - moneyLabel.frame.size.width
        moneyLabel.fontName = "GillSans-Bold"
        moneyLabel.fontSize = 70
        moneyLabel.zPosition = 30
        addChild(moneyLabel)
        
        topBarLimit = topBarSprite.position.y - topBarSprite.frame.size.height/2 + 30
        
    }
    
    func setupButtons() {
        
        let leaveTextureOn = SKTexture(imageNamed: "leaveon")
        let leaveTextureOff = SKTexture(imageNamed: "leaveoff")
        leaveButton = StoreButtonNode(textureOn: leaveTextureOn, textureOff: leaveTextureOff)
        leaveButton.position = CGPointMake(frame.size.width - leaveButton.size.width/2, leaveButton.size.height/2)
        leaveButton.zPosition = 35
        addChild(leaveButton)
        leaveButton.delegate = self
        
        let buyTextureOn = SKTexture(imageNamed: "buyon")
        let buyTextureOff = SKTexture(imageNamed: "buyoff")
        buyButton = StoreButtonNode(textureOn: buyTextureOn, textureOff: buyTextureOff)
        buyButton.position = CGPointMake(frame.size.width - buyButton.size.width/2, leaveButton.size.height + buyButton.size.height/2)
        buyButton.zPosition = 35
        addChild(buyButton)
        buyButton.delegate = self
        
    }
    
    func setupMindingoSalesman() {
        let mindiTexture = SKTexture(imageNamed: "mindingo")
        let mindingo = SKSpriteNode(texture: mindiTexture)
        mindingo.zPosition = 21
        mindingo.position = CGPointMake(frame.size.width/2, frame.size.height/2)
        addChild(mindingo)
    }
    
    func setupCards() {
        var cards : [SKNode] = []
        
        for cardString in cardsString {
            let card = CardSprite(cardName: cardString)
            card.setPrice()
            cards.append(card)
        }
        
        cardShow = CardShowNode(cardsArray: cards)
        cardShow.setScale(0.60)
        let cardFrame = cardShow.calculateAccumulatedFrame()
        cardShow.position = CGPointMake(frame.size.width/2, cardFrame.height*0.75)
        cardShow.zPosition = 35
        cardShow.delegate = self
        addChild(cardShow)
        
    }
    // MARK: - Messages Received Functions
    
    func buyResponse(status:String,worked:Bool, money:Int, card:String) {
        if worked {
            moneyLabel.text = "$\(money)"
            moneyLabel.position.x = frame.size.width - moneyLabel.frame.size.width
            if chosenCard?.cardName == card {
                cardShow.removeCard(chosenCard!)
                chosenCard = nil
            }
        }
    }
    
    // MARK: - Delegate Functions
    
    func buttonClicked(sender: SKSpriteNode) {
        if sender == buyButton {
            if let card = chosenCard {
                sendMessageToBuy(card)
            }
        }
        if sender == leaveButton {
            closeStore()
        }
    }
    
    func sendMessageToBuy(card:CardSprite) {
        let dataDic = ["card":card.cardName]
        let dic = ["buyCard" : " ", "dataDic" : dataDic]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
    }
    
    func closeStore() {
        viewController?.loadPlayerView()
        let dic = ["closeStore":" "]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
    }
    
    func cardChosen(sender: SKNode) {
        chosenCard = sender as? CardSprite
    }
    
    func setTutorial() {
        var tuples: [(node:SKNode?, text:String?, animation: SKAction?)] = []
        
        tuples.append((nil, "Welcome to Loot Rush", nil))
        
        tutorialManager = TutorialManager(tuples: tuples, scene: self, isIphone: true,boxScale:2.0)
        tutorialManager.showInfo()
    }
    
}
