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

    let playerCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    let endScreenCategory: UInt32 = 1 << 4
    
    var moveStonesAndRemove:SKAction!
    var moving:SKNode!
    var stones:SKNode!
    
    
    override func didMoveToView(view: SKView) {
        
        // setup physics
        self.physicsWorld.gravity = CGVectorMake( 0.0, 0.0 )
        self.physicsWorld.contactDelegate = self
        
        // setup background color
        var skyColor = SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        self.backgroundColor = skyColor
        
        moving = SKNode()
        self.addChild(moving)
        stones = SKNode()
        moving.addChild(stones)
        
        self.spawnPlayers()
        self.gameLimit()
        
        //nobody connected
        if players.count == 0 {
            spawnSinglePlayer()
        }

        // create the stones movement actions
        let distanceToMove = CGFloat(self.frame.size.width + self.frame.size.width / 2)
        let moveStones = SKAction.moveByX(-distanceToMove, y:0.0, duration:NSTimeInterval(0.01 * distanceToMove))
        let removeStones = SKAction.removeFromParent()
        moveStonesAndRemove = SKAction.sequence([moveStones, removeStones])
        
        // spawn the stones
        let spawn = SKAction.runBlock({() in self.spawnStones()})
        
        let delay = SKAction.waitForDuration(2.5, withRange: 1)
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)

        
        var contactNode = SKNode()
        contactNode.position = CGPointMake(0, self.frame.size.height / 2)
        contactNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(1, self.frame.height))
        contactNode.physicsBody?.dynamic = false
        contactNode.physicsBody?.categoryBitMask = endScreenCategory
        contactNode.physicsBody?.contactTestBitMask = playerCategory
        self.addChild(contactNode)
        
            if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad)
            {
                // Ipad
                if players.count == 1{
                    //end game
                    println("Fim de jogo")
                }
            }
            else
            {
                // Iphone
            }
        
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
        ground.position = CGPointMake(self.frame.size.width / 2, groundTexture.size().height) //ground.position = CENTER POINT
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, groundTexture.size().height * 0.01))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = worldCategory
        self.addChild(ground)

        //create roof texture
        let roofTexture = SKTexture(imageNamed: "land")
        roofTexture.filteringMode = .Nearest
        
        //creates roof movement
        let moveRoofSprite = SKAction.moveByX(-roofTexture.size().width * 0.5, y: 0, duration: NSTimeInterval(0.02 * roofTexture.size().width*0.5))
        let resetRoofSprite = SKAction.moveByX(roofTexture.size().width * 0.5, y: 0, duration: 0.0)
        let moveRoofSpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveRoofSprite,resetRoofSprite]))
        
        // this loop draws the texture side by side until it fills the roof
        for var i:CGFloat = 0; i < 3.0 + self.frame.size.width / ( roofTexture.size().width * 2.0 ); ++i {
            // draws sprite
            let sprite = SKSpriteNode(texture: roofTexture)
            sprite.setScale(1.0)
            sprite.position = CGPointMake(i * sprite.size.width, self.frame.size.height-sprite.size.height/2)
            // sprite.position = CENTER POINT
            
            //sets up movement
            sprite.runAction(moveRoofSpritesForever)
            
            //adds sprite to game
            self.addChild(sprite)
        }
        
        
        //adds imovable roof physics
        var roof = SKNode()
        roof.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height-roofTexture.size().height) //roof.position = CENTER POINT
        roof.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, roofTexture.size().height * 0.01))
        roof.physicsBody?.dynamic = false
        roof.physicsBody?.categoryBitMask = worldCategory
        self.addChild(roof)
        
        
    }
    
    func spawnStones() {
        var stone = FlappyStoneNode()
        var scale = getRandomCGFloat(1.0, end: 5.0)
        let testTexture = SKTexture(imageNamed: "land")
        
        var bottom = testTexture.size().height
        var top = self.frame.size.height - testTexture.size().height

        var pos = getRandomCGFloat(bottom, end: top)
        
        stone.setScale(scale)
        stone.position = CGPointMake(self.frame.size.width + stone.size.width / 2, pos)
        
        stone.runAction(moveStonesAndRemove)
        stones.addChild(stone)
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
        if ( contact.bodyA.categoryBitMask & endScreenCategory ) == endScreenCategory || ( contact.bodyB.categoryBitMask & endScreenCategory ) == endScreenCategory {
            println("Será que bate?")
            for player in players{
                println("entrou aqui")
                if player.physicsBody == contact.bodyA || player.physicsBody == contact.bodyB{
                    println(player.identifier)
                    players.removeObject(player)
                
                }
            }
        }
        
    }
    
    
}