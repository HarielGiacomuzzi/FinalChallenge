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
    
    var players:[FlappyPlayerNode] = []
    let verticalPipeGap = 70

    let playerCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    
    var pipeTextureUp:SKTexture!
    var pipeTextureDown:SKTexture!
    var movePipesAndRemove:SKAction!
    var moving:SKNode!
    var pipes:SKNode!
    
    
    override func didMoveToView(view: SKView) {
        
        // setup physics
        self.physicsWorld.gravity = CGVectorMake( 0.0, -5.0 )
        self.physicsWorld.contactDelegate = self
        
        // setup background color
        var skyColor = SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        self.backgroundColor = skyColor
        
        moving = SKNode()
        self.addChild(moving)
        pipes = SKNode()
        moving.addChild(pipes)
        
        self.spawnPlayers(3)
        
        
        // creates ground texture
        let groundTexture = SKTexture(imageNamed: "land")
        groundTexture.filteringMode = .Nearest
        
        //creates ground movement (essa parte eu ainda nao entendi)
        let moveGroundSprite = SKAction.moveByX(-groundTexture.size().width * 0.5, y: 0, duration: NSTimeInterval(0.02 * groundTexture.size().width * 0.5))
        let resetGroundSprite = SKAction.moveByX(groundTexture.size().width * 0.5, y: 0, duration: 0.0)
        let moveGroundSpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveGroundSprite,resetGroundSprite]))

        // this loop draws the texture side by side until it fills the ground
        for var i:CGFloat = 0; i < 3.0 + self.frame.size.width / ( groundTexture.size().width * 2.0 ); ++i {
            // draws sprite
            let sprite = SKSpriteNode(texture: groundTexture)
            sprite.setScale(1.0)
            sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height/2)
            // sprite.position = CENTER POINT
            
            //sets up movement
            sprite.runAction(moveGroundSpritesForever)
            
            //adds sprite to game
            self.addChild(sprite)
        }

        //adds imovable ground physics
        var ground = SKNode()
        ground.position = CGPointMake(0, groundTexture.size().height) //ground.position = CENTER POINT
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, groundTexture.size().height * 0.01))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = worldCategory
        self.addChild(ground)
        
        // create the pipes textures
        pipeTextureUp = SKTexture(imageNamed: "PipeUp")
        pipeTextureUp.filteringMode = .Nearest
        pipeTextureDown = SKTexture(imageNamed: "PipeDown")
        pipeTextureDown.filteringMode = .Nearest
        
        // create the pipes movement actions
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeTextureUp.size().width)
        let movePipes = SKAction.moveByX(-distanceToMove, y:0.0, duration:NSTimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        movePipesAndRemove = SKAction.sequence([movePipes, removePipes])
        
        // spawn the pipes
        let spawn = SKAction.runBlock({() in self.spawnPipes()})
        let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)
    }
    
    func spawnPlayers(number:Int) {
        for i in 0...number {
            var player = FlappyPlayerNode()
            player.position = CGPoint(x: self.frame.size.width * 0.35, y:self.frame.size.height * 0.6)
            self.addChild(player)
            players.append(player)
            
        }
    }
    
    func spawnPipes() {
        let pipePair = SKNode()
        pipePair.position = CGPointMake( self.frame.size.width + pipeTextureUp.size().width * 2, 0 )
        pipePair.zPosition = -10
        
        let height = UInt32( UInt(self.frame.size.height / 4) )
        let y = arc4random() % height + height
        
        let pipeDown = SKSpriteNode(texture: pipeTextureDown)
        pipeDown.setScale(2.0)
        
        pipeDown.position = CGPointMake(0.0, CGFloat(Double(y)) + pipeDown.size.height)
        
        pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize: pipeDown.size)
        pipeDown.physicsBody?.dynamic = false
        pipeDown.physicsBody?.categoryBitMask = pipeCategory
        pipeDown.physicsBody?.contactTestBitMask = playerCategory
        pipePair.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(texture: pipeTextureUp)
        pipeUp.setScale(2.0)
        pipeUp.position = CGPointMake(0.0, CGFloat(Double(y))-CGFloat(verticalPipeGap))
        
        
        pipeUp.physicsBody = SKPhysicsBody(rectangleOfSize: pipeUp.size)
        pipeUp.physicsBody?.dynamic = false
        pipeUp.physicsBody?.categoryBitMask = pipeCategory
        pipeUp.physicsBody?.contactTestBitMask = playerCategory
        pipePair.addChild(pipeUp)
        
        var contactNode = SKNode()
        contactNode.position = CGPointMake( pipeDown.size.width + players[0].size.width / 2, CGRectGetMidY( self.frame ) )
        contactNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake( pipeUp.size.width, self.frame.size.height ))
        contactNode.physicsBody?.dynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = playerCategory
        pipePair.addChild(contactNode)
        
        pipePair.runAction(movePipesAndRemove)
        pipes.addChild(pipePair)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            players[0].jump()
            
        }
    }
    
}