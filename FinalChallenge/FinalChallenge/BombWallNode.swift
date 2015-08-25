//
//  BombWallNode.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 8/25/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class BombWallNode: SKSpriteNode {
    
    let playerCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let bombCategory: UInt32 = 1 << 2
    
    var hasPlayer = false
    
    var generalPosition = BombTGameScene.Position.Undefined
    
    init(pos:BombTGameScene.Position,frame:CGRect) {
        super.init(texture: nil, color: UIColor.whiteColor(), size: CGSize(width: 20, height: frame.size.height - 19 ))
        generalPosition = pos
        setupPosition(pos, frame: frame)
        setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPosition(pos:BombTGameScene.Position, frame:CGRect) {
        var restoHorizontal = frame.size.width - (frame.size.height)
        switch pos {
        case .North:
            self.position = CGPointMake(frame.size.width/2, frame.size.height/2)
            self.zRotation = 1.57079633
        case .South:
            self.position = CGPointMake(frame.size.width/2, 0)
            self.zRotation = 1.57079633
        case .East:
            self.position = CGPointMake(frame.size.width - (restoHorizontal/2) , frame.size.height )
        case .West:
            self.position = CGPointMake(restoHorizontal/2, frame.size.height / 2)
        default:
            ()
        }
    }
    
    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = worldCategory
        self.physicsBody?.collisionBitMask = bombCategory | playerCategory
    }
}
