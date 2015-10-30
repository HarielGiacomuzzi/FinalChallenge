//
//  CardSprite.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 9/21/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class CardSprite: SKNode {
    
    var cardName = "defaultCard"
    var card = Card()
    var baseSprite:SKSpriteNode!
    var image:SKSpriteNode!
    var nameLabel:SKLabelNode!
    var priceLabel:SKLabelNode?
    var atlas : SKTextureAtlas?
    var texture = [SKTexture]()
    var move : SKAction?
    
    init(cardName:String) {
        super.init()
        self.cardName = cardName
        self.card = CardManager.ShareInstance.getCard(cardName)
        self.name = cardName
        print(card)
        if self.card.usable{
            atlas = SKTextureAtlas(named: "cards")
            texture = [atlas!.textureNamed("trapCardBase")]
            move = SKAction.animateWithTextures(texture, timePerFrame: 1000000000)
        } else {
            atlas = SKTextureAtlas(named: "cards2")
            texture = [atlas!.textureNamed("lootCard1"), atlas!.textureNamed("lootCard2")]
            move = SKAction.animateWithTextures(texture, timePerFrame: 0.5)
        }
        
        baseSprite = SKSpriteNode(texture: texture[0])
        baseSprite.zPosition = 1
        addChild(baseSprite)
        
        let texture2 = atlas!.textureNamed(card.imageName)
        image = SKSpriteNode(texture: texture2)
        image.zPosition = 2
        addChild(image)
        nameLabel = SKLabelNode(text: self.cardName)
        let maxSize = baseSprite.position.y + baseSprite.frame.height/2
        let minSize = image.position.y + image.size.height/2
        let midSize = minSize + ((maxSize - minSize) / 2)
        nameLabel.position = CGPointMake(baseSprite.position.x, midSize)
        nameLabel.zPosition = 3
        nameLabel.fontSize = 45
        nameLabel.fontName = "GillSans-Bold"
        addChild(nameLabel)
        self.baseSprite.runAction(SKAction.repeatActionForever(move!))
    }
    
    func setPrice() {
        priceLabel = SKLabelNode(text: "$\(card.storeValue)")
        priceLabel!.zPosition = 4
        priceLabel?.fontSize = 45
        priceLabel?.fontName = "GillSans-Bold"
        priceLabel?.fontColor = UIColor(red:0.13, green:0.42, blue:0.16, alpha:1.0)
        addChild(priceLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
