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
    
    deinit {
        print("DEI O DEINIT?")
    }
    
    var players:[FlappyPlayerNode] = []
    var singlePlayer:FlappyPlayerNode?
    var testPlayerLive = true
    var cont = 1 //contador usado para o timer do singleplayer
    
    //dont touch this variable:
    let stoneVel = 8.0
    
    //change this variable to change world speed:
    let worldVelMultiplier = 1.0
    
    var winnerRanking:[String] = [] //first is first to win
    var loserRanking:[String] = [] //first is first to lose
    
    let playerCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let stoneCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    let endScreenWinCategory: UInt32 = 1 << 4
    let endScreenLoseCategory: UInt32 = 1 << 4
    let powerUpCategory: UInt32 = 1 << 6
    
    override func update(currentTime: NSTimeInterval) {
        
        for fish in players{
            fish.updateRotation()
        }
        
        //println(gameManager.isMultiplayer)
        if players.count == 1 && GameManager.sharedInstance.isMultiplayer == true && !self.paused{
            for p in players{
                self.playerRank.append(p.identifier!)
            }
            self.gameOverMP()
            self.paused = true
        }
        if let fish = singlePlayer {
            fish.updateRotation()
        }
    }
    
    override func didMoveToView(view: SKView) {

        
        beginCountDown(completion: {self.createPlayersAndObstacles()})
        
        setupWalls()
        
        // setup physics
        self.physicsWorld.gravity = CGVectorMake( 0.0, 0.0 )
        self.physicsWorld.contactDelegate = self
        
        // setup background color
        let skyColor = SKColor(red: 79/255.0, green: 146/255.0, blue: 201.0/255.0, alpha: 1.0)
        self.backgroundColor = skyColor
        

        // left wall , if you hit you are dead
        let wallLeft = SKNode()
        wallLeft.position = CGPointMake(0, self.frame.size.height / 2)
        wallLeft.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(1, self.frame.height))
        wallLeft.physicsBody?.dynamic = false
        wallLeft.physicsBody?.categoryBitMask = endScreenLoseCategory
        wallLeft.physicsBody?.contactTestBitMask = playerCategory
        self.addChild(wallLeft)
        
        //right wall, if you hit you win
        let wallRight = SKNode()
        wallRight.position = CGPointMake(self.frame.width, self.frame.size.height / 2)
        wallRight.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(1, self.frame.height))
        wallRight.physicsBody?.dynamic = false
        wallRight.physicsBody?.categoryBitMask = endScreenWinCategory
        wallRight.physicsBody?.contactTestBitMask = playerCategory
        wallRight.physicsBody?.collisionBitMask = playerCategory
        self.addChild(wallRight)
        
        weak var waterParticle = FlappyParticleNode.fromFile("teste")
        waterParticle?.position = CGPointMake(frame.size.width + (frame.size.width/2 ) + 20 , frame.size.height/2)
        waterParticle!.targetNode = self.scene
        self.addChild(waterParticle!)
        waterParticle?.zPosition = 10
        
    }
    
    func beginCountDown(completion completion:() -> ()) {
        let countDownNode = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        countDownNode.position = CGPoint(x: self.frame.size.width / 2, y:self.frame.size.height / 2)
        countDownNode.zPosition = 100
        countDownNode.fontSize = 100.0
        var actions:[SKAction] = []
        self.addChild(countDownNode)
        
        for i in (1...3).reverse() {
            let changeNumber = SKAction.runBlock({() in
                countDownNode.text = "\(i)"
            })
            let wait = SKAction.waitForDuration(1)
            actions += [changeNumber,wait]
        }
        
        let removeNode = SKAction.runBlock({() in
            countDownNode.removeFromParent()
        })
        actions.append(removeNode)
        let actionSequence = SKAction.sequence(actions)
        countDownNode.runAction(actionSequence, completion: {() -> Void in
            completion()
        })
    }
    
    func timerForSinglePlayer(){
        let timerNode = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        timerNode.position = CGPoint(x: self.frame.size.width / 2, y:self.frame.size.height - 150)
        timerNode.zPosition = 100
        timerNode.fontSize = 150
        self.addChild(timerNode)

        let wait = SKAction.waitForDuration(1)
        let run = SKAction.runBlock {
            // your code here ...
            timerNode.text = "\(self.cont++)"
        }
        
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([wait, run])))
    }
    
    func createPlayersAndObstacles() {
        
        if GameManager.sharedInstance.isMultiplayer {
            self.spawnPlayers()
        } else {
            spawnSinglePlayer()
        }
        
        if GameManager.sharedInstance.isMultiplayer == false{
            self.timerForSinglePlayer()
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
        let ground = SKNode()
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
        let roof = SKNode()
        roof.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height-dummyTexture.size().height * 0.7)
        roof.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, dummyTexture.size().height * 0.01))
        roof.physicsBody?.dynamic = false
        roof.physicsBody?.categoryBitMask = worldCategory
        self.addChild(roof)
    }

    func spawnStone() {
        let stone = FlappyStoneNode()
        let scale = CGFloat.random(min: 1, max: 2)
        let testTexture = SKTexture(imageNamed: "ffparalaxe1")
        let bottom = testTexture.size().height
        let top = self.frame.size.height - testTexture.size().height
        let pos = CGFloat.random(min: bottom, max: top)
        stone.setScale(scale)
        stone.position = CGPointMake(self.frame.size.width + self.frame.size.width / 2, pos)
        stone.setupMovement(self.frame, vel: stoneVel * worldVelMultiplier)
        
        let rotation = CGFloat.random(min: 1, max: 4)
        
        
        stone.zRotation = rotation
        stone.zPosition = 9
        self.addChild(stone)
        
        let particleScales = 0.3 * scale
        weak var stoneParticleLow = FlappyParticleNode.fromFile("MyParticle")
        stoneParticleLow!.position = CGPointMake(stone.position.x, stone.position.y - (stone.size.height/2) + 10)
        stoneParticleLow!.name = "stoneParticleLow"
        stoneParticleLow!.particleScale = particleScales
        stoneParticleLow!.targetNode = self.scene
        stoneParticleLow!.setupMovement(self.frame, node: stone, vel: stoneVel * worldVelMultiplier)
        self.addChild(stoneParticleLow!)
    
        weak var stoneParticleHigh = FlappyParticleNode.fromFile("MyParticle")
        stoneParticleHigh!.position = CGPointMake(stone.position.x, stone.position.y + stone.size.height/2)
        stoneParticleHigh!.name = "stoneParticleHigh"
        stoneParticleHigh!.particleScale = particleScales
        stoneParticleHigh!.targetNode = self.scene
        stoneParticleHigh!.setupMovement(self.frame, node: stone, vel: stoneVel * worldVelMultiplier)
        self.addChild(stoneParticleHigh!)
    }
    
    func spawnPowerUp() {
        let powerUp = FlappyPowerupNode()
        let testTexture = SKTexture(imageNamed: "ffparalaxe1")
        let bottom = testTexture.size().height
        let top = self.frame.size.height - testTexture.size().height
        let pos = CGFloat.random(min: bottom, max: top)
        powerUp.position = CGPointMake(self.frame.size.width + powerUp.size.width / 2, pos)
        powerUp.setupMovement(self.frame)
        self.addChild(powerUp)
    }
    
    func spawnPlayers() {
        
        let boardPlayers = GameManager.sharedInstance.players
        
        for boardPlayer in boardPlayers {
            let player = FlappyPlayerNode()
            player.identifier = boardPlayer.playerIdentifier
            player.color = boardPlayer.color
            player.position = CGPoint(x: self.frame.size.width / 2, y:self.frame.size.height / 2)
            self.addChild(player)
            players.append(player)
            _ = SKTexture(imageNamed: "spark.png")
            let playerParticle = FlappyParticleNode.fromFile("PlayerParticle")
            playerParticle!.name = "PlayerParticle"
            playerParticle!.targetNode = player
            player.addChild(playerParticle!)
            playerParticle?.position = CGPoint(x: -43, y: 0)
        }
        
    }
    
    func spawnSinglePlayer() {
        
        singlePlayer = FlappyPlayerNode()
        singlePlayer!.identifier = "Player"
        singlePlayer!.position = CGPoint(x: self.frame.size.width / 2, y:self.frame.size.height / 2)
        self.addChild(singlePlayer!)
        
        _ = SKTexture(imageNamed: "spark.png")
        weak var playerParticle = FlappyParticleNode.fromFile("PlayerParticle")
        playerParticle!.name = "PlayerParticle"
        playerParticle!.targetNode = self.scene
        singlePlayer!.addChild(playerParticle!)
        playerParticle?.position = CGPoint(x: -43, y: 0)
        
    }
    
    func gameOverMP(){
        for winner in winnerRanking {
            playerRank.append(winner)
        }
        for lastPlayer in players { //deveria ser só 1 talvez mas vai saber ne
            playerRank.append(lastPlayer.identifier!)
        }
        loserRanking = Array(loserRanking.reverse())
        for loser in loserRanking {
            playerRank.append(loser)
        }
        
        self.removeAllChildren()
        self.removeAllActions()
        _ = SKTransition.flipHorizontalWithDuration(0.5)
        let goScene = GameOverSceneMP(size: self.size)
        goScene.player = playerRank.reverse()
        self.view?.presentScene(goScene)
    }
    
    // MARK: - Player Action Handling
    
    // Multiplayer
    override func messageReceived(identifier: String, dictionary: NSDictionary) {
        for player in players {
            if player.identifier == identifier {
                let message = dictionary["way"] as! String
                let messageEnum = PlayerAction(rawValue: message)
                if messageEnum == .Up {
                    player.goUp()
                } else {
                    player.goDown()
                }
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        gameOverSP()
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if let player = singlePlayer {
                if location.y > self.frame.size.height / 2 {
                    player.goUp()
                } else {
                    player.goDown()
                }
            }
            
        }

    }
    
    // MARK: - Contact Handling
    
    func didBeginContact(contact: SKPhysicsContact) {
        //checks colision with bad end of screen
        if contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == endScreenLoseCategory {
            handleColisionEndOfScreenBad(playerBody: contact.bodyA, endscreenBody: contact.bodyB)
        } else if contact.bodyA.categoryBitMask == endScreenLoseCategory && contact.bodyB.categoryBitMask == playerCategory {
            handleColisionEndOfScreenBad(playerBody: contact.bodyB, endscreenBody: contact.bodyA)
        }
        
        //checks colision with good end of screen
        if contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == endScreenWinCategory {
            handleColisionEndOfScreenGood(playerBody: contact.bodyA, endscreenBody: contact.bodyB)
        } else if contact.bodyA.categoryBitMask == endScreenWinCategory && contact.bodyB.categoryBitMask == playerCategory {
            handleColisionEndOfScreenGood(playerBody: contact.bodyB, endscreenBody: contact.bodyA)
        }
        
        //checks colision player / powerup
        if contact.bodyA.categoryBitMask == powerUpCategory && contact.bodyB.categoryBitMask == playerCategory {
            handleColisionPlayerPowerup(player:contact.bodyB, powerup: contact.bodyA)
        } else if contact.bodyB.categoryBitMask == powerUpCategory && contact.bodyA.categoryBitMask == playerCategory {
            handleColisionPlayerPowerup(player:contact.bodyA, powerup: contact.bodyB)
        }
        
    }
    
    //handles losing colision
    func handleColisionEndOfScreenBad(playerBody playerBody:SKPhysicsBody,endscreenBody:SKPhysicsBody) {
        for player in players{
            if player.physicsBody == playerBody {
                print(player.identifier)
                players.removeObject(player)
                player.removeFromParent()
                self.loserRanking.append(player.identifier!)
            }
        }
        if let _ = singlePlayer {
            // game over
            self.paused = true
            self.gameOverSP("fish", winner: "", score: cont)
        }
    }
    
    //handles winning colision
    func handleColisionEndOfScreenGood(playerBody playerBody:SKPhysicsBody,endscreenBody:SKPhysicsBody) {
        for player in players{
            if player.physicsBody == playerBody {
                print(player.identifier)
                players.removeObject(player)
                player.removeFromParent()
                self.winnerRanking.append(player.identifier!)
            }
        }
    }
    
    func handleColisionPlayerPowerup(player player:SKPhysicsBody,powerup:SKPhysicsBody) {
        self.runAction(AudioSource.sharedInstance.playBubbleSound())
        let playerNode:FlappyPlayerNode = player.node as! FlappyPlayerNode
        let powerupNode:FlappyPowerupNode = powerup.node as! FlappyPowerupNode
        playerNode.boostAndStop()
        powerupNode.blowUp()
    }

    
}