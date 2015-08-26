//
//  BombPlayerNode.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 8/25/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class BombPlayerNode: SKSpriteNode {
    
    let playerCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let bombCategory: UInt32 = 1 << 2
    
    init() {
        super.init(texture: nil, color: UIColor.blueColor(), size: CGSize(width: 55   , height: 60))
        setupPhysics()
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = playerCategory
        self.physicsBody?.collisionBitMask = worldCategory
        self.physicsBody?.contactTestBitMask = bombCategory
    }
    
}
