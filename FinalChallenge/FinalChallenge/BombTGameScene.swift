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
        setupWalls()
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        let bomb = SKSpriteNode(color: UIColor.purpleColor(), size: CGSize(width: 35, height: 35))
        bomb.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        bomb.physicsBody = SKPhysicsBody(rectangleOfSize: bomb.size)
        self.addChild(bomb)
                bomb.physicsBody?.categoryBitMask = bombCategory
        bomb.physicsBody?.contactTestBitMask = playerCategory | worldCategory
        

        
    }
    
    func createPlayersAndObstacles() {
    
    }
    
    func setupWalls(){
        
        let wallWest = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 20, height: self.frame.size.height * 0.8))
        wallWest.position = CGPointMake((self.frame.size.width/2)/2.5, self.frame.size.height / 2)
        wallWest.physicsBody = SKPhysicsBody(rectangleOfSize: wallWest.size)
        wallWest.physicsBody?.dynamic = false
        self.addChild(wallWest)
        
        
        let WallEast = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 20, height: self.frame.size.height * 0.8))
        WallEast.position = CGPointMake((self.frame.size.width - (self.frame.size.width/2)/2.5) , (self.frame.size.height / 2))
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
        
    }
    
    func gameOver(){
        //gameController = self.view?.window?.rootViewController as! FlappyGameViewController
        //gameController!.GameOverView.alpha = 1;
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        //checks colision player / powerup
        
    }
    
    func handleColisionPlayerPowerup(#player:SKPhysicsBody,powerup:SKPhysicsBody) {
    
    }
    
}