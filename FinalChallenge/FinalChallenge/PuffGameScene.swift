//
//  PuffGameViewController.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 9/3/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

class PuffGameScene: SKScene, SKPhysicsContactDelegate {
    var player1 = SKShapeNode(circleOfRadius: 10.0);
    var player2 = SKShapeNode(circleOfRadius: 10.0);
    
    override func didMoveToView(view: SKView) {
        player1.position.x = CGFloat((self.frame.width/4));
        player1.position.y = CGFloat((self.frame.height/2));
        
        player2.position.x = CGFloat((self.frame.width/4)*3);
        player2.position.y = CGFloat((self.frame.height/2));
        
        player1.zPosition = 100;
        player1.fillColor = UIColor.blueColor();
        
        player2.zPosition = 100;
        player2.fillColor = UIColor.blueColor();
        
        self.addChild(player1);
        self.addChild(player2);
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        player1.xScale = (player1.xScale+1)
        player1.yScale = (player1.yScale+1)
    }
    
    override func update(currentTime: NSTimeInterval) {
        //once per frame
    }
    
    override func didFinishUpdate() {

    }
}