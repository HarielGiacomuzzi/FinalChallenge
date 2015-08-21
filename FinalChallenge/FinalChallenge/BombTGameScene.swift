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
        self.gameOver()

        
    }
    
    override func didMoveToView(view: SKView) {
        startGame()
        
    }
    
    func startGame() {
        let parede = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 20, height: self.frame.size.height * 0.8))
        parede.position = CGPointMake(0, self.frame.size.height / 2)
        self.addChild(parede)
        
        let parede2 = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 20, height: self.frame.size.height * 0.8))
        parede2.position = CGPointMake(self.frame.size.width , (self.frame.size.height / 2))
        self.addChild(parede2)

        let parede3 = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 20, height: self.frame.size.height * 0.8))
        parede3.zRotation = 1.57079633
        parede3.position = CGPointMake(0, 0)
        self.addChild(parede3)

        
    }
    
    func createPlayersAndObstacles() {
    
    }
    
    func setupWalls(){
        
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