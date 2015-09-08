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
    let endScreenWinCategory: UInt32 = 1 << 4
    let endScreenLoseCategory: UInt32 = 1 << 4
    let powerUpCategory: UInt32 = 1 << 6
    
    let atlas = SKTextureAtlas(named: "bubble")
    
    init() {
        let texture = atlas.textureNamed("bubble%201")
        super.init(texture: texture, color: nil, size: texture.size())
        setupAliveAnimation()
        setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAliveAnimation() {
        var sequence:[SKTexture] = []
        for i in 0...7 {
            var texture = atlas.textureNamed("bubble%20\(i)")
            sequence.append(texture)
        }
        let animation = SKAction.animateWithTextures(sequence, timePerFrame: 0.1)
        let aliveAnimation = SKAction.repeatActionForever(animation)
        self.runAction(aliveAnimation)
        
    }
    
    func blowUp() {
        
        var sequence:[SKTexture] = []
        for i in 0...6 {
            var texture = atlas.textureNamed("bubble%20disapear%20\(i)")
            sequence.append(texture)
        }
        
        let blowUp = SKAction.animateWithTextures(sequence, timePerFrame: 0.07)
        let remove = SKAction.removeFromParent()
        self.physicsBody = SKPhysicsBody()
        let blowAndRemove = SKAction.sequence([blowUp,remove])
        
        self.runAction(blowAndRemove)
        
    }
    
    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height / 2)
        self.physicsBody?.dynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = powerUpCategory
        self.physicsBody?.collisionBitMask = stoneCategory
        self.physicsBody?.contactTestBitMask = playerCategory
    }
    
    func setupMovement(frame:CGRect) {
        let distanceToMove = CGFloat(frame.size.width + self.size.width)
        let movePowerUps = SKAction.moveByX(-distanceToMove, y:0.0, duration:NSTimeInterval(3))
        let removePowerUps = SKAction.removeFromParent()
        let movePowerUpsAndRemove = SKAction.sequence([movePowerUps, removePowerUps])
        self.runAction(movePowerUpsAndRemove)
    }
}
