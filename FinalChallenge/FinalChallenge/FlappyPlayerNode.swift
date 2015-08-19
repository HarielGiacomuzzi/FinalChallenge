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
    let powerUpCategory: UInt32 = 1 << 5
    
    var identifier:String?
    
    init() {
        let texture = SKTexture(imageNamed: "bird-01")
        super.init(texture: texture, color: nil, size: texture.size())
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
    
    
    func boostAndStop() {
        let boost = SKAction.runBlock({() in
            self.physicsBody?.applyImpulse(CGVectorMake(2, 0))
        })
        let stop = SKAction.runBlock({() in
            self.physicsBody?.velocity = CGVectorMake(0, 0)
        })
        
        let wait = SKAction.waitForDuration(1)
        
        let sequence = SKAction.sequence([boost,wait,stop])
        self.runAction(sequence)
    }
    
    func goUp() {
 
        self.physicsBody?.applyImpulse(CGVectorMake(0, 0.5))
        self.updateRotation()
    }
    
    func goDown() {
 
        self.physicsBody?.applyImpulse(CGVectorMake(0, -0.5))
        self.updateRotation()
    }
    
    func clamp(min: CGFloat, max: CGFloat, value: CGFloat) -> CGFloat {
        if( value > max ) {
            return max
        } else if( value < min ) {
            return min
        } else {
            return value
        }
    }
    
    func updateRotation() {
        self.zRotation = self.clamp( -1, max: 0.5, value: self.physicsBody!.velocity.dy * ( self.physicsBody!.velocity.dy < 0 ? 0.003 : 0.001 ) )
        //println(self.zRotation)
    }
}
