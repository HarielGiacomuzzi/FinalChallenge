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

class AccelerometerScene: GamePadScene {
    
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
                    self.sendData(data!.acceleration.y)
                }
            )
        } else {
            print("Accelerometer is not available", terminator: "")
        }
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

}