//
//  RopeScene.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 11/12/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//


import SpriteKit
import CoreMotion

class RopeScene : MinigameScene{
    
    var player : [RopeGamePlayer] = []
    var singlePlayer : RopeGamePlayer?
    
    lazy var motionManager : CMMotionManager = {
        let motion = CMMotionManager()
        motion.accelerometerUpdateInterval = 1.0/5.0
        return motion
        }()
    override func didMoveToView(view: SKView) {
        
        super.didMoveToView(view)
        
        if motionManager.accelerometerAvailable{
            let queue = NSOperationQueue()
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler:
                {data, error in
                    
                    if let _ = data{
                        
                    }
                    else{
                        return
                    }
                    self.moveCharacter(data!.acceleration.y)
                }
            )
        } else {
            //print("Accelerometer is not available", terminator: "")
        }
        self.setScenerio()
    }
    
    func setScenerio(){
        print("RopeGame")
        
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
        
        singlePlayer = RopeGamePlayer(imageNamed: "ropegatow")
        singlePlayer?.position = CGPoint(x: self.frame.width/2, y: self.frame.height/3)
        singlePlayer?.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        singlePlayer?.zPosition = 5
        singlePlayer?.setScale(0.6)
        self.addChild(singlePlayer!)
    }
    
    func moveCharacter(y:Double){
        if y > 0{
            singlePlayer?.zRotation = -CGFloat(y)
            print(singlePlayer?.zRotation)
        }else if y < 0{
            singlePlayer?.zRotation = -(CGFloat(y))
            print(singlePlayer?.zRotation)
        }
        
        if(singlePlayer?.zRotation > 0.5){
            //player cai
        }
        if(singlePlayer?.zRotation < -0.5){
            //player cai
        }
        
    }
    
    
    override func messageReceived(identifier: String, dictionary: NSDictionary) {
        
    }
}