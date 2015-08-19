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
    
    init() {
        let texture = SKTexture(imageNamed: "bird-02")
        super.init(texture: texture, color: nil, size: texture.size())
        setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height / 2)
        self.physicsBody?.dynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = stoneCategory
        self.physicsBody?.contactTestBitMask = playerCategory
    }
    
    func setupMovement(frame:CGRect) {
        let distanceToMove = CGFloat(frame.size.width + self.size.width)
        let moveStones = SKAction.moveByX(-distanceToMove, y:0.0, duration:NSTimeInterval(0.01 * distanceToMove))
        let removeStones = SKAction.removeFromParent()
        let moveStonesAndRemove = SKAction.sequence([moveStones, removeStones])
        self.runAction(moveStonesAndRemove)
    }
   
}
