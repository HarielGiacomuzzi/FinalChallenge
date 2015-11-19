//
//  AccelerometerScene.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 10/1/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion


//flappy fish
class AccelerometerScene: GamePadScene {
    
    var playerBarColor : SKSpriteNode?
    var directionNeedle : SKSpriteNode?
    var background : SKSpriteNode?
    var rightReference : SKSpriteNode?
    var leftReference : SKSpriteNode?
    var visor : SKSpriteNode?
    
    lazy var motionManager : CMMotionManager = {
        let motion = CMMotionManager()
        motion.accelerometerUpdateInterval = 1.0/5.0
        return motion
    }()
    
    lazy var sendMoreInfo : CMMotionManager = {
        let motion = CMMotionManager()
        motion.accelerometerUpdateInterval = 0.07
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
                    self.sendData(data!.acceleration.y)
                }
            )
        } else {
            //print("Accelerometer is not available", terminator: "")
        }
        
        if sendMoreInfo.accelerometerAvailable{
            let queue = NSOperationQueue()
            sendMoreInfo.startAccelerometerUpdatesToQueue(queue, withHandler:
                {data, error in
                    
                    if let _ = data{
                        
                    }
                    else{
                        return
                    }
                    self.moveNeedle(data!.acceleration.y)
                }
            )
        } else {
            //print("Accelerometer is not available", terminator: "")
        }
        
        self.setSceneObjects()
    }
    
    func sendData(y:Double) {
        
        if y > 0{
            let action = ["way":PlayerAction.Down.rawValue]
            let dic = ["controllerAction":"", "action":action]
            ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        }else if y < 0{
            let action = ["way":PlayerAction.Up.rawValue]
            let dic = ["controllerAction":"", "action":action]
            ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        }
    }
    
    func moveNeedle(y:Double){
        if y > 0{
            directionNeedle?.zRotation = -CGFloat(y)
            rightReference?.colorBlendFactor = 0
            
            leftReference?.color = UIColor.redColor()
            leftReference?.colorBlendFactor = 1
        }else if y < 0{
            directionNeedle?.zRotation = -(CGFloat(y))
            rightReference?.color = UIColor.redColor()
            rightReference?.colorBlendFactor = 1
            
            leftReference?.colorBlendFactor = 0
        }
    }
    
    override func willMoveFromView(view: SKView) {
        super.willMoveFromView(view)
        motionManager.stopAccelerometerUpdates()
    }
    
    func setSceneObjects(){
        
        background = SKSpriteNode(imageNamed: "fishgamebackground")
        background!.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        background!.size = CGSize(width: self.frame.width, height: self.frame.height)
        background!.zPosition = 4
        self.addChild(background!)
        
        playerBarColor = SKSpriteNode(imageNamed: "playercolor")
        playerBarColor!.color = (viewController?.playerColor)!
        playerBarColor!.colorBlendFactor = 0.6
        playerBarColor!.position = CGPoint(x: self.frame.width/2, y: self.frame.height/1.1)
        playerBarColor?.size = CGSize(width: self.frame.size.width, height: self.frame.height/5)
        playerBarColor!.zPosition = 5
        self.addChild(playerBarColor!)
        
        visor = SKSpriteNode(imageNamed: "visor")
        visor!.position = CGPoint(x: self.frame.width/2, y: self.frame.height/3)
        visor?.setScale(2)
        //visor!.size = CGSize(width: self.frame.width, height: (visor?.texture?.size().height)!)
        visor!.zPosition = 6
        self.addChild(visor!)
        
        rightReference = SKSpriteNode(imageNamed: "sidereference")
        rightReference?.zPosition = 7
        rightReference?.position = CGPoint(x: self.frame.width/1.11, y: self.frame.height/8)
        rightReference?.setScale(2)
        self.addChild(rightReference!)
        
        let r = SKLabelNode(fontNamed: "GillSans-Bold")
        r.zPosition = 8
        r.text = "R"
        r.fontColor = UIColor.blackColor()
        r.fontSize = 150
        r.position = CGPoint(x: self.frame.width/1.1, y: self.frame.height/14)
        self.addChild(r)
        
        leftReference = SKSpriteNode(imageNamed: "sidereference")
        leftReference?.zPosition = 7
        leftReference?.position = CGPoint(x: self.frame.width/10.1, y: self.frame.height/8)
        leftReference?.setScale(2)
        self.addChild(leftReference!)
        
        let l = SKLabelNode(fontNamed: "GillSans-Bold")
        l.zPosition = 8
        l.text = "L"
        l.fontColor = UIColor.blackColor()
        l.fontSize = 150
        l.position = CGPoint(x: self.frame.width/10, y: self.frame.height/14)
        self.addChild(l)

        directionNeedle = SKSpriteNode(imageNamed: "directionneedle")
        directionNeedle?.zPosition = 9
        directionNeedle?.position = CGPoint(x: self.frame.width/2, y: 0)
        directionNeedle?.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        //directionNeedle?.zRotation = (3.14 - 1.57)
        self.addChild(directionNeedle!)
    }

}
