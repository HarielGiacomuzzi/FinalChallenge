//
//  endParticle.swift
//  FinalChallenge
//
//  Created by Jonathas Hernandes on 11/11/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import SpriteKit




class endParticle : SKEmitterNode{
    
    class func fromFile(file : String) -> endParticle? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            let data = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWithData: data)
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKEmitterNode")
            let particle = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! endParticle
            archiver.finishDecoding()
            
            return particle
        }
        return nil
    }
    
}