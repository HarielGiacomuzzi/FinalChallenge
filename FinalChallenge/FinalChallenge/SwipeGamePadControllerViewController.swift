//
//  SwipeGamePadControllerViewController.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 8/24/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit

class SwipeGamePadControllerViewController: UIViewController {

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

        sendVector(x, y: y)
    }
    
    func sendVector(x:CGFloat, y:CGFloat) {
        var dic = ["x":x,"y":y]
        var nsDic = NSDictionary(dictionary: dic)
        ConnectionManager.sharedInstance.sendDictionaryToPeer(nsDic, reliable: true)
        
    }

}
