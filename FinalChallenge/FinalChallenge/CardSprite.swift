//
//  CardSprite.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 9/21/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class CardSprite: SKSpriteNode {
    
    var card = "defaultcard"
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
                colorBlendFactor = 0.4
    }
    
    init(card:String) {
        self.card = card
        let texture = SKTexture(imageNamed: card)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        colorBlendFactor = 0.4
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
