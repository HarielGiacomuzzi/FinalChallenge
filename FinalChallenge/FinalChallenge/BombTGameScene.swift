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
    
    // limits of game area
    var maxX:CGFloat = 0.0
    var minX:CGFloat = 0.0
    var maxY:CGFloat = 0.0
    var minY:CGFloat = 0.0
    
    var jointBombPlayer:SKPhysicsJoint?
    

    var testPlayer:BombPlayerNode?
    var playersRank:[BombPlayerNode] = []
    
    var playerWithBomb:BombPlayerNode?
    
    var bomb:SKSpriteNode!
    
    let playerCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let bombCategory: UInt32 = 1 << 2
    let fireCategory: UInt32 = 1 << 3
    
    var beginX:CGFloat = 0.0
    var beginY:CGFloat = 0.0
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if jointBombPlayer != nil {
            self.physicsWorld.removeJoint(jointBombPlayer!)
        }
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
        
        throwBomb(x, y: y)
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
        
        //MUST SETUP WALLS BEFORE PLAYERS
        setupWalls()
        spawnSinglePlayer()
        createPlayersAndObstacles()
        generateBomb(nil, bombTimer: 100)
        
    }
    
    func createPlayersAndObstacles() {

        // cria jogadores
        
        
    
    }
    
    func setupWalls(){
        //north wall
        var size = CGSize(width: self.frame.size.height, height: 30)
        var north = BombWallNode(size: size)
        north.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height - 15)
        self.addChild(north)
        walls.append(north)
        maxY = north.position.y - north.size.height / 2
        north.hasPlayer = true
        
        //south wall
        size = CGSize(width: self.frame.size.height, height: 30)
        var south = BombWallNode(size: size)
        south.position = CGPointMake(self.frame.size.width / 2, 15)
        self.addChild(south)
        walls.append(south)
        minY = south.position.y + south.size.height / 2
        south.hasPlayer = true
        
        //east wall
        size = CGSize(width: 30, height: self.frame.size.height)
        var east = BombWallNode(size: size)
        east.position = CGPointMake(north.position.x + north.size.width / 2, self.frame.size.height / 2)
        self.addChild(east)
        walls.append(east)
        maxX = east.position.x - east.size.width / 2
        east.hasPlayer = true
        
        //west wall
        size = CGSize(width: 30, height: self.frame.size.height)
        var west = BombWallNode(size: size)
        west.position = CGPointMake(north.position.x - north.size.width / 2, self.frame.size.height / 2)
        self.addChild(west)
        walls.append(west)
        minX = west.position.x + west.size.width / 2
        west.hasPlayer = true
        
        
    }
    
    func spawnPlayers() {
        let connectedPeers = ConnectionManager.sharedInstance.session.connectedPeers
        
        for connectedPeer in connectedPeers {
        }
    }
    
    func spawnSinglePlayer() {
        // criar a bomba
        
        var topRight = CGPointMake(maxX - 30, maxY - 30)
        var topLeft = CGPointMake(minX + 30, maxY - 30)
        var botRight = CGPointMake(maxX - 30, minY + 30)
        var botLeft = CGPointMake(minX + 30, minY + 30)
//        // spawn um player no sul
        var north = BombPlayerNode()
        north.position = topLeft
        let northMovement = SKAction.sequence([SKAction.moveTo(topRight, duration: 3.5),SKAction.moveTo(topLeft, duration: 3.5)])
        north.runAction(SKAction.repeatActionForever(northMovement))
        self.addChild(north)
        players.append(north)
        
        
        var south = BombPlayerNode()
        south.position = botRight
        let southMovement = SKAction.sequence([SKAction.moveTo(botLeft, duration: 3.5),SKAction.moveTo(botRight, duration: 3.5)])
        south.runAction(SKAction.repeatActionForever(southMovement))
        self.addChild(south)
        players.append(south)
        
        var east = BombPlayerNode()
        east.position = topRight
        let eastMovement = SKAction.sequence([SKAction.moveTo(botRight, duration: 3.5),SKAction.moveTo(topRight, duration: 3.5)])
        east.runAction(SKAction.repeatActionForever(eastMovement))
        self.addChild(east)
        players.append(east)
        
        var west = BombPlayerNode()
        west.position = botLeft
        let westMovement = SKAction.sequence([SKAction.moveTo(topLeft, duration: 3.5),SKAction.moveTo(botLeft, duration: 3.5)])
        west.runAction(SKAction.repeatActionForever(westMovement))
        self.addChild(west)
        players.append(west)
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
        if playerWithBomb != playerNode {
            jointBombPlayer = SKPhysicsJointFixed.jointWithBodyA(bomb, bodyB: player, anchor: playerNode.position)
            self.physicsWorld.addJoint(jointBombPlayer!)
            playerWithBomb = playerNode
        }
        
    }
    
    func handleBombWallContact(bomb:SKPhysicsBody, wall:SKPhysicsBody) {
        let wallNode = wall.node as! BombWallNode
        if wallNode.hasPlayer {
            bomb.velocity = CGVectorMake(0.0, 0.0)
        } else {
            playerWithBomb = nil
        }

    }
    
    override func messageReceived(identifier: String, dictionary: NSDictionary) {
        var x = dictionary.objectForKey("x") as! CGFloat
        var y = dictionary.objectForKey("y") as! CGFloat
        throwBomb(x, y: y)
        
    }
    
    func throwBomb(x:CGFloat, y:CGFloat) {
        bomb.physicsBody?.applyImpulse(CGVectorMake(x * 1, y * 1))
    }
    
    func generateBomb(grabbedBy : SKNode? , bombTimer : Double ){
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
        
        var pavioArray:[SKSpriteNode] = []
        var jointArray:[SKPhysicsJoint] = []
        
        var pavioAntigo = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 3, height: 5))
        pavioAntigo.physicsBody = SKPhysicsBody(rectangleOfSize: pavioAntigo.size)
        pavioAntigo.position = CGPointMake(CGRectGetMidX(bomb.frame), CGRectGetMaxY(bomb.frame)+2)
        pavioAntigo.physicsBody?.categoryBitMask = fireCategory
        pavioAntigo.physicsBody?.collisionBitMask = playerCategory | bombCategory
        var jointPavio = SKPhysicsJointPin.jointWithBodyA(bomb.physicsBody, bodyB: pavioAntigo.physicsBody, anchor: CGPointMake(CGRectGetMidX(bomb.frame), CGRectGetMaxY(bomb.frame)))
        jointArray.append(jointPavio)
        
        self.addChild(pavioAntigo)
        pavioArray.append(pavioAntigo)
        
        
        self.physicsWorld.addJoint(jointPavio)
        
        // teste cordinha louca
        
        for var index = 0; index < 7; ++index {
            let pavioNovo = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 3, height: 5))
            pavioNovo.position = CGPointMake(CGRectGetMidX(pavioAntigo.frame), CGRectGetMaxY(pavioAntigo.frame)+2)
            pavioNovo.physicsBody = SKPhysicsBody(circleOfRadius: 5/2)
            pavioNovo.physicsBody?.categoryBitMask = fireCategory
            pavioNovo.physicsBody?.collisionBitMask = playerCategory | bombCategory
            var jointPavios = SKPhysicsJointPin.jointWithBodyA(pavioAntigo.physicsBody, bodyB: pavioNovo.physicsBody, anchor: CGPointMake(CGRectGetMidX(pavioAntigo.frame), CGRectGetMaxY(pavioAntigo.frame)))
            self.addChild(pavioNovo)
            self.physicsWorld.addJoint(jointPavios)
            jointArray.append(jointPavios)
            pavioNovo.zPosition = 0
            pavioAntigo = pavioNovo
            pavioArray.append(pavioNovo)
        }
        
        let fagulha = FireBombSpark(fileNamed: "fireBombParticle")
        fagulha.physicsBody = SKPhysicsBody(circleOfRadius: 5/2)
        fagulha.physicsBody?.categoryBitMask = fireCategory
        fagulha.physicsBody?.collisionBitMask = playerCategory | bombCategory
        fagulha.position = CGPointMake(CGRectGetMidX(pavioAntigo.frame), CGRectGetMaxY(pavioAntigo.frame))
        self.addChild(fagulha)
        
        var fagulhaJoint = SKPhysicsJointPin.jointWithBodyA(pavioAntigo.physicsBody, bodyB: fagulha.physicsBody, anchor: CGPointMake(CGRectGetMidX(pavioAntigo.frame), CGRectGetMaxY(pavioAntigo.frame)))
        self.physicsWorld.addJoint(fagulhaJoint)
        fagulha.zPosition = 2
        bomb.zPosition = 1
        let animation = SKAction.runBlock({() in
            var joint = jointArray.last
            var pavio = pavioArray.last
            pavio?.runAction(SKAction.removeFromParent())
            pavioArray.removeLast()
            pavio = pavioArray.last
            fagulha.position = pavio!.position
            fagulhaJoint = SKPhysicsJointPin.jointWithBodyA(pavio!.physicsBody, bodyB: fagulha.physicsBody, anchor: CGPointMake(CGRectGetMidX(pavio!.frame), CGRectGetMaxY(pavio!.frame)))
            self.physicsWorld.addJoint(fagulhaJoint)
            
        })
        
        let wait = SKAction.waitForDuration(1)
        let removeAndWait = SKAction.sequence([animation,wait])
//        self.runAction(SKAction.repeatActionForever(removeAndWait))


    }
    
}