//
//  TestScene.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 10/8/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class TestScene: SKScene {

    var player: PlayerNode!
    
    override func didMoveToView(view: SKView) {
        player = PlayerNode(named: "ranger")
        player.position = CGPointMake(frame.size.width/2, frame.size.height/2)
        addChild(player)
        let point1 = CGPointMake(frame.size.width/2, 0.0)
        let point2 = CGPointMake(frame.size.width/2, frame.size.height)
        let point3 = CGPointMake(frame.size.width/2, frame.size.height/2)
        let point4 = CGPointMake(0, frame.size.height/2)
        let point5 = CGPointMake(frame.size.width, frame.size.height/2)
        player.walkTo([point1,point2,point3,point4,point5], completion: {})
//        player.walkTo(point1, completion: {})
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //let touch = touches.first
        //let location = touch?.locationInNode(self)
//        player.walkTo(location!)
    }
}
