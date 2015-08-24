//
//  MainBoard.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 8/19/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

class MainBoard: SKScene, SKPhysicsContactDelegate {
    var player = SKShapeNode(circleOfRadius: 10.0);
    var realPlayer = Player();
    
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
        

        realPlayer.x = BoardGraph.SharedInstance.nodes["01"]?.posX;
        realPlayer.y = BoardGraph.SharedInstance.nodes["01"]?.posY;
        BoardGraph.SharedInstance.nodes["01"]?.currentPlayers.append(realPlayer)
        
        println("\(realPlayer.x) - \(realPlayer.y)")

//        player.position.x = CGFloat(realPlayer.x);
//        player.position.y = CGFloat(realPlayer.y);
        player.zPosition = 100
        player.position = CGPointMake(CGFloat(realPlayer.x/2), CGFloat(realPlayer.y/2))
        player.fillColor = UIColor.blueColor();
        
        self.addChild(player);
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        BoardGraph.SharedInstance.walk(3, player: realPlayer);
    }
    
    override func didFinishUpdate() {
        super.didFinishUpdate();
        player.position.x = CGFloat(realPlayer.x/2);
        player.position.y = CGFloat(realPlayer.y/2);
    }
}