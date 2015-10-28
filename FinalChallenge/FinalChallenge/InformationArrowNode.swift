//
//  TutorialArrow.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 10/26/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class InformationArrowNode: SKSpriteNode {
    
    var pointingRight = true
    var nodeToPoint: SKNode!
    var atlas = SKTextureAtlas(named: "tutorial")
    
    init(pointingRight: Bool, nodeToPoint: SKNode) {
        self.pointingRight = pointingRight
        self.nodeToPoint = nodeToPoint
        super.init(texture: atlas.textureNamed("arrow0"), color: UIColor.clearColor(), size: atlas.textureNamed("arrow13").size())
        anchorPoint = CGPointMake(1.0,0.5)
        positionArrow()
        
    }
    
    func animate() {
        var textures:[SKTexture] = []
        for i in 0...13 {
            textures.append(atlas.textureNamed("arrow\(i)"))
        }
        let animation = SKAction.animateWithTextures(textures, timePerFrame: 0.05)
        self.runAction(animation)
        let moveRight = SKAction.moveTo(CGPointMake(position.x + 10, position.y), duration: 0.5)
        let moveLeft = SKAction.moveTo(CGPointMake(position.x - 10, position.y), duration: 0.5)

        let sequence = SKAction.sequence([moveRight, moveLeft])
        
        runAction(animation, completion: {() in
            self.runAction(SKAction.repeatActionForever(sequence))
        })
    }
    
    func positionArrow() {
        position = nodeToPoint.position
        if pointingRight {
            position.x = nodeToPoint.position.x - nodeToPoint.frame.size.width/2
        } else {
            xScale = -1
            position.x = nodeToPoint.position.x + nodeToPoint.frame.size.width/2
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

