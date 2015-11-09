//
//  PlayerControllerScene.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 9/9/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class PlayerControllerScene: SKScene, CardCarousellDelegate, DiceDelegate, PlayerButtonDelegate {
    
    var tutorialManager: TutorialManager!
    
    var moneyButton : PlayerButtonNode!
    var lootButton : PlayerButtonNode!
    var carousel : CardCarouselNode!
    var topBarLimit:CGFloat = 0.0
    var playerName = "Player Name"
    var dice : DiceNode!
    var cardsString:[String] = []
    weak var viewController : iPhonePlayerViewController?
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        let backgroundTexture = SKTexture(imageNamed: "backscreen")
        let background = SKSpriteNode(texture: backgroundTexture)
        background.position = CGPointMake(frame.size.width / 2, frame.size.height  / 2)
        background.setScale(2.0)
        //addChild(background)
        
        self.backgroundColor = UIColor.init(red: 30/255, green: 183/255, blue: 249/255, alpha: 1)
        
        createSquaresAndAnimate()
        setupTopBar()
        setupButtons()
        createDice()
        
        var cards:[CardSprite] = []
        for cardString in cardsString {
            let card = CardSprite(cardName: cardString)
            cards.append(card)
        }
        if !GlobalFlags.gameTaught {
            setTutorial()
        }
        if !cards.isEmpty {
            setupCardCarousel(cards)
        }
        print("PLAYER SCENE LOADED")

    }
    
    func setupCardCarousel(cards:[CardSprite]) {
        carousel = CardCarouselNode(cardsArray: cards, startIndex: 0)
        carousel.position = CGPointMake(self.frame.size.width/2, topBarLimit / 1.7)
        carousel.zPosition = 30
        carousel.delegate = self
        self.addChild(carousel)
        carousel.canRemoveWithSwipeUp = false
    }
    
    func createSquaresAndAnimate() {

        let squareTexture = SKTexture(imageNamed: "squares")
        
        var pos = CGPointMake(frame.size.width / 2, frame.size.height + squareTexture.size().height / 2)
        
        let movement = SKAction.moveByX(0.0, y: -squareTexture.size().height, duration: 2.0)
        let reset = SKAction.moveByX(0.0, y: squareTexture.size().height, duration: 0.0)
        let sequence = SKAction.sequence([movement,reset])
        
        while(pos.y > -squareTexture.size().height/2) {
            let squaresNode = SKSpriteNode(texture: squareTexture)
            squaresNode.zPosition = 2
            squaresNode.alpha = 0.5
        
            squaresNode.position = pos
            addChild(squaresNode)
            pos.y -= squareTexture.size().height
            squaresNode.runAction(SKAction.repeatActionForever(sequence))
        }
        
        
    }
    
    func setupButtons() {
        let moneyButtonTextureOn = SKTexture(imageNamed: "button2On")
        let moneyButtonTextureOff = SKTexture(imageNamed: "button2Off")
        
        moneyButton = PlayerButtonNode(textureOn: moneyButtonTextureOn, textureOff: moneyButtonTextureOff, openRight: true)
        
        moneyButton.position = CGPointMake((moneyButton.button.size.width / 2), self.frame.height/4)

        addChild(moneyButton)
        moneyButton.zPosition = 100
        moneyButton.delegate = self
        
        let lootButtonTextureOn = SKTexture(imageNamed: "button1On")
        let lootButtonTextureOff = SKTexture(imageNamed: "button1Off")
        lootButton = PlayerButtonNode(textureOn: lootButtonTextureOn, textureOff: lootButtonTextureOff, openRight: true)
        
        lootButton.position = CGPointMake(lootButton.button.size.width/2, self.frame.height/2)
        
        addChild(lootButton)
        lootButton.zPosition = 100
        lootButton.delegate = self
    }
    
    func setupTopBar() {
        let topBarSprite = SKSpriteNode(imageNamed: "setUpBannerIphone")
        topBarSprite.position = CGPointMake(frame.size.width/2, frame.size.height/1.2)
        topBarSprite.zPosition = 20
        //topBarSprite.size.height = topBarSprite.size.height/2
        topBarSprite.setScale(2)
        addChild(topBarSprite)
        let text = SKLabelNode(text: playerName)
        text.position = CGPointMake(topBarSprite.position.x, topBarSprite.position.y)
        text.fontSize = 75.0
        text.fontName = "GillSans-Bold"
        text.zPosition = 30
        addChild(text)
        
        topBarLimit = topBarSprite.position.y - topBarSprite.frame.size.height/2 + 30
        
    }
    
    func showDice() {
        
    }
    
    
    func updateMoney(value:Int) {
        moneyButton.updateNumber(value)
    }
    
    func updateLoot(value:Int) {
        lootButton.updateNumber(value)
    }
    
    func addCard(card:String) {
        let cardSprite = CardSprite(cardName: card)
        if carousel == nil {
            let cards = [cardSprite]
            setupCardCarousel(cards)
        } else {
            carousel.insertCard(cardSprite)
        }
    }
    func removeCard(card:String) {
        AudioSource.sharedInstance.cardSound()
        for i in 0..<carousel.cards.count {
            if card == carousel.cards[i].name {
                carousel.removeCard(i)
                break
            }
        }
        carousel.canRemoveWithSwipeUp = false
    }
    
    func sendCard(card: SKNode) {
        let sentCardSprite = card as! CardSprite
        let sentCard = sentCardSprite.cardName
        let cardData = ["player":playerName, "item": sentCard]
        let dic = ["sendCard":" ", "dataDic" : cardData]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        
//        removeCard(sentCardSprite.cardName)
        
    }
    
    func carouselTouched() {
        buttonClicked(carousel)
    }
    
    
    func createDice() {
        dice = DiceNode()
        dice.zPosition = 30
        dice.position = CGPointMake(self.frame.size.width - dice.frame.size.width/3, frame.size.height/2)
        addChild(dice)
        dice.delegate = self

    }
    
    func diceRolled(sender: SKSpriteNode) {
        buttonClicked(sender)
        var diceResult = 1 //Int(arc4random_uniform(6)+1)
        let diceResult2 = Int(arc4random_uniform(6)+1)
        let aux = NSMutableDictionary();
        if GameManager.sharedInstance.halfFlag{
            diceResult = diceResult/2
            GameManager.sharedInstance.halfFlag = false
        }
        if GameManager.sharedInstance.doubleDice {
            diceResult += diceResult2
        }
        aux.setValue(diceResult, forKey: "diceResult");
        aux.setValue(ConnectionManager.sharedInstance.peerID!.displayName, forKey: "playerID");
        ConnectionManager.sharedInstance.sendDictionaryToPeer(aux, reliable: true);
        if carousel != nil {
            carousel.canRemoveWithSwipeUp = false
        }

    }
    
    deinit {
        print("player view scene deinit")
    }
    
    func setTutorial() {
        let strings = TutorialManager.loadStringsPlist("controllerBasic")
        var tuples: [(node:SKNode?, text:String?, animation: SKAction?)] = []
        
        tuples.append((moneyButton, strings[0], nil))
        tuples.append((lootButton, strings[1], nil))
        
        tutorialManager = TutorialManager(tuples: tuples, scene: self, isIphone: true, boxScale: 2.0)
        tutorialManager.showInfo()
        GlobalFlags.gameTaught = true
    }
    
    func teachDice() {
        let strings = TutorialManager.loadStringsPlist("teachDice")
        if tutorialManager != nil {
            tutorialManager.tuples.append((dice, strings[0], nil))
            if !tutorialManager.isActive {
                tutorialManager.showInfo()
            }
        } else {
            var tuples: [(node:SKNode?, text:String?, animation: SKAction?)] = []
            
            tuples.append((dice, strings[0], nil))
            
            tutorialManager = TutorialManager(tuples: tuples, scene: self, isIphone: true, boxScale: 2.0)
            tutorialManager.showInfo()
        }
        GlobalFlags.diceTaught = true
    }
    
    func teachCardsUse() {
        let strings = TutorialManager.loadStringsPlist("teachCard")
//        let card = carousel.getCenterCard()
        var tuples: [(node:SKNode?, text:String?, animation: SKAction?)] = []
        
        let moveUp = SKAction.moveTo(CGPointMake(carousel.position.x, carousel.position.y + 40), duration: 0.5)
        let moveDown = SKAction.moveTo(CGPointMake(carousel.position.x, carousel.position.y), duration: 0.5)
        
        let sequence = SKAction.sequence([moveUp, moveDown])
        let animation = SKAction.repeatActionForever(sequence)
        
        tuples.append((carousel, strings[0], animation))
        
        tutorialManager = TutorialManager(tuples: tuples, scene: self, isIphone: true, boxScale: 2.0)
        tutorialManager.showInfo()
        GlobalFlags.cardTaught = true
    }
    
    func buttonClicked(sender: SKNode) {
        if tutorialManager != nil {
            tutorialManager.buttonActivated(sender)
        }
    }
    
}
