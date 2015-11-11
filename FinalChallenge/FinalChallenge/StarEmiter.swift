//
//  StarEmiter.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 11/11/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import SpriteKit


class StarEmiter : SKEmitterNode{
    
    class func fromFile(file : String) -> StarEmiter? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            let data = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWithData: data)
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKEmitterNode")
            let particle = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! StarEmiter
            archiver.finishDecoding()
            
            return particle
        }
        return nil
    }
    
}