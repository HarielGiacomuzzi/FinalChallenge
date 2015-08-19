//
//  FlappyParticleNode.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 8/19/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import SpriteKit




class FlappyParticleNode : SKEmitterNode{
   
    class func fromFile(file : String) -> FlappyParticleNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var data = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: data)
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKEmitterNode")
            let particle = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! FlappyParticleNode
            archiver.finishDecoding()
            
            return particle
        }
        return nil
    }
    
    func setupMovement(frame:CGRect, node:SKSpriteNode, vel:Double) {
        let distanceToMove = CGFloat(frame.size.width + node.size.width)
        let moveStones = SKAction.moveByX(-distanceToMove, y:0.0, duration:NSTimeInterval(vel))
        let removeStones = SKAction.removeFromParent()
        let moveStonesAndRemove = SKAction.sequence([moveStones, removeStones])
        self.runAction(moveStonesAndRemove)
    }
}