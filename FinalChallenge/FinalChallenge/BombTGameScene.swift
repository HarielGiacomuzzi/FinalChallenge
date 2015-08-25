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
    
    var players:[FlappyPlayerNode] = []
    var testPlayer:FlappyPlayerNode?
    var playersRank:[FlappyPlayerNode] = []
    
    var bomb:SKSpriteNode!
    
    let playerCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let bombCategory: UInt32 = 1 << 2
  //  let scoreCategory: UInt32 = 1 << 3
  //  let endScreenCategory: UInt32 = 1 << 4
  //  let powerUpCategory: UInt32 = 1 << 5
    
    
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
        setupWalls()
        createPlayersAndObstacles()
        spawnSinglePlayer()
        generateBomb(nil, bombTimer: 100)
        
    }
    
    func createPlayersAndObstacles() {

        // cria jogadores
        
        
    
    }
    
    func setupWalls(){
        
        let wallWest = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 20, height: self.frame.size.height * 0.8))
        wallWest.position = CGPointMake((self.frame.size.width/2)/2.65, self.frame.size.height / 2)
        wallWest.physicsBody = SKPhysicsBody(rectangleOfSize: wallWest.size)
        wallWest.physicsBody?.dynamic = false
        wallWest.physicsBody?.categoryBitMask = worldCategory
        self.addChild(wallWest)
        
        let WallEast = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 20, height: self.frame.size.height * 0.8))
        WallEast.position = CGPointMake((self.frame.size.width - (self.frame.size.width/2)/2.65) , (self.frame.size.height / 2))
        WallEast.physicsBody = SKPhysicsBody(rectangleOfSize: WallEast.size)
        WallEast.physicsBody?.dynamic = false
        WallEast.physicsBody?.categoryBitMask = worldCategory
        WallEast.physicsBody?.contactTestBitMask = bombCategory
        self.addChild(WallEast)
        
        let wallNorth = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 20, height: self.frame.size.height * 0.8))
        wallNorth.position = CGPointMake(self.frame.size.width/2, self.frame.size.height-100)
        wallNorth.zRotation = 1.57079633
        wallNorth.physicsBody = SKPhysicsBody(rectangleOfSize: wallNorth.size)
        wallNorth.physicsBody?.dynamic = false
        wallNorth.physicsBody?.categoryBitMask = worldCategory
        self.addChild(wallNorth)
        
        let WallSouth = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 20, height: self.frame.size.height * 0.8))
        WallSouth.position = CGPointMake(self.frame.size.width/2, 100)
        WallSouth.zRotation = 1.57079633
        WallSouth.physicsBody = SKPhysicsBody(rectangleOfSize: WallSouth.size)
        WallSouth.physicsBody?.dynamic = false
        WallSouth.physicsBody?.categoryBitMask = worldCategory
        self.addChild(WallSouth)
    }
    
    func spawnPlayers() {
        let connectedPeers = ConnectionManager.sharedInstance.session.connectedPeers
        
        for connectedPeer in connectedPeers {
        }
    }
    
    func spawnSinglePlayer() {
        // criar a bomba

        
        // spawn um player no sul
        let player = SKSpriteNode (color: UIColor.blueColor(), size: CGSize(width: 55   , height: 60))
        player.position = CGPointMake(self.frame.size.width/2 - self.frame.size.width/3.5, 140)
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.dynamic = false
        player.physicsBody?.categoryBitMask = playerCategory
        self.addChild(player)
        
        let playerMovementDir = SKAction.moveTo(CGPointMake(self.frame.size.width/2 + self.frame.size.width/3.5, player.position.y), duration: 3.5)
        let playerMovementEsq = SKAction.moveTo(CGPointMake(self.frame.size.width/2 - self.frame.size.width/3.5, player.position.y), duration: 3.5)
        player.runAction(SKAction.repeatActionForever(SKAction.sequence([playerMovementDir, playerMovementEsq])))
        
    }
    
    func gameOver(){
        //gameController = self.view?.window?.rootViewController as! FlappyGameViewController
        //gameController!.GameOverView.alpha = 1;
        
    }
    
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        println("contato")
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        // acerta qual corpo é qual
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        // verifica se a colisao eh entre monstro e projetil e entao chama a colisao
        if ((firstBody.categoryBitMask & playerCategory != 0) &&
            (secondBody.categoryBitMask & bombCategory != 0)){
                
                
        }
        
        if (firstBody.categoryBitMask == bombCategory && secondBody.categoryBitMask == worldCategory) {
            handleBombWallContact(firstBody)
        } else if (firstBody.categoryBitMask == worldCategory && secondBody.categoryBitMask == worldCategory) {
            handleBombWallContact(secondBody)
        }
   
    }
    
    func handleBombWallContact(bomb:SKPhysicsBody) {
        bomb.velocity = CGVectorMake(0.0, 0.0)
    }
    
     func messageReceived(identifier: String, dictionary: NSDictionary) {
        var x = dictionary.objectForKey("x") as! CGFloat
        var y = dictionary.objectForKey("y") as! CGFloat
        throwBomb(x, y: y)
        
    }
    
    func throwBomb(x:CGFloat, y:CGFloat) {
        bomb.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
        bomb.physicsBody?.applyImpulse(CGVectorMake(x, y))
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
        
        var jointPavio = SKPhysicsJointPin.jointWithBodyA(bomb.physicsBody, bodyB: pavioAntigo.physicsBody, anchor: CGPointMake(CGRectGetMidX(bomb.frame), CGRectGetMaxY(bomb.frame)))
        
        self.addChild(pavioAntigo)

        
        self.physicsWorld.addJoint(jointPavio)
        
        // teste cordinha louca
        
        for var index = 0; index < 7; ++index {
            let pavioNovo = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 3, height: 5))
            pavioNovo.position = CGPointMake(CGRectGetMidX(pavioAntigo.frame), CGRectGetMaxY(pavioAntigo.frame)+2)
            pavioNovo.physicsBody = SKPhysicsBody(circleOfRadius: 5/2)
            var jointPavios = SKPhysicsJointPin.jointWithBodyA(pavioAntigo.physicsBody, bodyB: pavioNovo.physicsBody, anchor: CGPointMake(CGRectGetMidX(pavioAntigo.frame), CGRectGetMaxY(pavioAntigo.frame)))
            self.addChild(pavioNovo)
            self.physicsWorld.addJoint(jointPavios)

            pavioNovo.zPosition = 0
            pavioAntigo = pavioNovo
        }
        let fagulha = FireBombSpark(fileNamed: "fireBombParticle")
        fagulha.physicsBody = SKPhysicsBody(circleOfRadius: 5/2)
        fagulha.position = CGPointMake(CGRectGetMidX(pavioAntigo.frame), CGRectGetMaxY(pavioAntigo.frame))
        self.addChild(fagulha)
        
        let fagulhaJoint = SKPhysicsJointPin.jointWithBodyA(pavioAntigo.physicsBody, bodyB: fagulha.physicsBody, anchor: CGPointMake(CGRectGetMidX(pavioAntigo.frame), CGRectGetMaxY(pavioAntigo.frame)))
        self.physicsWorld.addJoint(fagulhaJoint)
        fagulha.zPosition = 2
        bomb.zPosition = 1
    }
        
        
    
    

}