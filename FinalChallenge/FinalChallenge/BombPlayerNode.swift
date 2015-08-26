//
//  BombPlayerNode.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 8/25/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class BombPlayerNode: SKSpriteNode {
    
    let playerCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let bombCategory: UInt32 = 1 << 2
    
    var roboBody : SKSpriteNode?
    
    init() {
        super.init(texture: nil, color: UIColor.blueColor(), size: CGSize(width: 55   , height: 60))
    }
    
    init(pos:BombTGameScene.Position,frame:CGRect) {
        
        let spriteAnimatedAtlas = SKTextureAtlas(named: "bombGame")//sprites
        
        var runFrames = [SKTexture]()
        for var i=0; i<2; i++
        {
            //let runTextureName = "running\(i)"
            let runTextureName = "roboBase\(i)"
            runFrames.append(spriteAnimatedAtlas.textureNamed(runTextureName))
        }
        
        
        super.init(texture: runFrames[0], color: UIColor.blueColor(), size: runFrames[0].size())
        setupPhysics()
        setupMovement(pos,frame: frame)
        
        var animationAction = SKAction.animateWithTextures(runFrames, timePerFrame: 0.15)
        self.runAction(SKAction.repeatActionForever(animationAction))
        
        initiateRoboBody()
  
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = playerCategory
        self.physicsBody?.collisionBitMask = worldCategory
        self.physicsBody?.contactTestBitMask = bombCategory
    }
    
    func setupMovement(pos:BombTGameScene.Position, frame:CGRect) {
        switch pos {
        case .North:
            self.position = CGPointMake(frame.size.width/2 - frame.size.width/3.5, frame.size.height - 140)
            let playerMovementDir = SKAction.moveTo(CGPointMake(frame.size.width/2 + frame.size.width/3.5, self.position.y), duration: 3.5)
            let playerMovementEsq = SKAction.moveTo(CGPointMake(frame.size.width/2 - frame.size.width/3.5, self.position.y), duration: 3.5)
            self.runAction(SKAction.repeatActionForever(SKAction.sequence([playerMovementDir, playerMovementEsq])))
        case .South:
            self.position = CGPointMake(frame.size.width/2 + frame.size.width/3.5, 140)
            let playerMovementDir = SKAction.moveTo(CGPointMake(frame.size.width/2 + frame.size.width/3.5, self.position.y), duration: 3.5)
            let playerMovementEsq = SKAction.moveTo(CGPointMake(frame.size.width/2 - frame.size.width/3.5, self.position.y), duration: 3.5)
            self.runAction(SKAction.repeatActionForever(SKAction.sequence([playerMovementEsq, playerMovementDir])))
        case .East:
            self.position = CGPointMake(frame.size.width/2 + frame.size.width/3.5, frame.size.height - 140)
            let playerMovementUp = SKAction.moveTo(CGPointMake(frame.size.width/2 + frame.size.width/3.5, frame.size.height - 140), duration: 3.5)
            let playerMovementDown = SKAction.moveTo(CGPointMake(frame.size.width/2 + frame.size.width/3.5, 140), duration: 3.5)
            self.runAction(SKAction.repeatActionForever(SKAction.sequence([playerMovementDown, playerMovementUp])))
        case .West:
            self.position = CGPointMake(frame.size.width/2 - frame.size.width/3.5, 140)
            let playerMovementUp = SKAction.moveTo(CGPointMake(frame.size.width/2 - frame.size.width/3.5, frame.size.height - 140), duration: 3.5)
            let playerMovementDown = SKAction.moveTo(CGPointMake(frame.size.width/2 - frame.size.width/3.5, 140), duration: 3.5)
            self.runAction(SKAction.repeatActionForever(SKAction.sequence([playerMovementUp, playerMovementDown])))
        default:
            ()
        }
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
        
        
        roboBody = SKSpriteNode(texture: runFrames[0], color: nil, size: runFrames[0].size())
        
        self.addChild(roboBody!)
        roboBody?.position = CGPointMake(0, 0)
        
        var animationAction = SKAction.animateWithTextures(runFrames, timePerFrame: 0.25)
        roboBody!.runAction(SKAction.repeatActionForever(animationAction))
        
        

        
        
    }
    
}
