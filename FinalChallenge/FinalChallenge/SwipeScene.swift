//
//  SwipeScene.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 10/1/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class SwipeScene: GamePadScene {
    
    var beginX:CGFloat = 0.0
    var beginY:CGFloat = 0.0
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let location = touch.locationInView(self.view)
        beginX = location.x
        beginY = location.y
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let location = touch.locationInView(self.view)
        let endX = location.x
        let endY = location.y
        let x = endX - beginX
        let y = (endY - beginY) * -1
        
        var vector = CGVectorMake(x, y)
        
        vector.normalize()
        
        sendVector(vector.dx, y: vector.dy)
    }
    
    func sendVector(x:CGFloat, y:CGFloat) {
        let action = ["x":x, "y":y]
        let dic = ["controllerAction":"", "action":action]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        let label = SKLabelNode(text: "SWIPE")
        label.fontSize = 70
        label.position = CGPointMake(frame.size.width/2, frame.size.height/2)
        addChild(label)
    }
    

}
