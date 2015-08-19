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
    var testPlayer:FlappyPlayerNode?
    let stoneVel = 4.0
    
    let playerCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let stoneCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    let endScreenCategory: UInt32 = 1 << 4
    let powerUpCategory: UInt32 = 1 << 5
    
    override func didMoveToView(view: SKView) {
        
        // setup physics
        self.physicsWorld.gravity = CGVectorMake( 0.0, 0.0 )
        self.physicsWorld.contactDelegate = self
        
        // setup background color
        var skyColor = SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        self.backgroundColor = skyColor

        
        self.spawnPlayers()
        self.setupWalls()
        
        //nobody connected
        if players.count == 0 {
            spawnSinglePlayer()
        }
        
        // spawn the stones
        let spawn = SKAction.runBlock({() in self.spawnStone()})
        
        let delay = SKAction.waitForDuration(2.5, withRange: 1)
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)
        
        //spawn the powerups
        
        let spawnPowerups = SKAction.runBlock({() in self.spawnPowerUp()})
        
        let delayPowerUp = SKAction.waitForDuration(5, withRange: 2)
        let spawnThenDelayPU = SKAction.sequence([spawnPowerups,delayPowerUp])
        let spawnDelayForeverPU = SKAction.repeatActionForever(spawnThenDelayPU)
        self.runAction(spawnDelayForeverPU)

        // left wall , if you hit you are dead
        var contactNode = SKNode()
        contactNode.position = CGPointMake(0, self.frame.size.height / 2)
        contactNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(1, self.frame.height))
        contactNode.physicsBody?.dynamic = false
        contactNode.physicsBody?.categoryBitMask = endScreenCategory
        contactNode.physicsBody?.contactTestBitMask = playerCategory
        self.addChild(contactNode)
        
    }
    
    func setupWalls(){
        // creates ground texture
        let groundTexture1 = SKTexture(imageNamed: "ffparalaxe1")
        let groundTexture2 = SKTexture(imageNamed: "ffparalaxe2")
        let groundTexture3 = SKTexture(imageNamed: "ffparalaxe3")
        groundTexture1.filteringMode = .Nearest
        groundTexture2.filteringMode = .Nearest
        groundTexture3.filteringMode = .Nearest
        
        let groundSprite1 = SKSpriteNode(texture: groundTexture1)
        groundSprite1.position = CGPointMake(groundSprite1.size.width / 2, groundSprite1.size.height / 2)
        let groundSprite2 = SKSpriteNode(texture: groundTexture2)
        groundSprite2.position = CGPointMake(groundSprite1.size.width + groundSprite2.size.width / 2, groundSprite2.size.height / 2)
        let groundSprite3 = SKSpriteNode(texture: groundTexture3)
        groundSprite3.position = CGPointMake(groundSprite2.size.width + groundSprite3.size.width / 2, groundSprite3.size.height / 2)
        
        let endPosition = CGPointMake(-(groundSprite1.size.width / 2), groundSprite1.size.height / 2)
        let startPosition = CGPointMake(frame.size.width + groundSprite3.size.width / 2, groundSprite1.size.height / 2)

        let moveGroundSprite = SKAction.moveTo(endPosition, duration: NSTimeInterval(6))
        let resetGroundSprite = SKAction.moveTo(startPosition, duration: 0.0)
        let moveGroundSpritesForever = SKAction.repeatActionForever(SKAction.sequence([resetGroundSprite,moveGroundSprite]))
        
        let startGroundSprite1 = SKAction.moveTo(endPosition, duration: NSTimeInterval(2))
        let startGroundSprite2 = SKAction.moveTo(endPosition, duration: NSTimeInterval(4))
        
        groundSprite1.runAction(SKAction.sequence([startGroundSprite1, moveGroundSpritesForever]))
        groundSprite2.runAction(SKAction.sequence([startGroundSprite2, moveGroundSpritesForever]))
        groundSprite3.runAction(moveGroundSpritesForever)
        
        self.addChild(groundSprite1)
        self.addChild(groundSprite2)
        self.addChild(groundSprite3)

        
        //adds imovable ground physics
        var ground = SKNode()
        ground.position = CGPointMake(self.frame.size.width / 2, groundTexture1.size().height * 0.7) //ground.position = CENTER POINT
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, groundTexture1.size().height * 0.01))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = worldCategory
        self.addChild(ground)

        //create roof texture
        let roofTexture1 = SKTexture(imageNamed: "ffparalaxe1")
        let roofTexture2 = SKTexture(imageNamed: "ffparalaxe2")
        let roofTexture3 = SKTexture(imageNamed: "ffparalaxe3")
        roofTexture1.filteringMode = .Nearest
        roofTexture2.filteringMode = .Nearest
        roofTexture3.filteringMode = .Nearest
        
        let roofSprite1 = SKSpriteNode(texture: groundTexture1)
        roofSprite1.position = CGPointMake(groundSprite1.size.width / 2, self.frame.size.height - groundSprite1.size.height / 2)
        let roofSprite2 = SKSpriteNode(texture: groundTexture2)
        roofSprite2.position = CGPointMake(groundSprite1.size.width + groundSprite2.size.width / 2, self.frame.size.height - groundSprite1.size.height / 2)
        let roofSprite3 = SKSpriteNode(texture: groundTexture3)
        roofSprite3.position = CGPointMake(groundSprite2.size.width + groundSprite3.size.width / 2, self.frame.size.height - groundSprite1.size.height / 2)
        
        let roofEndPosition = CGPointMake(-(groundSprite1.size.width / 2), self.frame.size.height - groundSprite1.size.height / 2)
        let roofStartPosition = CGPointMake(frame.size.width + groundSprite3.size.width / 2, self.frame.size.height - groundSprite1.size.height / 2)
        
        let moveRoofSprite = SKAction.moveTo(roofEndPosition, duration: NSTimeInterval(6))
        let resetRoofSprite = SKAction.moveTo(roofStartPosition, duration: 0.0)
        let moveRoofSpritesForever = SKAction.repeatActionForever(SKAction.sequence([resetRoofSprite,moveRoofSprite]))
        
        let startRoofSprite1 = SKAction.moveTo(roofEndPosition, duration: NSTimeInterval(2))
        let startRoofSprite2 = SKAction.moveTo(roofEndPosition, duration: NSTimeInterval(4))
        
        roofSprite1.runAction(SKAction.sequence([startRoofSprite1, moveRoofSpritesForever]))
        roofSprite2.runAction(SKAction.sequence([startRoofSprite2, moveRoofSpritesForever]))
        roofSprite3.runAction(moveRoofSpritesForever)
        
        roofSprite1.yScale = -1
        roofSprite2.yScale = -1
        roofSprite3.yScale = -1
        
        self.addChild(roofSprite1)
        self.addChild(roofSprite2)
        self.addChild(roofSprite3)
        
        //adds imovable roof physics
        var roof = SKNode()
        roof.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height-roofTexture1.size().height * 0.7) //roof.position = CENTER POINT
        roof.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, roofTexture1.size().height * 0.01))
        roof.physicsBody?.dynamic = false
        roof.physicsBody?.categoryBitMask = worldCategory
        self.addChild(roof)
        
    }

    func spawnStone() {
        var stone = FlappyStoneNode()
        var scale = getRandomCGFloat(100.0, end: 200.0)
        scale = scale / 100
        let testTexture = SKTexture(imageNamed: "ffparalaxe1")
        var bottom = testTexture.size().height
        var top = self.frame.size.height - testTexture.size().height
        var pos = getRandomCGFloat(bottom, end: top)
        stone.setScale(scale)
        stone.position = CGPointMake(self.frame.size.width + stone.size.width / 2, pos)
        stone.setupMovement(self.frame, vel: stoneVel)
        
        var rotation = getRandomCGFloat(1, end: 4)
        stone.zRotation = rotation
        
        self.addChild(stone)
        
        var stoneParticle = FlappyParticleNode.fromFile("MyParticle2")
        stoneParticle!.position = CGPointMake(self.frame.size.width + stone.size.width / 2, pos)
        stoneParticle!.name = "stoneParticle"
        stoneParticle!.targetNode = self.scene
        
        stoneParticle!.setupMovement(self.frame, node: stone, vel: stoneVel)
        self.addChild(stoneParticle!)
        
    }
    
    func spawnPowerUp() {
        var powerUp = FlappyPowerupNode()
        let testTexture = SKTexture(imageNamed: "ffparalaxe1")
        var bottom = testTexture.size().height
        var top = self.frame.size.height - testTexture.size().height
        var pos = getRandomCGFloat(bottom, end: top)
        powerUp.position = CGPointMake(self.frame.size.width + powerUp.size.width / 2, pos)
        powerUp.setupMovement(self.frame)
        self.addChild(powerUp)
    }
    
    func getRandomCGFloat(begin:CGFloat,end:CGFloat) -> CGFloat {
        var beginUint = UInt32(Int(begin))
        var endUint = UInt32(Int(end))
        var random = (arc4random() % (endUint - beginUint)) + beginUint
        var num = CGFloat(Int(random))
        
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
        testPlayer!.identifier = "test player"
        testPlayer!.position = CGPoint(x: self.frame.size.width / 2, y:self.frame.size.height / 2)
        self.addChild(testPlayer!)
    }
    
    func playerSwim(identifier:String, way:String) {
        for player in players {
            if player.identifier == identifier {
                if way == "up" {
                    player.goUp()
                } else {
                    player.goDown()
                }
            }
        }
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if let player = testPlayer {
                if location.y > self.frame.size.height / 2 {
                    player.goUp()
                } else {
                    player.goDown()
                  
                }
            }
            
        }

    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        //checks colision with end of screen
        if ( contact.bodyA.categoryBitMask & endScreenCategory ) == endScreenCategory || ( contact.bodyB.categoryBitMask & endScreenCategory ) == endScreenCategory {
            for player in players{
                println("entrou aqui")
                if player.physicsBody == contact.bodyA || player.physicsBody == contact.bodyB{
                    println(player.identifier)
                    players.removeObject(player)
                    player.removeFromParent()
                
                }
            }
        }
        
        //checks colision player / powerup
        if contact.bodyA.categoryBitMask == powerUpCategory && contact.bodyB.categoryBitMask == playerCategory {
            handleColisionPlayerPowerup(player:contact.bodyB, powerup: contact.bodyA)
        } else if contact.bodyB.categoryBitMask == powerUpCategory && contact.bodyA.categoryBitMask == playerCategory {
            handleColisionPlayerPowerup(player:contact.bodyA, powerup: contact.bodyB)
        }
        
    }
    
    func handleColisionPlayerPowerup(#player:SKPhysicsBody,powerup:SKPhysicsBody) {
        var playerNode:FlappyPlayerNode = player.node as! FlappyPlayerNode
        var powerupNode:FlappyPowerupNode = powerup.node as! FlappyPowerupNode
        playerNode.boostAndStop()
        powerupNode.blowUp()
    }
    
}