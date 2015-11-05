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
    
    var cardValue : SKLabelNode?
    
    // MARK: - View Lifecicle
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        let backgroundTexture = SKTexture(imageNamed: "backscreen")
        let background = SKSpriteNode(texture: backgroundTexture)
        background.position = CGPointMake(frame.size.width / 2, frame.size.height  / 2)
        background.setScale(2.0)
        addChild(background)
        
        self.backgroundColor = UIColor.init(red: 30/255, green: 183/255, blue: 249/255, alpha: 1)
        
        createSquaresAndAnimate()
        setupTopBar()
        setupButtons()
        setupMindingoSalesman()
        setupCards()
        setupAssets()
        
        if !GlobalFlags.storeTaught {
            setTutorial()
        }
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
        let topBarTexture = SKTexture(imageNamed: "setUpBannerIphone")
        let topBarSprite = SKSpriteNode(texture: topBarTexture)
        topBarSprite.position = CGPointMake(frame.size.width / 2, frame.size.height / 1.2)
        topBarSprite.zPosition = 20
        topBarSprite.setScale(2)
        addChild(topBarSprite)
        let text = SKLabelNode(text: playerName)
        text.position = CGPointMake(topBarSprite.position.x, topBarSprite.position.y)
        text.fontSize = 75.0
        text.fontColor = UIColor(red: 255, green: 242, blue: 202, alpha: 1)
        text.fontName = "GillSans-Bold"
        text.zPosition = 30
        addChild(text)
        

   
        
        topBarLimit = topBarSprite.position.y - topBarSprite.frame.size.height/2 + 30
        
    }
    
    func setupButtons() {
        
        let leaveTextureOn = SKTexture(imageNamed: "leaveon")
        let leaveTextureOff = SKTexture(imageNamed: "leaveoff")
        leaveButton = StoreButtonNode(textureOn: leaveTextureOn, textureOff: leaveTextureOff)
        leaveButton.position = CGPointMake(frame.size.width - leaveButton.size.width*0.55, leaveButton.size.height * 0.75)
        leaveButton.zPosition = 35
        addChild(leaveButton)
        leaveButton.delegate = self
        
        let buyTextureOn = SKTexture(imageNamed: "buyon")
        let buyTextureOff = SKTexture(imageNamed: "buyoff")
        buyButton = StoreButtonNode(textureOn: buyTextureOn, textureOff: buyTextureOff)
        buyButton.position = CGPointMake(frame.size.width - buyButton.size.width*0.55, leaveButton.position.y + buyButton.size.height)
        buyButton.zPosition = 35
        addChild(buyButton)
        buyButton.delegate = self
        
        
        let goldTexture = SKTexture(imageNamed: "buttonAnimation19")
        let playerGoldBar = SKSpriteNode(texture: goldTexture)
        playerGoldBar.position = CGPoint(x: self.frame.width - playerGoldBar.frame.width * 0.25, y: buyButton.position.y + playerGoldBar.frame.height)
        self.addChild(playerGoldBar)
        playerGoldBar.zPosition = 100
        
        
        moneyLabel = SKLabelNode(text: "$\(viewController!.playerMoney)")
        moneyLabel.position = CGPoint(x: playerGoldBar.position.x * 0.97, y: playerGoldBar.position.y)
        moneyLabel.fontName = "GillSans-Bold"
        moneyLabel.fontSize = 58
        moneyLabel.zPosition = 101
        moneyLabel.text = "$ 999.999"
        addChild(moneyLabel)
        
    }
    
    func setupMindingoSalesman() {
        let mindiTexture = SKTexture(imageNamed: "mindingo")
        let mindingo = SKSpriteNode(texture: mindiTexture)
        mindingo.zPosition = 25
        mindingo.position = CGPointMake(frame.size.width/2, frame.size.height/2)
        addChild(mindingo)
        

        
    }
    // new assets added to the store

    func setupAssets (){
        /*
        let castle = SKTexture(imageNamed: "littleCastle")
        let castleImage = SKSpriteNode(texture: castle)
        castleImage.position = CGPoint(x: self.frame.width - castleImage.frame.width/2, y: self.frame.height*0.4)
        self.addChild(castleImage)
        castleImage.zPosition = 21
        castleImage.alpha = 0.65
        */
        
        let costBG = SKTexture(imageNamed: "cardPrice")
        let cardCost = SKSpriteNode(texture: costBG)
        cardCost.position = CGPoint(x: self.frame.width/2, y: cardCost.frame.height/2)
        self.addChild(cardCost)
        cardCost.zPosition = 100
        
        cardValue = SKLabelNode(fontNamed: "GillSans-Bold")
        cardValue?.position = CGPoint(x: self.frame.width/2, y: cardCost.frame.height*0.25)
        cardValue?.text = "1000"
        self.addChild(cardValue!)
        cardValue?.zPosition = 101
        cardValue?.fontColor = UIColor.blackColor()
        cardValue?.fontSize = 58
        
        
    }
    
    func setupCards() {
        var cards : [SKNode] = []
        
        for cardString in cardsString {
            let card = CardSprite(cardName: cardString)
            card.setPrice()
            cards.append(card)
        }
        
        cardShow = CardShowNode(cardsArray: cards)
        cardShow.setScale(0.55)
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
            moneyLabel.position.x = frame.size.width - moneyLabel.frame.size.width*2
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
        let strings = TutorialManager.loadStringsPlist("store")
        var tuples: [(node:SKNode?, text:String?, animation: SKAction?)] = []
        
        tuples.append((nil, strings[0], nil))
        tuples.append((nil, strings[1], nil))
        tuples.append((nil, strings[2], nil))
        
        tutorialManager = TutorialManager(tuples: tuples, scene: self, isIphone: true,boxScale:2.0)
        tutorialManager.showInfo()
        GlobalFlags.storeTaught = true
    }
    
}
