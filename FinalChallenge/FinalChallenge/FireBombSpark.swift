//
//  FireBombSpark.swift
//  FinalChallenge
//
//  Created by Jonathas Hernandes on 25/08/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import SpriteKit




class FireBombSpark : SKEmitterNode{
    
    class func fromFile(file : String) -> FireBombSpark? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var data = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: data)
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKEmitterNode")
            let particle = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! FireBombSpark
            archiver.finishDecoding()
            
            return particle
        }
        return nil
    }
    
    func setupMovement(frame:CGRect, node:SKSpriteNode, vel:Double) {
        let distanceToMove = CGFloat(-frame.size.width / 2)
        
        let moveStones = SKAction.moveToX(distanceToMove, duration:NSTimeInterval(vel))
        let removeStones = SKAction.removeFromParent()
        let moveStonesAndRemove = SKAction.sequence([moveStones, removeStones])
        self.runAction(moveStonesAndRemove)
    }
}