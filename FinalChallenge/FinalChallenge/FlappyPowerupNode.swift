//
//  FlappyPowerupNode.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 8/18/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class FlappyPowerupNode: SKSpriteNode {
    
    
    let playerCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let stoneCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    let endScreenCategory: UInt32 = 1 << 4
    let powerUpCategory: UInt32 = 1 << 5
    
    init() {
        let texture = SKTexture(imageNamed: "bubble 0")
        super.init(texture: texture, color: nil, size: texture.size())
        setupAliveAnimation()
        setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAliveAnimation() {
        let sequence = [ SKTexture(imageNamed: "bubble 0"),
                        SKTexture(imageNamed: "bubble 1"),
                        SKTexture(imageNamed: "bubble 2"),
                        SKTexture(imageNamed: "bubble 3"),
                        SKTexture(imageNamed: "bubble 4"),
                        SKTexture(imageNamed: "bubble 5"),
                        SKTexture(imageNamed: "bubble 6"),
                        SKTexture(imageNamed: "bubble 7")
                    ]
        let animation = SKAction.animateWithTextures(sequence, timePerFrame: 0.2)
        let aliveAnimation = SKAction.repeatActionForever(animation)
        self.runAction(aliveAnimation)
        
    }
    
    func blowUp() {
        let sequence = [ SKTexture(imageNamed: "bubble disapear 0"),
            SKTexture(imageNamed: "bubble disapear 1"),
            SKTexture(imageNamed: "bubble disapear 2"),
            SKTexture(imageNamed: "bubble disapear 3"),
            SKTexture(imageNamed: "bubble disapear 4"),
            SKTexture(imageNamed: "bubble disapear 5"),
            SKTexture(imageNamed: "bubble disapear 6")
        ]
        
        let blowUp = SKAction.animateWithTextures(sequence, timePerFrame: 0.1)
        let remove = SKAction.removeFromParent()
        let blowAndRemove = SKAction.sequence([blowUp,remove])
        
        self.runAction(blowAndRemove)
        
    }
    
    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height / 2)
        self.physicsBody?.dynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = powerUpCategory
        self.physicsBody?.contactTestBitMask = playerCategory
    }
}
