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
    var testPlayer:FlappyPlayerNode!
    let verticalPipeGap = 70

    let playerCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    let endScreenCategory: UInt32 = 1 << 4
    
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
        
        self.spawnPlayers()
        self.gameLimit()
        
        //nobody connected
        if players.count == 0 {
            spawnSinglePlayer()
        }

        
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
        
        var contactNode = SKNode()
        contactNode.position = CGPointMake(0, 0)
        contactNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(1, self.frame.height))
        contactNode.physicsBody?.dynamic = false
        contactNode.physicsBody?.categoryBitMask = endScreenCategory
        contactNode.physicsBody?.contactTestBitMask = playerCategory
        self.addChild(contactNode)
    }
    
    func gameLimit(){
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

        
        // create the stones movement actions
        let distanceToMove = CGFloat(self.frame.size.width)
        let moveStones = SKAction.moveByX(-distanceToMove, y:0.0, duration:NSTimeInterval(0.01 * distanceToMove))
        let removeStones = SKAction.removeFromParent()
        movePipesAndRemove = SKAction.sequence([moveStones, removeStones])
        
        // spawn the stones
        let spawn = SKAction.runBlock({() in self.spawnStones()})
        let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)
    }
    
    func spawnStones() {
        var stone = FlappyStoneNode()
        var scale = getDoubleCGFloat(1, end: 3)
        //var position = random inicio do chao ate o fim do chao
        stone.setScale(scale)
        println(scale)
        stone.position = CGPointMake(self.frame.size.width, self.frame.size.height / 2 )
        
        stone.runAction(movePipesAndRemove)
        pipes.addChild(stone)
    }
    
    func getDoubleCGFloat(begin:UInt32,end:UInt32) -> CGFloat {
        var begin = begin * 100
        var end = end * 100
        var numInt32 = (arc4random() % end) + begin
        var numInt = Int(numInt32)
        var num = CGFloat(numInt)

        num = num / 100.0
        return num
        
    }
    
    func spawnPlayers() {
        let connectedPeers = ConnectionManager.sharedInstance.session.connectedPeers
        
        for connectedPeer in connectedPeers {
            var player = FlappyPlayerNode()
            player.identifier = connectedPeer.displayName
            println(player.identifier)
            player.position = CGPoint(x: self.frame.size.width / 2, y:self.frame.size.height / 2)
            self.addChild(player)
            players.append(player)
        }
    }
    
    func spawnSinglePlayer() {
        testPlayer = FlappyPlayerNode()
        testPlayer.identifier = "test player"
        testPlayer.position = CGPoint(x: self.frame.size.width / 2, y:self.frame.size.height / 2)
        self.addChild(testPlayer)
    }

    func playerJump(identifier:String) {
        for player in players {
            if player.identifier == identifier {
                player.jump()
            }
        }
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            testPlayer.jump()
            
        }
    }
    
    
}