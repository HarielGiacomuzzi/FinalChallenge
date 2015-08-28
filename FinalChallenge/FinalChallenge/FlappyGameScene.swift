//
//  FlappyGameScene.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 8/4/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import SpriteKit


class FlappyGameScene : MinigameScene, SKPhysicsContactDelegate {
    
    var players:[FlappyPlayerNode] = []
    var testPlayer:FlappyPlayerNode?
    //dont touch this variable:
    let stoneVel = 8.0
    
    //change this variable to change world speed:
    let worldVelMultiplier = 1.0
    
    let playerCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let stoneCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    let endScreenCategory: UInt32 = 1 << 4
    let powerUpCategory: UInt32 = 1 << 5
    
    override func update(currentTime: NSTimeInterval) {
        
        //println(gameManager.isMultiplayer)
        if players.count == 0 && gameManager.isMultiplayer == true && !self.paused{
            println(self.gameManager.playerRank.count)
            for p in players{
                self.playerRank.append(p.identifier!)
            }
            self.gameOver()
            self.paused = true
//            AudioSource.sharedInstance.stopAudio()
        }
    }
    
    override func didMoveToView(view: SKView) {
        
        startGame()
        
        self.setupWalls()
        
        //AudioSource.sharedInstance.flappyFishSound()
        
        // setup physics
        self.physicsWorld.gravity = CGVectorMake( 0.0, 0.0 )
        self.physicsWorld.contactDelegate = self
        
        // setup background color
        var skyColor = SKColor(red: 79/255.0, green: 146/255.0, blue: 201.0/255.0, alpha: 1.0)
        self.backgroundColor = skyColor


        // left wall , if you hit you are dead
        var wallLeft = SKNode()
        wallLeft.position = CGPointMake(0, self.frame.size.height / 2)
        wallLeft.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(1, self.frame.height))
        wallLeft.physicsBody?.dynamic = false
        wallLeft.physicsBody?.categoryBitMask = endScreenCategory
        wallLeft.physicsBody?.contactTestBitMask = playerCategory
        self.addChild(wallLeft)
        
        //right wall, if you hit you win
        var wallRight = SKNode()
        wallRight.position = CGPointMake(self.frame.width, self.frame.size.height / 2)
        wallRight.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(1, self.frame.height))
        wallRight.physicsBody?.dynamic = false
        wallRight.physicsBody?.categoryBitMask = endScreenCategory
        wallRight.physicsBody?.contactTestBitMask = playerCategory
        self.addChild(wallRight)
        
        var newParticle = FlappyParticleNode.fromFile("teste")
        newParticle?.position = CGPointMake(frame.size.width + (frame.size.width/2 ) + 20 , frame.size.height/2)
        newParticle!.targetNode = self.scene
        self.addChild(newParticle!)
        newParticle?.zPosition = 10
        
    }
    
    func startGame() {
        var countDownNode = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        countDownNode.position = CGPoint(x: self.frame.size.width / 2, y:self.frame.size.height / 2)
        countDownNode.zPosition = 100
        countDownNode.fontSize = 100.0
        var actions:[SKAction] = []
        self.addChild(countDownNode)
        
        for i in reverse(1...3) {
            var changeNumber = SKAction.runBlock({() in
                countDownNode.text = "\(i)"
            })
            var wait = SKAction.waitForDuration(1)
            actions += [changeNumber,wait]
        }
        
        var removeNode = SKAction.runBlock({() in
            countDownNode.removeFromParent()
        })
        actions.append(removeNode)
        var actionSequence = SKAction.sequence(actions)
        countDownNode.runAction(actionSequence, completion: {() -> Void in
            self.createPlayersAndObstacles()
        })

    }
    
    func createPlayersAndObstacles() {
        self.spawnPlayers()
        
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
    }
    
    func setupWalls(){
        
        let dummyTexture = SKTexture(imageNamed: "ffparalaxe1")
        
        var currentWidth: CGFloat = 0.0
        
        // creates ground texture
        
        for i in 1...3 {
            let texture = SKTexture(imageNamed: "ffparalaxe\(i)")
            texture.filteringMode = .Nearest
            
            let sprite = SKSpriteNode(texture: texture)
            sprite.position = CGPointMake(currentWidth + sprite.size.width / 2, sprite.size.height / 2)
            
            let endPosition = CGPointMake(-(sprite.size.width / 2), sprite.size.height / 2)
            let startPosition = CGPointMake(frame.size.width + sprite.size.width / 2, sprite.size.height / 2)
            
            let moveGroundSprite = SKAction.moveTo(endPosition, duration: NSTimeInterval(6.0 * worldVelMultiplier))
            let resetGroundSprite = SKAction.moveTo(startPosition, duration: 0.0)
            let moveGroundSpritesForever = SKAction.repeatActionForever(SKAction.sequence([resetGroundSprite,moveGroundSprite]))
            let firstMovement = SKAction.moveTo(endPosition, duration: NSTimeInterval(2.0 * Double(i) * worldVelMultiplier))
            
            sprite.runAction(SKAction.sequence([firstMovement,moveGroundSpritesForever]))
            sprite.zPosition = 12
            
            self.addChild(sprite)
            currentWidth += sprite.size.width
            
        }
        
        currentWidth = 0.0

        //adds imovable ground physics
        var ground = SKNode()
        ground.position = CGPointMake(self.frame.size.width / 2, dummyTexture.size().height * 0.7)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, dummyTexture.size().height * 0.01))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = worldCategory
        self.addChild(ground)
        
        //create roof texture
        for i in 1...3 {
            let texture = SKTexture(imageNamed: "ffparalaxe\(i)")
            texture.filteringMode = .Nearest
            
            let sprite = SKSpriteNode(texture: texture)
            sprite.position = CGPointMake(currentWidth + sprite.size.width / 2, self.frame.size.height - sprite.size.height / 2)
            
            let endPosition = CGPointMake(-(sprite.size.width / 2), self.frame.size.height - sprite.size.height / 2)
            let startPosition = CGPointMake(frame.size.width + sprite.size.width / 2, self.frame.size.height - sprite.size.height / 2)
            
            let moveGroundSprite = SKAction.moveTo(endPosition, duration: NSTimeInterval(6.0 * worldVelMultiplier))
            let resetGroundSprite = SKAction.moveTo(startPosition, duration: 0.0)
            let moveGroundSpritesForever = SKAction.repeatActionForever(SKAction.sequence([resetGroundSprite,moveGroundSprite]))
            let firstMovement = SKAction.moveTo(endPosition, duration: NSTimeInterval(2.0 * Double(i) * worldVelMultiplier))
            
            sprite.runAction(SKAction.sequence([firstMovement,moveGroundSpritesForever]))
            sprite.yScale = -1
            
            sprite.zPosition = 11
            
            self.addChild(sprite)
            currentWidth += sprite.size.width
            
        }

        //adds imovable roof physics
        var roof = SKNode()
        roof.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height-dummyTexture.size().height * 0.7)
        roof.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, dummyTexture.size().height * 0.01))
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
        stone.position = CGPointMake(self.frame.size.width + self.frame.size.width / 2, pos)
        stone.setupMovement(self.frame, vel: stoneVel * worldVelMultiplier)
        
        var rotation = getRandomCGFloat(1, end: 4)
        stone.zRotation = rotation
        stone.zPosition = 9
        self.addChild(stone)
        
        var particleScales = 0.3 * scale
        var stoneParticleLow = FlappyParticleNode.fromFile("MyParticle")
        stoneParticleLow!.position = CGPointMake(stone.position.x, stone.position.y - (stone.size.height/2) + 10)
        stoneParticleLow!.name = "stoneParticleLow"
        stoneParticleLow!.particleScale = particleScales
        stoneParticleLow!.targetNode = self.scene
        stoneParticleLow!.setupMovement(self.frame, node: stone, vel: stoneVel * worldVelMultiplier)
        self.addChild(stoneParticleLow!)
    
        var stoneParticleHigh = FlappyParticleNode.fromFile("MyParticle")
        stoneParticleHigh!.position = CGPointMake(stone.position.x, stone.position.y + stone.size.height/2)
        stoneParticleHigh!.name = "stoneParticleHigh"
        stoneParticleHigh!.particleScale = particleScales
        stoneParticleHigh!.targetNode = self.scene
        stoneParticleHigh!.setupMovement(self.frame, node: stone, vel: stoneVel * worldVelMultiplier)
        self.addChild(stoneParticleHigh!)
        
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
        
        gameManager.isMultiplayer = true
        
        let connectedPeers = ConnectionManager.sharedInstance.session.connectedPeers
        let boardPlayers = GameManager.sharedInstance.players
        
        for connectedPeer in connectedPeers {
            var player = FlappyPlayerNode()
            player.identifier = connectedPeer.displayName
            
            for boardPlayer in boardPlayers {
                if player.identifier == boardPlayer.playerIdentifier {
                    player.color = boardPlayer.color
                }
            }

            player.position = CGPoint(x: self.frame.size.width / 2, y:self.frame.size.height / 2)
            self.addChild(player)
            players.append(player)
            var particleTexture = SKTexture(imageNamed: "spark.png")
            var playerParticle = FlappyParticleNode.fromFile("PlayerParticle")
            playerParticle!.name = "PlayerParticle"
            playerParticle!.targetNode = player
            player.addChild(playerParticle!)
            playerParticle?.position = CGPoint(x: -43, y: 0)
        }
    }
    
    func spawnSinglePlayer() {
        
        gameManager.isMultiplayer = false
        
        testPlayer = FlappyPlayerNode()
        testPlayer!.identifier = "test player"
        testPlayer!.position = CGPoint(x: self.frame.size.width / 2, y:self.frame.size.height / 2)
        self.addChild(testPlayer!)
        
        var particleTexture = SKTexture(imageNamed: "spark.png")
        var playerParticle = FlappyParticleNode.fromFile("PlayerParticle")
        playerParticle!.name = "PlayerParticle"
        playerParticle!.targetNode = self.scene
        testPlayer!.addChild(playerParticle!)
        playerParticle?.position = CGPoint(x: -43, y: 0)
        
    }
    
    override func messageReceived(identifier:String, action:PlayerAction) {
        for player in players {
            if player.identifier == identifier {

                //movimento pelo gamepad
                if action == .Up {
                    player.goUp()
                } else {
                    player.goDown()
                }
            }
        }
        
    }
    
    func gameOver(){
        //self
        //dispatch_async(dispatch_get_main_queue(),{ [unowned self] in
            //self.gameController!.gameOverTableView.reloadData()
            //self.gameController?.gameOverTableView.beginUpdates()
            //self.gameController?.gameOverTableView.beginUpdates()
      // })
      //  self.gameController!.GameOverView.hidden = false
        
        self.gameController!.gameOverController(playerRank.reverse())
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
                if player.physicsBody == contact.bodyA || player.physicsBody == contact.bodyB{
                    println(player.identifier)
                    players.removeObject(player)
                    player.removeFromParent()
                    self.playerRank.append(player.identifier!)
                    //AudioSource.sharedInstance.readAudioFile("explosionSound", ext: "wav")
                    //self.gameManager.playerRank.append(player.identifier!)
                    //self.gameOver()
                }
            }
        }
        
        //checks colision player / powerup
        if contact.bodyA.categoryBitMask == powerUpCategory && contact.bodyB.categoryBitMask == playerCategory {
            handleColisionPlayerPowerup(player:contact.bodyB, powerup: contact.bodyA)
            self.runAction(AudioSource.sharedInstance.playBubbleSound())
            //AudioSource.sharedInstance.bubbleSound()
        } else if contact.bodyB.categoryBitMask == powerUpCategory && contact.bodyA.categoryBitMask == playerCategory {
            handleColisionPlayerPowerup(player:contact.bodyA, powerup: contact.bodyB)
            self.runAction(AudioSource.sharedInstance.playBubbleSound())
            //AudioSource.sharedInstance.bubbleSound()
        }
        
    }
    
    func handleColisionPlayerPowerup(#player:SKPhysicsBody,powerup:SKPhysicsBody) {
        var playerNode:FlappyPlayerNode = player.node as! FlappyPlayerNode
        var powerupNode:FlappyPowerupNode = powerup.node as! FlappyPowerupNode
        playerNode.boostAndStop()
        powerupNode.blowUp()
    }
    
}