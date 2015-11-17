//
//  RopeGamePlayer.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 11/13/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

class RopeGamePlayer : SKSpriteNode{
    
    let playerCategory : UInt32 = 1 << 0
    let worldCategory : UInt32 = 1 << 1
    
    init(){
        let texture = SKTexture(imageNamed: "ropegatow")
        
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
    }
     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    func activePhysicsBody(){
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: (self.texture?.size().width)!/3, height: (self.texture?.size().height)!/2), center: CGPoint(x: 0, y: self.texture!.size().height/4))
        self.physicsBody?.dynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = playerCategory
        self.physicsBody?.collisionBitMask = worldCategory
        self.physicsBody?.contactTestBitMask = worldCategory
        self.physicsBody?.mass =  100
    }
}