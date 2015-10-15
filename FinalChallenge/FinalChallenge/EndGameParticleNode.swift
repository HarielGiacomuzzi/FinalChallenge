//
//  SetupParticle.swift
//  FinalChallenge
//
//  Created by Jonathas Hernandes on 08/09/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//
import Foundation
import SpriteKit


class EndGameParticleNode : SKEmitterNode{
    
    class func fromFile(file : String) -> EndGameParticleNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            let data = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWithData: data)
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKEmitterNode")
            let particle = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! EndGameParticleNode
            archiver.finishDecoding()
            
            return particle
        }
        return nil
    }
    
}