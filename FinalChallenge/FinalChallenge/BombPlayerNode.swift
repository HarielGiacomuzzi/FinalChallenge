//
//  BombPlayerNode.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 8/25/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class BombPlayerNode: SKNode {
    
    let playerCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let bombCategory: UInt32 = 1 << 2
    
    var roboBody : SKSpriteNode?
    var roboBase : SKSpriteNode?
    var identifier = ""
    var color = UIColor()
    
    override init() {
        super.init()
        initiateRoboBase()
        initiateRoboBody()
        setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: (roboBase!.size.height/2)*0.6)
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = playerCategory
        self.physicsBody?.collisionBitMask = worldCategory
        self.physicsBody?.contactTestBitMask = bombCategory
    }

    

    func initiateRoboBase() {
        
        let spriteAnimatedAtlas = SKTextureAtlas(named: "bombGame")//sprites
        
        var runFrames = [SKTexture]()
        for var i=0; i<2; i++ {
            let runTextureName = "roboBase\(i)"
            runFrames.append(spriteAnimatedAtlas.textureNamed(runTextureName))
        }
        
        
        roboBase = SKSpriteNode(texture: runFrames[0], color: UIColor.clearColor(), size: runFrames[0].size())
        roboBase?.zPosition = 2;
        
        self.addChild(roboBase!)
        
        roboBase?.position = CGPointMake(0, 0)
        
        var animationAction = SKAction.animateWithTextures(runFrames, timePerFrame: 0.25)
        roboBase!.runAction(SKAction.repeatActionForever(animationAction))
    }
    
    
    func initiateRoboBody(){
        
        let spriteAnimatedAtlas = SKTextureAtlas(named: "bombGame")//sprites
        
        var runFrames = [SKTexture]()
        for var i=0; i<4; i++
        {
            //let runTextureName = "running\(i)"
            let runTextureName = "roboBody\(i)"
            runFrames.append(spriteAnimatedAtlas.textureNamed(runTextureName))
        }
        
        
        roboBody = SKSpriteNode(texture: runFrames[0], color: UIColor.clearColor(), size: runFrames[0].size())
        
        self.addChild(roboBody!)
        roboBody?.position = CGPointMake(0, 0)
        roboBody?.zPosition = 4
        var animationAction = SKAction.animateWithTextures(runFrames, timePerFrame: 0.25)
        roboBody!.runAction(SKAction.repeatActionForever(animationAction))
        
    }
    
}
