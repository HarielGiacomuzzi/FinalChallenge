//
//  MainBoard.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 8/19/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

class MainBoard: SKScene, SKPhysicsContactDelegate {
    override func didMoveToView(view: SKView) {
        var scaleFactorX = Double(2048/self.size.width);
        var scaleFactorY = Double(1536/self.size.height);
        
        for i in BoardGraph.SharedInstance.nodes{
            var texture = SKTexture(imageNamed: "bird-01");
            if i.0 == "House" || i.0 == "Store" {
                    texture = SKTexture(imageNamed: "bird-02")
            }
            
            var x = SKSpriteNode(texture: texture)
            x.position.x = CGFloat(i.1.posX/scaleFactorX);
            x.position.y = CGFloat(i.1.posY/scaleFactorY);
            self.addChild(x);
        }
        
        
        //TODO: implement this
    }
}