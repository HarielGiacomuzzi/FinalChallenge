//
//  AccelerometerGamePad.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 8/25/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import CoreMotion

class AccelerometerGamePadController: UIViewController {
    
    var gameManager : GameManager?
    
    lazy var motionManager : CMMotionManager = {
        let motion = CMMotionManager()
        motion.accelerometerUpdateInterval = 1.0/10.0
        return motion
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeController:", name: "ConnectionManager_CloseController", object: nil);
        
        //gameManager?.miniGameActive =
        
        if motionManager.accelerometerAvailable{
            let queue = NSOperationQueue()
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler:
                {data, error in
                    
                    if let data = data{
                        
                    }
                    else{
                        return
                    }
                    print(" Y = \(data.acceleration.y)")
                    self.sendData(data.acceleration.y)
                }
            )
        } else {
            print("Accelerometer is not available")
        }
    }
    
    
    func sendData(y:Double) {
        
        if y > 0{
            var action = ["way":PlayerAction.Down.rawValue]
            var dic = ["controllerAction":"", "action":action]
            ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        }else if y < 0{
            var action = ["way":PlayerAction.Up.rawValue]
            var dic = ["controllerAction":"", "action":action]
            ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        } 
    }
    
    func closeController(data:NSNotification) {
        navigationController?.popViewControllerAnimated(false)

    }
}