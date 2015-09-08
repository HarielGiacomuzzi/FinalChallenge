//
//  SetupParticle.swift
//  FinalChallenge
//
//  Created by Jonathas Hernandes on 08/09/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//
import Foundation
import SpriteKit




class SetupParticle : SKEmitterNode{
    
    class func fromFile(file : String) -> SetupParticle? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var data = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: data)
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKEmitterNode")
            let particle = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! SetupParticle
            archiver.finishDecoding()
            
            return particle
        }
        return nil
    }

}