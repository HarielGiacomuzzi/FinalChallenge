//
//  PlayerNode.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 10/8/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class PlayerNode: SKSpriteNode {
    
    var named = " "
    var walkingDown:[SKTexture] = []
    var walkingUp:[SKTexture] = []
    var walkingSideways:[SKTexture] = []
    
    init(named:String) {
        
        
        let playerSpriteAtlas = SKTextureAtlas(named: "charSprites")
        
        self.named = named
        if named == "wizard" {
            self.named = "mage" //lol
        }
        
        let pTexture = playerSpriteAtlas.textureNamed("\(self.named)Front0")
        
        super.init(texture: pTexture, color: UIColor.clearColor(), size: pTexture.size())
        
        fillTextures(playerSpriteAtlas)
        zPosition = 5000
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillTextures(atlas:SKTextureAtlas) {
        for i in 0...3 {
            walkingUp.append(atlas.textureNamed("\(named)Back\(i)"))
            walkingDown.append(atlas.textureNamed("\(named)Front\(i)"))
            walkingSideways.append(atlas.textureNamed("\(named)Side\(i)"))

        }
    }
    
    func walkTo(pointList:[CGPoint], completion:() -> ()) {
        if pointList.count == 0 {
            completion()
            return
        }
        if pointList.count == 1 {
            walkTo(pointList.first!, completion: completion)
            return
        }
        var list = pointList
        let last = list.removeLast()
        var block = {self.walkTo(last, completion: {() in
            self.texture = self.walkingDown.first
            self.runAction(SKAction.waitForDuration(0.5), completion: {() in
                completion()
            })
        })}
        while list.count > 1 {
            let newBlock = block
            let last = list.removeLast()
            block = {self.walkTo(last, completion: newBlock)}
        }
        walkTo(list.last!, completion: block)

    }
    
    func walkTo(point:CGPoint, completion:() -> ()) {
        //print(point)
        //print(position)
        let textures = decideDirection(point)
        let animation = SKAction.animateWithTextures(textures, timePerFrame: 0.1)
        let movement = SKAction.moveTo(point, duration: 1.0)
        
        self.runAction(SKAction.repeatActionForever(animation))
        self.runAction(movement, completion: {() in
            self.removeAllActions()
            completion()
        })
    }
    
    func decideDirection(point:CGPoint) -> [SKTexture] {
        let sidewaysMovement = fabs(fabs(point.x) - fabs(position.x))
        let updownMovement = fabs(fabs(point.y) - fabs(position.y))
        if sidewaysMovement > updownMovement {
            if point.x > position.x { //right
                if xScale > 0 {
                    xScale = -1
                }
                return walkingSideways
            } else { //left
                if xScale < 0 {
                    xScale = 1
                }
                return walkingSideways
            }
        } else {
            if point.y > position.y { //up
                return walkingUp
            } else { //down
                return walkingDown
            }
        }
    }

}
