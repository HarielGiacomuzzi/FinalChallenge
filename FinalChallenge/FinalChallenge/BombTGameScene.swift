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
    
    var players:[BombPlayerNode] = []
    var testPlayer:BombPlayerNode?
    var playersRank:[BombPlayerNode] = []
    
    var playerWithBomb:BombPlayerNode?
    
    var bomb:SKSpriteNode!
    
    let playerCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let bombCategory: UInt32 = 1 << 2
    
    var beginX:CGFloat = 0.0
    var beginY:CGFloat = 0.0
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if bomb.parent == nil {
            generateBomb(testPlayer, bombTimer: 0.0)
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
        let wall2 = BombWallNode(pos: .South, frame: self.frame)
        wall2.hasPlayer = true
        self.addChild(wall2)
        let wall3 = BombWallNode(pos: .East, frame: self.frame)
        self.addChild(wall3)
        let wall4 = BombWallNode(pos: .West, frame: self.frame)
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
        testPlayer = BombPlayerNode()
        testPlayer!.setupPhysics()
        testPlayer!.setupMovement(self.frame)
        self.addChild(testPlayer!)

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
                    println("contato")
        } else if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == bombCategory) {
            handlePlayerBombContact(contact.bodyB, player: contact.bodyA)
                    println("contato")
        }
        

   
    }
    
    func handlePlayerBombContact(bomb:SKPhysicsBody, player:SKPhysicsBody) {
        let playerNode = player.node as! BombPlayerNode
//        playerWithBomb = playerNode
        if playerWithBomb != playerNode {
            bomb.node!.runAction(SKAction.removeFromParent())
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
        bomb.physicsBody?.applyImpulse(CGVectorMake(x * 0.1, y * 0.1))
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
        bomb = SKSpriteNode(color: UIColor.purpleColor(), size: CGSize(width: 35, height: 35))
        bomb.position = CGPointMake(x!, y!)
        
        bomb.physicsBody = SKPhysicsBody(rectangleOfSize: bomb.size)
        bomb.physicsBody?.categoryBitMask = bombCategory
        bomb.physicsBody?.collisionBitMask = worldCategory
        bomb.physicsBody?.contactTestBitMask = playerCategory | worldCategory
        self.addChild(bomb)
        
        let bombSpark = SKSpriteNode(color: UIColor.yellowColor(), size: CGSize(width: 10, height: 10))
        bombSpark.position = CGPointMake(bomb.position.x + 30, bomb.position.y + 30)

        self.addChild(bombSpark)
        bombSpark.physicsBody = SKPhysicsBody(rectangleOfSize: bombSpark.size)
        bombSpark.physicsBody?.dynamic = true
        bombSpark.physicsBody?.mass = 0.0001
        
        let jointTeste = SKPhysicsJointLimit.jointWithBodyA(bomb.physicsBody, bodyB: bombSpark.physicsBody, anchorA: bomb.position, anchorB: bombSpark.position)
        self.physicsWorld.addJoint(jointTeste)
        
        
        
    }
        
        
    
    

}