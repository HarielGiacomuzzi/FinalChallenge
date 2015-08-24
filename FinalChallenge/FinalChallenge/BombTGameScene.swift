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
    
    
    let playerCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let bombCategory: UInt32 = 1 << 2
  //  let scoreCategory: UInt32 = 1 << 3
  //  let endScreenCategory: UInt32 = 1 << 4
  //  let powerUpCategory: UInt32 = 1 << 5
    
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
        self.addChild(wallWest)
        
        
        let WallEast = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 20, height: self.frame.size.height * 0.8))
        WallEast.position = CGPointMake((self.frame.size.width - (self.frame.size.width/2)/2.65) , (self.frame.size.height / 2))
        WallEast.physicsBody = SKPhysicsBody(rectangleOfSize: WallEast.size)
        WallEast.physicsBody?.dynamic = false
        self.addChild(WallEast)
        
        let wallNorth = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 20, height: self.frame.size.height * 0.8))
        wallNorth.position = CGPointMake(self.frame.size.width/2, self.frame.size.height-100)
        wallNorth.zRotation = 1.57079633
        wallNorth.physicsBody = SKPhysicsBody(rectangleOfSize: wallNorth.size)
        wallNorth.physicsBody?.dynamic = false
        self.addChild(wallNorth)
        
        let WallSouth = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 20, height: self.frame.size.height * 0.8))
        WallSouth.position = CGPointMake(self.frame.size.width/2, 100)
        WallSouth.zRotation = 1.57079633
        WallSouth.physicsBody = SKPhysicsBody(rectangleOfSize: WallSouth.size)
        WallSouth.physicsBody?.dynamic = false
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
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
        let bomb = SKSpriteNode(color: UIColor.purpleColor(), size: CGSize(width: 35, height: 35))
        bomb.position = CGPointMake(x!, y!)
        
        bomb.physicsBody = SKPhysicsBody(rectangleOfSize: bomb.size)
        self.addChild(bomb)
        bomb.physicsBody?.categoryBitMask = bombCategory
        bomb.physicsBody?.contactTestBitMask = playerCategory | worldCategory
        
        let bombSpark = SKSpriteNode(color: UIColor.yellowColor(), size: CGSize(width: 10, height: 10))
        bombSpark.position = CGPointMake(bomb.position.x + 10, bomb.position.y + 10)
        bombSpark.physicsBody = SKPhysicsBody(rectangleOfSize: bombSpark.size)
        bomb.addChild(bombSpark)
        
        
    }
        
        
    
    

}