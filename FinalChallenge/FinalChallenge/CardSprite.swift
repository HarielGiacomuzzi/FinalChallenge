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
    
    init(cardName:String) {
        super.init()
        self.cardName = cardName
        self.card = CardManager.ShareInstance.getCard(cardName)
        let atlas = SKTextureAtlas(named: "cards")
        let texture = atlas.textureNamed("trapCardBase")
        baseSprite = SKSpriteNode(texture: texture)
        baseSprite.zPosition = 1
        addChild(baseSprite)
        let texture2 = atlas.textureNamed(card.imageName)
        image = SKSpriteNode(texture: texture2)
        image.zPosition = 2
        addChild(image)
        nameLabel = SKLabelNode(text: card.cardName)
        let maxSize = baseSprite.position.y + baseSprite.frame.height/2
        let minSize = image.position.y + image.size.height/2
        let midSize = minSize + ((maxSize - minSize) / 2)
        nameLabel.position = CGPointMake(baseSprite.position.x, midSize)
        nameLabel.zPosition = 3
        nameLabel.fontSize = 45
        nameLabel.fontName = "GillSans-Bold"
        addChild(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
