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
    
    override func viewDidLoad() {
        super.viewDidLoad();
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeController:", name: "ConnectionManager_CloseController", object: nil);
        
        if motionManager.accelerometerAvailable{
            let queue = NSOperationQueue()
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler:
                {data, error in
                    
                    if let data = data{
                        
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let dic = ["PuffGamePad":" ", "action":PlayerAction.PuffGrow.rawValue]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true);
    }
    
    lazy var motionManager : CMMotionManager = {
        let motion = CMMotionManager()
        motion.accelerometerUpdateInterval = 1.0/10.0
        return motion
        }()
    
    
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
    
}