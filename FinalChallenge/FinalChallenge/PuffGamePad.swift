//
//  PuffGamePad.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 9/3/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit

class PuffGamePad: UIViewController {
    var gameManager : GameManager?
    
    lazy var motionManager : CMMotionManager = {
        let motion = CMMotionManager()
        motion.gyroUpdateInterval = 0.1
        return motion
        }()

    override func viewDidLoad() {
        super.viewDidLoad();
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeController:", name: "ConnectionManager_CloseController", object: nil);
        self.startAcelerometer()
        
//        if motionManager.accelerometerAvailable{
//            let queue = NSOperationQueue()
//            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler:
//                {data, error in
//                    
//                    if let _ = data{
//                        
//                    }
//                    else{
//                        return
//                    }
//                    self.sendData(data!.acceleration.y)
//                }
//            )
//        } else {
//            //print("Accelerometer is not available", terminator: "")
//        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let dic = ["PuffGamePad":" ", "action":PlayerAction.PuffGrow.rawValue]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true);
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
    
    func closeController(data:NSNotification) {
        navigationController?.popViewControllerAnimated(false)
        
    }
    
    // - x (up)
    // +x (down)
    // +y (right)
    // -y (left)
    func startAcelerometer(){
    
        if motionManager.accelerometerAvailable{
            let queue = NSOperationQueue()
            motionManager.startGyroUpdatesToQueue(queue, withHandler:
                {data, error in
                    if let _ = data{
    
                    }
                    else{
                        return
                    }
                    
                   var dic = ["PuffGamePad":" ", "action":PlayerAction.PuffGrow.rawValue]
                    if data?.rotationRate.x <= 0{
                    dic.updateValue(PlayerAction.Up.rawValue, forKey: "directionY")
                    }else{
                    dic.updateValue(PlayerAction.Down.rawValue, forKey: "directionY")
                    }
                    if data?.rotationRate.y <= 0{
                        dic.updateValue(PlayerAction.Left.rawValue, forKey: "directionX")
                    }else{
                    dic.updateValue(PlayerAction.Right.rawValue, forKey: "directionX")
                    }
                    
            
                ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true);
                    
                }
    )
    } else {
    print("Accelerometer is not available", terminator: "")
    }
    }
}