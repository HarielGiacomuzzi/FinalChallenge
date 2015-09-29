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
    
    var card = "defaultcard"
    
    init(card:String) {
        super.init()
        self.card = card
        
        let atlas = SKTextureAtlas(named: "cards")
        let texture = atlas.textureNamed("trapCardBase")
        let baseSprite = SKSpriteNode(texture: texture)
        baseSprite.zPosition = 1
        addChild(baseSprite)
        let texture2 = atlas.textureNamed(card)
        let sprite = SKSpriteNode(texture: texture2)
        sprite.zPosition = 2
        addChild(sprite)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
