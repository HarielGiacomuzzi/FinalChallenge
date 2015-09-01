//
//  SwipeGamePadControllerViewController.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 8/24/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit

class SwipeGamePadControllerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeController:", name: "ConnectionManager_CloseController", object: nil);
    }

    var beginX:CGFloat = 0.0
    var beginY:CGFloat = 0.0
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.locationInView(self.view)
        beginX = location.x
        beginY = location.y
    }
    
     override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.locationInView(self.view)
        var endX = location.x
        var endY = location.y
        var x = endX - beginX
        var y = (endY - beginY) * -1
    
        var vector = CGVectorMake(x, y)
        
        vector.normalize()
    
        sendVector(vector.dx, y: vector.dy)
    }
    
    func sendVector(x:CGFloat, y:CGFloat) {
        var action = ["x":x, "y":y]
        var dic = ["controllerAction":"", "action":action]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        
    }
    
    func closeController(data:NSNotification) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
