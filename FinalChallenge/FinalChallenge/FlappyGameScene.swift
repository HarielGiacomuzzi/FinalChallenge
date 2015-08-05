//
//  FlappyGameScene.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 8/4/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import SpriteKit

class FlappyGameScene : SKScene, SKPhysicsContactDelegate {
    
    var player:SKSpriteNode!
    
    let playerCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    
    override func didMoveToView(view: SKView) {
        
        // setup physics
        self.physicsWorld.gravity = CGVectorMake( 0.0, -5.0 )
        self.physicsWorld.contactDelegate = self
        
        // setup background color
        var skyColor = SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        self.backgroundColor = skyColor
        
        //draws player
        let playerTexture = SKTexture(imageNamed: "bird-02")
        player = SKSpriteNode(texture: playerTexture)
        player.setScale(2.0)
        player.position = CGPoint(x: self.frame.size.width * 0.35, y:self.frame.size.height * 0.6)
        
        //adds player physics
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height / 2.0)
        player.physicsBody?.dynamic = true
        player.physicsBody?.allowsRotation = false
        
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        player.physicsBody?.contactTestBitMask = worldCategory | pipeCategory
        
        //adds player to game
        self.addChild(player)
        
        
        // creates ground texture
        let groundTexture = SKTexture(imageNamed: "land")
        groundTexture.filteringMode = .Nearest
        
        //creates ground movement
        let moveGroundSprite = SKAction.moveByX(-groundTexture.size().width * 2.0, y: 0, duration: NSTimeInterval(0.02 * groundTexture.size().width * 2.0))
        let resetGroundSprite = SKAction.moveByX(groundTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveGroundSpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveGroundSprite,resetGroundSprite]))
        
        // this loop draws the texture side by side until it fills the ground
        for var i:CGFloat = 0; i < 2.0 + self.frame.size.width / ( groundTexture.size().width * 2.0 ); ++i {
            // draws sprite
            let sprite = SKSpriteNode(texture: groundTexture)
            sprite.setScale(2.0)
            sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2) // sprite.position = CENTER POINT
            
            //inserts physics
            sprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(sprite.size.width, sprite.size.height))
            sprite.physicsBody?.dynamic = false
            sprite.physicsBody?.categoryBitMask = worldCategory
            
            //sets up movement
            sprite.runAction(moveGroundSpritesForever)
            
            //adds sprite to game
            self.addChild(sprite)
        }

        
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
                
            player.physicsBody?.velocity = CGVectorMake(0, 0)
            player.physicsBody?.applyImpulse(CGVectorMake(0, 30))
                
        }
    }
}