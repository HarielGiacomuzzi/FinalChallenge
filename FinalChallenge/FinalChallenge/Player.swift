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
    var coins:Int = 100 {
        didSet {
            if coins > oldValue {
                NSNotificationCenter.defaultCenter().postNotificationName("Player_CoinsAdded", object: self)
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName("Player_CoinsRemoved", object: self)                
            }
        }
    }
    var lootPoints:Int = 0
    var x:Double!
    var y:Double!
    var avatar : String?
    var nodeSprite : PlayerNode?
    var color = UIColor()
    var items:[Card] = [] {
        didSet {
            if items.count > oldValue.count {
                NSNotificationCenter.defaultCenter().postNotificationName("Player_CardAdded", object: self)
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName("Player_CardRemoved", object: self)
            }
        }
    }
    var itemsInHouse : [Card] = []
    var lastMessage : NSDictionary?
    
//    init(posX: Double, posY: Double) {
//        self.x = posX;
//        self.y = posY;
//    }
    
    
    
}