//
//  RopeScene.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 11/12/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//


import SpriteKit
import CoreMotion

class RopeScene : MinigameScene, SKPhysicsContactDelegate{
    
    let playerCategory : UInt32 = 1 << 0
    let worldCategory : UInt32 = 1 << 1
    
    var player : [RopeGamePlayer] = []
    var singlePlayer : RopeGamePlayer?
    var goingRight = false
    var goingLeft = false
    var stopRotation = false
    var cont = 1
    
    var rank = [String()]
    var winner = String()
    var losers = [String()]
    
    lazy var motionManager : CMMotionManager = {
        let motion = CMMotionManager()
        motion.accelerometerUpdateInterval = 1/10
        return motion
        }()
    override func didMoveToView(view: SKView) {
    
        super.didMoveToView(view)
        
        self.physicsWorld.gravity = CGVectorMake(0.0, -250.0)
        self.physicsWorld.contactDelegate = self
        
        AudioSource.sharedInstance.ropeGameSound()
        
        if motionManager.accelerometerAvailable{
            let queue = NSOperationQueue()
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler:
                {data, error in
                    
                    if let _ = data{
                        
                    }
                    else{
                        return
                    }
                    if !self.stopRotation {
                        self.moveCharacter(data!.acceleration.y)
                    }
                }
            )
        } else {
            //print("Accelerometer is not available", terminator: "")
        }
        self.setScenerio()
    }

    func setScenerio(){
        
        let ground = SKNode()
        ground.position = CGPointMake(self.frame.size.width / 2, -100)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, self.frame.size.height * 0.01))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = worldCategory
        ground.physicsBody?.contactTestBitMask = playerCategory
        ground.physicsBody?.collisionBitMask = playerCategory
        self.addChild(ground)
        
        let sky = SKSpriteNode(imageNamed: "ropesky")
        sky.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        sky.zPosition = 1
        sky.size.height = self.frame.size.height
        self.addChild(sky)
        
        let skyline1 = SKSpriteNode(imageNamed: "ropeskyline1")
        skyline1.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2+skyline1.frame.height/3)
        skyline1.zPosition = 2
        self.addChild(skyline1)
        
        let skyline2 = SKSpriteNode(imageNamed: "ropeskyline2")
        skyline2.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2+skyline2.frame.height/3)
        skyline2.zPosition = 3
        self.addChild(skyline2)
        
        let base = SKSpriteNode(imageNamed: "ropebase")
        base.position = CGPoint(x: self.frame.width/2, y: base.frame.height/2)
        base.zPosition = 4
        self.addChild(base)
        
        if !GameManager.sharedInstance.isMultiplayer {
            self.timerForSinglePlayer()
            singlePlayer = RopeGamePlayer()
            singlePlayer?.position = CGPoint(x: self.frame.width/2, y: self.frame.height/3)
            singlePlayer?.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            singlePlayer?.zPosition = 5
            singlePlayer?.setScale(0.6)
            self.addChild(singlePlayer!)
        } else {
            self.spawnPlayer()
        }
    }
    
    func spawnPlayer(){
        let cats = GameManager.sharedInstance.players
        var c = 0
        let playersNode = SKNode()
        for cat in cats{
            let p = RopeGamePlayer()
            p.identifier = cat.playerIdentifier
            p.color = cat.color
            p.zPosition = 5
            let offsetFraction = (CGFloat(c) + 1.5)/(CGFloat(cats.count) + 1.0)
            p.position = CGPoint(x: 0 + offsetFraction, y: 0)
            p.setScale(0.5)
            playersNode.addChild(p)
            //self.addChild(p)
            player.append(p)
            c++
        }
        playersNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.addChild(playersNode)
    }
    
    func moveCharacter(y:Double){
        if y > 0{
           // print(y)
            singlePlayer?.zRotation += -CGFloat(0.1)
            goingRight = true
            goingLeft = false
            
        }else if y < 0{
            //print(y)
            singlePlayer?.zRotation -= -(CGFloat(0.1))
            goingRight = false
            goingLeft = true
        }else{
            goingLeft = false
            goingRight = false
        }
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        if GameManager.sharedInstance.isMultiplayer{
            for p in player{
                if p.zRotation > 0.9{
                    p.activePhysicsBody()
                    player.removeObject(p)
                    p.stopRotation = true
                }
                if p.zRotation < -0.9{
                    p.activePhysicsBody()
                    player.removeObject(p)
                    p.stopRotation = true
                }
            }
            if player.count == 1 {
                //endgame
                winner = player[0].identifier!
            }
        } else{//singleplayer game
            if(singlePlayer?.zRotation > 0.9){
                //player cai
                //print("player caiu")
                //singlePlayer?.removeFromParent()
                singlePlayer?.activePhysicsBody()
                self.stopRotation = true
            }
            if(singlePlayer?.zRotation < -0.9){
                //player cai
                //print("player caiu")
                //singlePlayer?.removeFromParent()
                singlePlayer?.activePhysicsBody()
                self.stopRotation = true
            }
            if !stopRotation{
                if !goingLeft{
                    singlePlayer?.zRotation -= CGFloat(0.01)
                }
                if !goingRight{
                    singlePlayer?.zRotation += CGFloat(0.01)
                }
            }
        }
        
        
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
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == worldCategory {
            if !GameManager.sharedInstance.isMultiplayer{
                singlePlayer?.removeFromParent()
            } else{
                self.handlePlayerDeath(contact.bodyA, wallBody: contact.bodyB)
            }
        } else if contact.bodyB.categoryBitMask == playerCategory && contact.bodyA.categoryBitMask == worldCategory{
            if !GameManager.sharedInstance.isMultiplayer{
                singlePlayer?.removeFromParent()
            } else{
                self.handlePlayerDeath(contact.bodyB, wallBody: contact.bodyA)
            }
        }
    }
    
    func handlePlayerDeath(playerBody:SKPhysicsBody, wallBody:SKPhysicsBody){
        for p in player{
            if p.physicsBody == playerBody{
                p.removeFromParent()
                losers.append(p.identifier!)
            }
        }
    }
    
    func singlePlayerEndGame(){
        self.paused = true
        self.gameOverSP("rope", winner: "", score: cont)
    }
    
    func multiPlayerEndGame(){
        rank.append(winner)
        losers = Array(losers.reverse())
        for loser in losers{
            rank.append(loser)
        }
        self.removeAllChildren()
        self.removeAllActions()
        SKTransition.flipHorizontalWithDuration(0.5)
        let goScene = GameOverSceneMP(size: self.size)
        goScene.players = rank
        goScene.scaleMode = self.scaleMode
        self.view?.presentScene(goScene)
    }
    
    
    override func messageReceived(identifier: String, dictionary: NSDictionary) {
        for p in player {
            if p.identifier == identifier {
                let message = dictionary["way"] as! String
                let messageEnum = PlayerAction(rawValue: message)
                if messageEnum == .Up {
                    p.goRight()
                } else {
                    p.goLeft()
                }
            }
        }
    }
}