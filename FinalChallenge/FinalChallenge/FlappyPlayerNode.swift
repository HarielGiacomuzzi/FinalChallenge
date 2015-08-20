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
        
        
        let spriteAnimatedAtlas = SKTextureAtlas(named: "fish")//sprites
        //let spriteAnimatedAtlas = SKTextureAtlas(named: "sprites")
        // inicializa corrida
        var runFrames = [SKTexture]()
        for var i=1; i<12; i++
        {
            //let runTextureName = "running\(i)"
            let runTextureName = "fish\(i)"
            runFrames.append(spriteAnimatedAtlas.textureNamed(runTextureName))
        }
        
        let texture = runFrames[1]
        
        let firstAction = SKAction.animateWithTextures(runFrames, timePerFrame: 0.07)
        

        super.init(texture: texture, color: nil, size: texture.size())
        setupPhysics()
        self.runAction(SKAction.repeatActionForever( firstAction   ))
        self.color = UIColor( red: 0.9, green: 0.6, blue: 0.3, alpha: 1 )
        self.colorBlendFactor = 0.4//How much of the color will be applied to the texture 0..1
        self.zPosition = 7
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: self.size.width * 0.65, height: self.size.height*0.4), center: CGPoint(x: self.position.x+7, y: self.position.y)   )
        self.physicsBody?.dynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = playerCategory
        self.physicsBody?.collisionBitMask = worldCategory | stoneCategory | playerCategory
        self.physicsBody?.contactTestBitMask = worldCategory | stoneCategory
        self.physicsBody?.mass =  0.05

    }
    
    
    func boostAndStop() {
        let spriteAnimatedAtlas = SKTextureAtlas(named: "wind")//sprites

        var runFrames = [SKTexture]()
        for var i=0; i<4; i++
        {
            //let runTextureName = "running\(i)"
            let runTextureName = "wind\(i)"
            runFrames.append(spriteAnimatedAtlas.textureNamed(runTextureName))
        }
        
        let texture = runFrames[0]
        
        let firstAction = SKAction.repeatAction(SKAction.animateWithTextures(runFrames, timePerFrame: 0.07), count: 3)
        let windNode = SKSpriteNode(texture: texture)
       
        self.addChild(windNode)

        windNode.position = CGPoint(x: 0, y: 0)
        
        windNode.runAction(firstAction, completion: {
            () in
            windNode.removeFromParent()
        })
        
        let boost = SKAction.runBlock({() in
            self.physicsBody?.applyImpulse(CGVectorMake(0.9, 0))
        })
        let stop = SKAction.runBlock({() in
            self.physicsBody?.velocity = CGVectorMake(0, 0)
        })
        
        let wait = SKAction.waitForDuration(1.5)
        
        let sequence = SKAction.sequence([boost,wait,stop])
        self.runAction(sequence)
    }
    
    func goUp() {
 
        self.physicsBody?.applyImpulse(CGVectorMake(0, 0.8))
        self.updateRotation()
    }
    
    func goDown() {
 
        self.physicsBody?.applyImpulse(CGVectorMake(0, -0.8))
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
