//
//  PlayerControllerScene.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 9/9/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class PlayerControllerScene: SKScene, CardCarousellDelegate {
    
    var moneyButton : PlayerButtonNode!
    var lootButton : PlayerButtonNode!
    var carousel : CardCarouselNode!
    var topBarLimit:CGFloat = 0.0
    var playerName = "Player Name"
    var testButton : SKLabelNode!
    
    override func didMoveToView(view: SKView) {
        
        let card1 = CardSprite(texture: nil, color: UIColor.blueColor(), size: CGSize(width: 375, height: 540))
        let card2 = CardSprite(texture: nil, color: UIColor.greenColor(), size: CGSize(width: 375, height: 540))
        let card3 = CardSprite(texture: nil, color: UIColor.redColor(), size: CGSize(width: 375, height: 540))
        let card4 = CardSprite(texture: nil, color: UIColor.whiteColor(), size: CGSize(width: 375, height: 540))
        
        let cards = [card1,card2,card3,card4]

        let backgroundTexture = SKTexture(imageNamed: "backscreen")
        let background = SKSpriteNode(texture: backgroundTexture)
        background.position = CGPointMake(frame.size.width / 2, frame.size.height  / 2)
        addChild(background)
        
        self.backgroundColor = UIColor.whiteColor()
        
        createSquaresAndAnimate()
        setupTopBar()
        setupButtons()
        
        carousel = CardCarouselNode(cardsArray: cards, startIndex: 0)
        carousel.position = CGPointMake(self.frame.size.width/2, topBarLimit / 2)
        carousel.zPosition = 30
        carousel.delegate = self
        self.addChild(carousel)
        createTestButton()

    }
    
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
    
    func setupButtons() {
        let moneyButtonTextureOn = SKTexture(imageNamed: "button2On")
        let moneyButtonTextureOff = SKTexture(imageNamed: "button2Off")
        moneyButton = PlayerButtonNode(textureOn: moneyButtonTextureOn, textureOff: moneyButtonTextureOff, openRight: false)
        
        moneyButton.position = CGPointMake(frame.size.width - moneyButton.button.size.width / 2, (moneyButton.button.size.height / 2) - 20)

        addChild(moneyButton)
        moneyButton.zPosition = 35
        
        let lootButtonTextureOn = SKTexture(imageNamed: "button1On")
        let lootButtonTextureOff = SKTexture(imageNamed: "button1Off")
        lootButton = PlayerButtonNode(textureOn: lootButtonTextureOn, textureOff: lootButtonTextureOff, openRight: true)
        
        lootButton.position = CGPointMake(lootButton.button.size.width/2, (lootButton.button.size.height/2) - 20)
        
        addChild(lootButton)
        lootButton.zPosition = 35
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
        let cardSprite = CardSprite(card: card)
        carousel.insertCard(cardSprite)
        
    }
    
    func sendCard(card: SKSpriteNode) {
        let sentCardSprite = card as! CardSprite
        let sentCard = sentCardSprite.card
        let cardData = ["player":playerName, "item": sentCard]
        let dic = ["sendCard":" ", "dataDic" : cardData]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        
    }
    
    func createTestButton() {
        
        testButton = SKLabelNode(text: "NADA")
        testButton.position = CGPointMake(frame.size.width - testButton.frame.size.width, frame.size.height/2)
        testButton.fontSize = 50.0
        testButton.fontName = "GillSans-Bold"
        testButton.zPosition = 500
        addChild(testButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            if testButton.containsPoint(location) {
                if testButton.text == "DICE" {
                    let diceResult = Int(arc4random_uniform(6)+1)
                    let aux = NSMutableDictionary();
                    aux.setValue(diceResult, forKey: "diceResult");
                    aux.setValue(ConnectionManager.sharedInstance.peerID!.displayName, forKey: "playerID");
                    ConnectionManager.sharedInstance.sendDictionaryToPeer(aux, reliable: true);
                    testButton.text = "DONE"
                    
                } else if testButton.text == "DONE" {
                    
                }
            }

        }
    }
    
    
}
