//
//  BombTGameScene.swift
//  FinalChallenge
//
//  Created by Jonathas Hernandes on 21/08/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation

import Foundation
import SpriteKit


class BombTGameScene : MinigameScene, SKPhysicsContactDelegate {
    
    
    var walls:[BombWallNode] = [] //0 = north, 1 = south, 2 = east, 3 = west
    var players:[BombPlayerNode] = []//0 = north, 1 = south, 2 = east, 3 = west
    var pavioArray:[SKSpriteNode] = []
    var bomb:SKSpriteNode!
    var fagulha:FireBombSpark!
    var jointBombPlayer:SKPhysicsJoint?
    var fagulhaJoint:SKPhysicsJoint!
    
    var bombShouldTick = false
    var bombShouldExplode = false
    var playerActive = ""
    
    var fagulhando = false
    
    // limits of game area
    var maxX:CGFloat = 0.0
    var minX:CGFloat = 0.0
    var maxY:CGFloat = 0.0
    var minY:CGFloat = 0.0
    
    let bombSpeedMultiplier:CGFloat = 300.0

    var playersRank:[BombPlayerNode] = []
    
    var playerWithBomb:BombPlayerNode?
    
    let playerCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let bombCategory: UInt32 = 1 << 2
    let fireCategory: UInt32 = 1 << 3
    let explodePartsCategory : UInt32 = 1 << 4
    
    var beginX:CGFloat = 0.0
    var beginY:CGFloat = 0.0
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.locationInView(self.view)
        beginX = location.x
        beginY = location.y
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.locationInView(self.view)
        var endX = location.x
        var endY = location.y
        var x = endX - beginX
        var y = (endY - beginY) * -1
        
        var vector = CGVectorMake(x, y)
        
        vector.normalize()
        
        throwBomb(vector.dx, y: vector.dy)
    }
    
    override func update(currentTime: NSTimeInterval) {
        self.gameOver()
    }
    
    override func didMoveToView(view: SKView) {
        startGame()
        
    }
    
    func startGame() {
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        
        // fund
        let fundo = SKSpriteNode(imageNamed: "floor")
        self.addChild(fundo)
        fundo.position = CGPoint(x: self.frame.width / 2, y : self.frame.height/2)
        fundo.zPosition = 1
        
        
        
        //MUST SETUP WALLS BEFORE PLAYERS
        setupWalls()

        spawnSinglePlayer()
        if ConnectionManager.sharedInstance.session.connectedPeers.count > 0 {
            spawnPlayers()
        }
        createPlayersAndObstacles()
        generateBomb(nil, bombTimer: 100)
        
    }
    

    
    func createPlayersAndObstacles() {

        // cria jogadores
        
        
    
    }
    
    func setupWalls(){
        //north wall
        var size = CGSize(width: self.frame.size.height, height: 45)
        var north = BombWallNode(size: size, texture: SKTexture(imageNamed: "wallh"))
        north.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height - 15)
        self.addChild(north)
        north.zPosition = 2
        walls.append(north)
        maxY = north.position.y - north.size.height / 2
        north.hasPlayer = true
        
        //south wall
        size = CGSize(width: self.frame.size.height, height: 45)
        var south = BombWallNode(size: size, texture: SKTexture(imageNamed: "wallh"))
        south.position = CGPointMake(self.frame.size.width / 2, 15)
        self.addChild(south)
        south.zPosition = 2
        walls.append(south)
        minY = south.position.y + south.size.height / 2
        south.hasPlayer = true
        
        //east wall
        size = CGSize(width: 45, height: self.frame.size.height)
        let blackBar = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: (self.frame.width - south.size.width), height: self.frame.height))
        blackBar.position = CGPoint(x: 0 , y: self.frame.height/2)
        blackBar.zPosition = 2
        self.addChild(blackBar)
        
        
        var east = BombWallNode(size: size, texture: SKTexture(imageNamed: "wallv"))
        east.position = CGPointMake(north.position.x + north.size.width / 2, self.frame.size.height / 2)
        self.addChild(east)
        east.zPosition = 2
        walls.append(east)
        maxX = east.position.x - east.size.width / 2
        east.hasPlayer = true
        
        //west wall
        
        
        let blackBar2 = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: (self.frame.width - south.size.width), height: self.frame.height))
        blackBar2.position = CGPoint(x: self.frame.width , y: self.frame.height/2)
        blackBar2.zPosition = 2

        self.addChild(blackBar2)
        
        size = CGSize(width: 45, height: self.frame.size.height)
        var west = BombWallNode(size: size, texture: SKTexture(imageNamed: "wallv"))
        west.position = CGPointMake(north.position.x - north.size.width / 2, self.frame.size.height / 2)
        self.addChild(west)
        west.zPosition = 2
        walls.append(west)
        minX = west.position.x + west.size.width / 2
        west.hasPlayer = true
        
        
    }
    
    func spawnPlayers() {
        let connectedPeers = ConnectionManager.sharedInstance.session.connectedPeers
        let boardPlayers = GameManager.sharedInstance.players
        
        var i = 0
        
        for connectedPeer in connectedPeers {
            var player = players[i]
            player.zPosition = 10
            player.identifier = connectedPeer.displayName
            for boardPlayer in boardPlayers {
                if player.identifier == boardPlayer.playerIdentifier {
                    //player.color = boardPlayer.color
                }
            }
            i++
        }
        while i < players.count {
            players[i].removeFromParent()
            walls[i].hasPlayer = false
            i++
        }
    }
    
    func spawnSinglePlayer() {
        // criar a bomba
        
        var topRight = CGPointMake(maxX - 30, maxY - 30)
        var topLeft = CGPointMake(minX + 30, maxY - 30)
        var botRight = CGPointMake(maxX - 30, minY + 30)
        var botLeft = CGPointMake(minX + 30, minY + 30)
        

        var north = BombPlayerNode()
        north.position = topLeft
        var pi = CGFloat(M_PI)
        var angle = pi
        
        let rotN = SKAction.runBlock({() in
            north.roboBase?.runAction(SKAction.rotateByAngle(pi, duration: 0.3))
        })
        
        let waitN = SKAction.waitForDuration(0.3)
        
        let rotActionN = SKAction.group([rotN, waitN])

        let northMovement = SKAction.sequence([SKAction.moveTo(topRight, duration: 3.5),rotActionN,SKAction.moveTo(topLeft, duration: 3.5), rotActionN])
        north.runAction(SKAction.repeatActionForever(northMovement))
        self.addChild(north)
        players.append(north)
        
        
        
        var south = BombPlayerNode()
        
        let rotS = SKAction.runBlock({() in
            south.roboBase?.runAction(SKAction.rotateByAngle(pi, duration: 0.3))
        })
        
        let waitS = SKAction.waitForDuration(0.3)
        
        let rotActionS = SKAction.group([rotS, waitS])
        
        south.position = botRight
        let southMovement = SKAction.sequence([SKAction.moveTo(botLeft, duration: 3.5),rotActionS,SKAction.moveTo(botRight, duration: 3.5),rotActionS])
        south.runAction(SKAction.repeatActionForever(southMovement))
        self.addChild(south)
        players.append(south)
        
        var east = BombPlayerNode()
        
        let rotE = SKAction.runBlock({() in
            east.roboBase?.runAction(SKAction.rotateByAngle(pi, duration: 0.3))
        })
        
        let waitE = SKAction.waitForDuration(0.3)
        
        let rotActionE = SKAction.group([rotE, waitE])
        
        east.position = topRight
        east.roboBase!.zRotation = 1.57079633
        east.roboBody?.zRotation = -1.57079633
        let eastMovement = SKAction.sequence([SKAction.moveTo(botRight, duration: 3.5),rotActionE,SKAction.moveTo(topRight, duration: 3.5),rotActionE])
        east.runAction(SKAction.repeatActionForever(eastMovement))
        self.addChild(east)
        players.append(east)
        
        
        var west = BombPlayerNode()
        
        let rotW = SKAction.runBlock({() in
            west.roboBase?.runAction(SKAction.rotateByAngle(pi, duration: 0.3))
        })
        
        let waitW = SKAction.waitForDuration(0.3)
        
        let rotActionW = SKAction.group([rotW, waitW])
        
        west.position = botLeft
        west.roboBase!.zRotation = -1.57079633
        west.roboBody?.zRotation = -1.57079633
        let westMovement = SKAction.sequence([SKAction.moveTo(topLeft, duration: 3.5),rotActionW,SKAction.moveTo(botLeft, duration: 3.5),rotActionW])
        west.runAction(SKAction.repeatActionForever(westMovement))
        self.addChild(west)
        players.append(west)
        
        for wall in walls {
            wall.physicsBody?.usesPreciseCollisionDetection = true
        }
    }
    
    func gameOver(){
        //gameController = self.view?.window?.rootViewController as! FlappyGameViewController
        //gameController!.GameOverView.alpha = 1;
        
    }
    
    
    
    func didBeginContact(contact: SKPhysicsContact) {

        
        if (contact.bodyA.categoryBitMask == bombCategory && contact.bodyB.categoryBitMask == worldCategory) {
            handleBombWallContact(contact.bodyA,wall:contact.bodyB)
        } else if (contact.bodyA.categoryBitMask == worldCategory && contact.bodyB.categoryBitMask == bombCategory) {
            handleBombWallContact(contact.bodyB,wall:contact.bodyA)
        }
        
        if (contact.bodyA.categoryBitMask == bombCategory && contact.bodyB.categoryBitMask == playerCategory) {
            handlePlayerBombContact(contact.bodyA, player: contact.bodyB)
        } else if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == bombCategory) {
            handlePlayerBombContact(contact.bodyB, player: contact.bodyA)
        }
        

   
    }
    
    func handlePlayerBombContact(bomb:SKPhysicsBody, player:SKPhysicsBody) {
        let playerNode = player.node as! BombPlayerNode
        let bombNode = bomb.node as! SKSpriteNode
        if playerWithBomb != playerNode {
            jointBombPlayer = SKPhysicsJointFixed.jointWithBodyA(bomb, bodyB: player, anchor: playerNode.position)
            self.physicsWorld.addJoint(jointBombPlayer!)
            playerWithBomb = playerNode
            bombShouldTick = false
            playerActive = playerNode.identifier
            if bombShouldExplode {

                explodePlayer(playerNode, explodedBomb: bombNode)
                
            }
            

            
            let angle : CGFloat = atan2((bombNode.position.y - playerNode.position.y),
                                        (bombNode.position.x - playerNode.position.x))
            
//            if( playerNode.zRotation > 0){
//                playerNode.zRotation = playerNode.roboBody!.zRotation + CGFloat(M_PI) * 2
//            }
            
            let rotateToAngle = SKAction.rotateToAngle(angle, duration: 0.1)
            
            playerNode.roboBody!.runAction(rotateToAngle)
            
        }
        
    }
    
    func handleBombWallContact(bomb:SKPhysicsBody, wall:SKPhysicsBody) {
        let wallNode = wall.node as! BombWallNode
        if wallNode.hasPlayer {
            bomb.velocity = CGVectorMake(0.0, 0.0)
            bomb.angularVelocity = 0.0
            if bombShouldExplode {
                
            }
        } else {
            playerWithBomb = nil
            var velocity = bomb.velocity
            velocity.normalize()
            bomb.velocity = CGVectorMake(velocity.dx * bombSpeedMultiplier, velocity.dy * bombSpeedMultiplier)

        }
    }
    
    func explodePlayer(explodedPlayer:BombPlayerNode, explodedBomb:SKSpriteNode ) {
        //animate explosion here
        //...
        
        //remove stuff
        explodedBomb.removeFromParent()
        explodedPlayer.removeFromParent()
        fagulha.removeFromParent()
        for pavio in pavioArray {
            pavio.removeFromParent()
        }
        pavioArray = []
        
        //find correct wall
        for i in 0...3 {
            if explodedPlayer == players[i] {
                walls[i].hasPlayer = false
            }
        }
        
        let partsAtlas = SKTextureAtlas(named: "bombGame")
        
        // pedaços para todos os lados
        
        let robopart1 = SKSpriteNode(texture: partsAtlas.textureNamed("roboPart0"))
        let robopart2 = SKSpriteNode(texture: partsAtlas.textureNamed("roboParts1"))
        let robopart3 = SKSpriteNode(texture: partsAtlas.textureNamed("roboParts2"))
        let robopart4 = SKSpriteNode(texture: partsAtlas.textureNamed("roboParts2"))
        let robopart5 = SKSpriteNode(texture: partsAtlas.textureNamed("roboParts3"))
        let robopart6 = SKSpriteNode(texture: partsAtlas.textureNamed("roboParts3"))

        
        
        let roboParts : [SKSpriteNode] = [robopart1, robopart2, robopart3, robopart4, robopart5, robopart6]
        

        
        for part in roboParts {
            print("a")

            let randomNumInt1 = randomBetweenNumbers(0.4, secondNum: 5.0)
            let randomNumInt2 = randomBetweenNumbers(0.4, secondNum: 5.0)
            let randomNumInt3 = randomBetweenNumbers(0.0, secondNum: 0.01)



            self.addChild(part)
            part.zPosition = 1
            part.position = explodedPlayer.position
            part.physicsBody = SKPhysicsBody(rectangleOfSize: part.size)
            part.physicsBody?.applyAngularImpulse(0.04)
            part.physicsBody?.applyImpulse(CGVectorMake(randomNumInt1 , randomNumInt2))
            part.physicsBody?.categoryBitMask = explodePartsCategory
            part.physicsBody?.collisionBitMask = worldCategory
            part.physicsBody?.mass = 100
            part.physicsBody?.density = 100
            part.physicsBody?.friction = 100000
            
            // animaçao da bomba
            
            let outExplosion = SKSpriteNode(texture: partsAtlas.textureNamed("explosion0"))
            let midExplosion = SKSpriteNode(texture: partsAtlas.textureNamed("explosion1"))
            let inExplosion = SKSpriteNode(texture: partsAtlas.textureNamed("explosion2"))
            
            let explosionParts : [SKSpriteNode] = [outExplosion, midExplosion , inExplosion]
            
            for explosion in explosionParts{
            
                let tamFinal = explosion.size
                explosion.size = CGSize(width: explosion.size.width * 0.2, height: explosion.size.height * 0.2)
                explosion.position = CGPoint(x: explodedPlayer.position.x, y: explodedPlayer.position.y)
                
                let crescimento = SKAction.resizeToWidth(tamFinal.width * 2, height: tamFinal.height * 2, duration: 0.5)

                let rotacao = randomBetweenNumbers(0.01, secondNum: 5)
                explosion.physicsBody = SKPhysicsBody(rectangleOfSize: tamFinal)
                explosion.physicsBody?.categoryBitMask = 0x0
                explosion.physicsBody?.applyAngularImpulse(rotacao)
                explosion.physicsBody?.dynamic = false
                explosion.zPosition = 2
                self.addChild(explosion)

                explosion.runAction(crescimento, completion: { () -> Void in
                    explosion.removeFromParent()
                })
                
                
                

                
            }
        }

        
        
        self.playerRank.append(explodedPlayer.identifier)
        println(playerRank)
        //respawn bomb
        generateBomb(nil, bombTimer: 100)
        
    }
    
    override func messageReceived(identifier: String, dictionary: NSDictionary) {
        var x = dictionary.objectForKey("x") as! CGFloat
        var y = dictionary.objectForKey("y") as! CGFloat
        
        println("recebeu msg")

        if playerActive == identifier {
            throwBomb(x, y: y)
        }
        
    }
    
    func throwBomb(x:CGFloat, y:CGFloat) {
        if jointBombPlayer != nil {
            self.physicsWorld.removeJoint(jointBombPlayer!)

        }
        bomb.physicsBody?.applyImpulse(CGVectorMake(x * bombSpeedMultiplier, y * bombSpeedMultiplier))
        bomb.physicsBody?.applyAngularImpulse(0.1)
        playerActive = ""
        bombShouldTick = true
        if !fagulhando {
            animateFagulha()
        }

    }
    
    func generateBomb(grabbedBy : SKNode? , bombTimer : Double ){
        fagulhando = false
        
        bombShouldExplode = false
        var x : CGFloat?
        var y : CGFloat?
        
        if let initialNode = grabbedBy {
            x = initialNode.position.x
            y = initialNode.position.y
            
        }
        else {
            x = self.frame.size.width/2
            y = self.frame.size.height/2
        }
        
        
        let spriteAnimatedAtlas = SKTextureAtlas(named: "bombGame")//sprites
        
        let texture = spriteAnimatedAtlas.textureNamed("bombModel")
        
        
        bomb = SKSpriteNode(texture: texture, color: nil, size: CGSize(width: 50 , height: 50))
        bomb.position = CGPointMake(x!, y!)
        
        bomb.physicsBody = SKPhysicsBody(circleOfRadius: 41/2, center: CGPointMake(self.position.x, self.position.y - 2))
        bomb.physicsBody?.categoryBitMask = bombCategory
        bomb.physicsBody?.collisionBitMask = worldCategory
        bomb.physicsBody?.contactTestBitMask = playerCategory | worldCategory
        self.addChild(bomb)
        bomb.physicsBody?.mass = 1
        self.physicsBody?.dynamic = true
        
        var pavioAntigo = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 3, height: 5))
        pavioAntigo.physicsBody = SKPhysicsBody(rectangleOfSize: pavioAntigo.size)
        pavioAntigo.position = CGPointMake(CGRectGetMidX(bomb.frame), CGRectGetMaxY(bomb.frame)+2)
        pavioAntigo.physicsBody?.categoryBitMask = fireCategory
        pavioAntigo.physicsBody?.collisionBitMask = bombCategory
        var jointPavio = SKPhysicsJointPin.jointWithBodyA(bomb.physicsBody, bodyB: pavioAntigo.physicsBody, anchor: CGPointMake(CGRectGetMidX(bomb.frame), CGRectGetMaxY(bomb.frame)))

        self.addChild(pavioAntigo)
        pavioArray.append(pavioAntigo)
        
        bomb.zPosition = 10

        self.physicsWorld.addJoint(jointPavio)
        
        // teste cordinha louca
        
        for var index = 0; index < 7; ++index {
            let pavioNovo = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 3, height: 5))
            pavioNovo.position = CGPointMake(CGRectGetMidX(pavioAntigo.frame), CGRectGetMaxY(pavioAntigo.frame)+2)
            pavioNovo.physicsBody = SKPhysicsBody(circleOfRadius: 5/2)
            pavioNovo.physicsBody?.categoryBitMask = fireCategory
            pavioNovo.physicsBody?.collisionBitMask = bombCategory
            var jointPavios = SKPhysicsJointPin.jointWithBodyA(pavioAntigo.physicsBody, bodyB: pavioNovo.physicsBody, anchor: CGPointMake(CGRectGetMidX(pavioAntigo.frame), CGRectGetMaxY(pavioAntigo.frame)))
            self.addChild(pavioNovo)
            self.physicsWorld.addJoint(jointPavios)
            pavioNovo.zPosition = 6
            pavioAntigo = pavioNovo
            pavioArray.append(pavioNovo)
        }
        
        fagulha = FireBombSpark(fileNamed: "fireBombParticle")
        fagulha.physicsBody = SKPhysicsBody(circleOfRadius: 5/2)
        fagulha.physicsBody?.categoryBitMask = fireCategory
        fagulha.physicsBody?.collisionBitMask = bombCategory
        fagulha.position = CGPointMake(CGRectGetMidX(pavioAntigo.frame), CGRectGetMaxY(pavioAntigo.frame))
        self.addChild(fagulha)
        
        fagulhaJoint = SKPhysicsJointPin.jointWithBodyA(pavioAntigo.physicsBody, bodyB: fagulha.physicsBody, anchor: CGPointMake(CGRectGetMidX(pavioAntigo.frame), CGRectGetMaxY(pavioAntigo.frame)))
        self.physicsWorld.addJoint(fagulhaJoint)
        fagulha.zPosition = 2
        bomb.zPosition = 1
        
        var bombStartX = randomBetweenNumbers(-10, secondNum: 10)
        
        var bombStartY = randomBetweenNumbers(-10, secondNum: 10)
        
        var vet = CGVector(dx: bombStartX, dy: bombStartY)
        
        vet.normalize()
        
        throwBomb(vet.dx, y: vet.dy)
        
        

    }
    
    func animateFagulha() {

        fagulhando = true
        if pavioArray.count > 1 {
            let animation = SKAction.runBlock({() in
                var pavio = self.pavioArray.last
                pavio?.runAction(SKAction.removeFromParent())
                self.pavioArray.removeLast()
                pavio = self.pavioArray.last
                self.fagulha.position = pavio!.position
                self.fagulhaJoint = SKPhysicsJointPin.jointWithBodyA(pavio!.physicsBody, bodyB: self.fagulha.physicsBody, anchor: CGPointMake(CGRectGetMidX(pavio!.frame), CGRectGetMaxY(pavio!.frame)))
                self.physicsWorld.addJoint(self.fagulhaJoint)
                
            })
            
            let wait = SKAction.waitForDuration(0.5)
            let removeAndWait = SKAction.sequence([wait,animation,wait])
            self.runAction(removeAndWait, completion: {() in
                if self.bombShouldTick {
                    self.animateFagulha()
                } else {
                    self.fagulhando = false
                }
            })
            
        } else {
            bombShouldExplode = true
            
        }

    }
    
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }

    
    
    
    
}