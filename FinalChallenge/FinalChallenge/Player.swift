//
//  Player.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 8/18/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class Player : NSObject {
    //var playerName:String!
    var playerIdentifier:String!
    var coins:Int = 0
    var x:Double!
    var y:Double!
    var avatar : String?
    var nodeSprite : SKNode?
    var color = UIColor()
    var items:[Card] = []
    
//    init(posX: Double, posY: Double) {
//        self.x = posX;
//        self.y = posY;
//    }
    
    
}