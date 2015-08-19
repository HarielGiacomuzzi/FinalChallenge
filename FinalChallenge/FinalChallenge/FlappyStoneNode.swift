//
//  FlappyStoneNode.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 8/17/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class FlappyStoneNode: SKSpriteNode {
    
    let playerCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let stoneCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    let powerUpCategory: UInt32 = 1 << 5
    
    let atlas = SKTextureAtlas(named: "rock")
    
    init() {
        var aux = arc4random() % 3 + 1
        let texture = atlas.textureNamed("bigrock\(aux)")
        super.init(texture: texture, color: nil, size: texture.size())
        setupPhysics(texture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupPhysics(texture:SKTexture) {
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        self.physicsBody?.dynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = stoneCategory
        self.physicsBody?.contactTestBitMask = playerCategory
    }
    
    func setupMovement(frame:CGRect, vel:Double) {
        let distanceToMove = CGFloat(frame.size.width + self.size.width)
        let moveStones = SKAction.moveByX(-distanceToMove, y:0.0, duration:NSTimeInterval(vel))
        let removeStones = SKAction.removeFromParent()
        let moveStonesAndRemove = SKAction.sequence([moveStones, removeStones])
        self.runAction(moveStonesAndRemove)
    }
}
