//
//  PlayerControllerScene.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 9/9/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class PlayerControllerScene: SKScene {
    
    var moneyButton = SKSpriteNode()
    var lootButton = SKSpriteNode()
    var topBarLimit:CGFloat = 0.0
    
    override func didMoveToView(view: SKView) {
        
        var card1 = SKSpriteNode(texture: nil, color: UIColor.blueColor(), size: CGSize(width: 375, height: 540))
        var card2 = SKSpriteNode(texture: nil, color: UIColor.greenColor(), size: CGSize(width: 375, height: 540))
        var card3 = SKSpriteNode(texture: nil, color: UIColor.redColor(), size: CGSize(width: 375, height: 540))
        var card4 = SKSpriteNode(texture: nil, color: UIColor.whiteColor(), size: CGSize(width: 375, height: 540))
        
        var cards = [card1,card2,card3,card4]
        
        let backgroundTexture = SKTexture(imageNamed: "backscreen")
        let background = SKSpriteNode(texture: backgroundTexture)
        background.position = CGPointMake(frame.size.width / 2, frame.size.height  / 2)
        addChild(background)
        
        self.backgroundColor = UIColor.whiteColor()
        
        createSquaresAndAnimate()
        setupTopBar()
        setupButtons()
        
        var carousel = CardCarouselNode(cardsArray: cards)
        carousel.position = CGPointMake(self.frame.size.width/2, topBarLimit / 2)
        self.addChild(carousel)

    }
    
    func createSquaresAndAnimate() {

        let squareTexture = SKTexture(imageNamed: "squares")
        
        var pos = CGPointMake(frame.size.width / 2, frame.size.height + squareTexture.size().height / 2)
        
        let movement = SKAction.moveByX(0.0, y: -squareTexture.size().height, duration: 2.0)
        let reset = SKAction.moveByX(0.0, y: squareTexture.size().height, duration: 0.0)
        let sequence = SKAction.sequence([movement,reset])
        
        while(pos.y > -squareTexture.size().height/2) {
            var squaresNode = SKSpriteNode(texture: squareTexture)
        
            squaresNode.position = pos
            addChild(squaresNode)
            pos.y -= squareTexture.size().height
            squaresNode.runAction(SKAction.repeatActionForever(sequence))
        }
        
        
    }
    
    func setupButtons() {
        let moneyButtonTextureOn = SKTexture(imageNamed: "button2On")
        let moneyButtonTextureOff = SKTexture(imageNamed: "button2Off")
        moneyButton = PlayerButtonNode(textureOn: moneyButtonTextureOn, textureOff: moneyButtonTextureOff)
        moneyButton.position = CGPointMake(frame.size.width - moneyButton.size.width / 2, (moneyButton.size.height / 2) - 20)
        addChild(moneyButton)
        
        let lootButtonTextureOn = SKTexture(imageNamed: "button1On")
        let lootButtonTextureOff = SKTexture(imageNamed: "button1Off")
        lootButton = PlayerButtonNode(textureOn: lootButtonTextureOn, textureOff: lootButtonTextureOff)
        lootButton.position = CGPointMake(lootButton.size.width/2, (lootButton.size.height/2) - 20)
        addChild(lootButton)
        
    }
    
    func setupTopBar() {
        let topBarTexture = SKTexture(imageNamed: "setUpBanner")
        let topBarSprite = SKSpriteNode(texture: topBarTexture)
        topBarSprite.position = CGPointMake(frame.size.width / 2, frame.size.height - topBarSprite.size.height / 2)

        addChild(topBarSprite)
        var text = SKLabelNode(text: "Fulano's Iphone")
        text.position = CGPointMake(topBarSprite.position.x, topBarSprite.position.y)
        text.fontSize = 75.0
        text.fontName = "GillSans-Bold"
        addChild(text)
        
        topBarLimit = topBarSprite.position.y - topBarSprite.frame.size.height/2 + 30
        
    }
    
    func showDice() {
        
    }
    
    
    func updateMoney(value:Int) {
        
    }
    
    
}
