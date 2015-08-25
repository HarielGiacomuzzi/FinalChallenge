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
    
    
    enum Position {
        case North
        case South
        case East
        case West
        case Undefined
    }
    
    var jointBombPlayer:SKPhysicsJoint?
    
    var players:[BombPlayerNode] = []
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
        setupWalls()
        createPlayersAndObstacles()
        spawnSinglePlayer()
        generateBomb(nil, bombTimer: 100)
        
    }
    
    func createPlayersAndObstacles() {

        // cria jogadores
        
        
    
    }
    
    func setupWalls(){
        
        let wall = BombWallNode(pos: .North, frame: self.frame)
        self.addChild(wall)
        wall.hasPlayer = true
        let wall2 = BombWallNode(pos: .South, frame: self.frame)
        wall2.hasPlayer = true
        self.addChild(wall2)
        let wall3 = BombWallNode(pos: .East, frame: self.frame)
        wall3.hasPlayer = true
        self.addChild(wall3)
        let wall4 = BombWallNode(pos: .West, frame: self.frame)
        wall4.hasPlayer = true
        self.addChild(wall4)
        
    }
    
    func spawnPlayers() {
        let connectedPeers = ConnectionManager.sharedInstance.session.connectedPeers
        
        for connectedPeer in connectedPeers {
        }
    }
    
    func spawnSinglePlayer() {
        // criar a bomba
        
        // spawn um player no sul
        testPlayer = BombPlayerNode(pos: .South, frame: self.frame)

        self.addChild(testPlayer!)
        let player2 = BombPlayerNode(pos: .North, frame: self.frame)
        self.addChild(player2)
        let player3 = BombPlayerNode(pos: .East, frame: self.frame)
        self.addChild(player3)
        let player4 = BombPlayerNode(pos: .West, frame: self.frame)
        self.addChild(player4)
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
        bomb = SKSpriteNode(color: UIColor.purpleColor(), size: CGSize(width: 40, height: 45))
        bomb.position = CGPointMake(x!, y!)
        
        bomb.physicsBody = SKPhysicsBody(circleOfRadius: 41/2, center: CGPointMake(self.position.x, self.position.y - 2))
        bomb.physicsBody?.categoryBitMask = bombCategory
        bomb.physicsBody?.collisionBitMask = worldCategory
        bomb.physicsBody?.contactTestBitMask = playerCategory | worldCategory
        self.addChild(bomb)
        bomb.physicsBody?.mass = 1
        
        //SKPhysicsBody(rectangleOfSize: CGSize(width: self.size.width * 0.65, height: self.size.height*0.4), center: CGPoint(x: self.position.x+7, y: self.position.y)   )
        self.physicsBody?.dynamic = true
        
        var pavioAntigo = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 3, height: 5))
        pavioAntigo.physicsBody = SKPhysicsBody(rectangleOfSize: pavioAntigo.size)
        pavioAntigo.position = CGPointMake(CGRectGetMidX(bomb.frame), CGRectGetMaxY(bomb.frame)+2)
        pavioAntigo.physicsBody?.categoryBitMask = fireCategory
        pavioAntigo.physicsBody?.collisionBitMask = fireCategory
        var jointPavio = SKPhysicsJointPin.jointWithBodyA(bomb.physicsBody, bodyB: pavioAntigo.physicsBody, anchor: CGPointMake(CGRectGetMidX(bomb.frame), CGRectGetMaxY(bomb.frame)))
        
        self.addChild(pavioAntigo)
        
        
        self.physicsWorld.addJoint(jointPavio)
        
        // teste cordinha louca
        
        for var index = 0; index < 7; ++index {
            let pavioNovo = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 3, height: 5))
            pavioNovo.position = CGPointMake(CGRectGetMidX(pavioAntigo.frame), CGRectGetMaxY(pavioAntigo.frame)+2)
            pavioNovo.physicsBody = SKPhysicsBody(circleOfRadius: 5/2)
            pavioNovo.physicsBody?.categoryBitMask = fireCategory
            pavioNovo.physicsBody?.collisionBitMask = fireCategory
            var jointPavios = SKPhysicsJointPin.jointWithBodyA(pavioAntigo.physicsBody, bodyB: pavioNovo.physicsBody, anchor: CGPointMake(CGRectGetMidX(pavioAntigo.frame), CGRectGetMaxY(pavioAntigo.frame)))
            self.addChild(pavioNovo)
            self.physicsWorld.addJoint(jointPavios)
            
            pavioNovo.zPosition = 0
            pavioAntigo = pavioNovo
        }
        let fagulha = FireBombSpark(fileNamed: "fireBombParticle")
        fagulha.physicsBody = SKPhysicsBody(circleOfRadius: 5/2)
        fagulha.physicsBody?.categoryBitMask = fireCategory
        fagulha.physicsBody?.collisionBitMask = fireCategory
        fagulha.position = CGPointMake(CGRectGetMidX(pavioAntigo.frame), CGRectGetMaxY(pavioAntigo.frame))
        self.addChild(fagulha)
        
        let fagulhaJoint = SKPhysicsJointPin.jointWithBodyA(pavioAntigo.physicsBody, bodyB: fagulha.physicsBody, anchor: CGPointMake(CGRectGetMidX(pavioAntigo.frame), CGRectGetMaxY(pavioAntigo.frame)))
        self.physicsWorld.addJoint(fagulhaJoint)
        fagulha.zPosition = 2
        bomb.zPosition = 1
    }
    
}