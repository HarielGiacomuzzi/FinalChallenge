//
//  FlappyPlayerNode.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 8/17/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class FlappyPlayerNode: SKSpriteNode {
    
    let playerCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let stoneCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    let endScreenCategory: UInt32 = 1 << 4
    
    var identifier:String?
    
    init() {
        let texture = SKTexture(imageNamed: "bird-02")
        super.init(texture: texture, color: nil, size: texture.size())
        self.setScale(3)
        setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height / 2)
        self.physicsBody?.dynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = playerCategory
        self.physicsBody?.collisionBitMask = worldCategory | stoneCategory
        self.physicsBody?.contactTestBitMask = worldCategory | stoneCategory
    }
    
    func jump () {
        self.physicsBody?.velocity = CGVectorMake(0, 0)
        self.physicsBody?.applyImpulse(CGVectorMake(0, 5))
    }
    
    func goUp() {
 
        self.physicsBody?.applyImpulse(CGVectorMake(0, 0.5))
    }
    
    func goDown() {
 
        self.physicsBody?.applyImpulse(CGVectorMake(0, -0.5))
    }
}
