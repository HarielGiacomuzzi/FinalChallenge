//
//  PuffGameViewController.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 9/3/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

class PuffGameScene: SKScene, SKPhysicsContactDelegate {
    var players : [SKNode] = [];
    var pull = 1;
    var push = 1;
    var player1 = SKShapeNode(circleOfRadius: 10.0);
    var player2 = SKShapeNode(circleOfRadius: 10.0);
    
    override func didMoveToView(view: SKView) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_PuffGamePadAction", object: nil);
        
        player1.position.x = CGFloat((self.frame.width/4));
        player1.position.y = CGFloat((self.frame.height/2));
        
        player2.position.x = CGFloat((self.frame.width/4)*3);
        player2.position.y = CGFloat((self.frame.height/2));
        
        player1.zPosition = 100;
        player1.fillColor = UIColor.blueColor();
        
        player2.zPosition = 100;
        player2.fillColor = UIColor.blueColor();
        
        players.append(player1);
        players.append(player2);
        
        self.addChild(player1);
        self.addChild(player2);
    }
    
    func messageReceived(data : NSNotification){
        if let message = data.userInfo!["actionReceived"] as? String{
            var messageEnum = PlayerAction(rawValue: message)
            if messageEnum == PlayerAction.PuffPull{
                pull--;
            }
            if messageEnum == PlayerAction.PuffPush{
                push--;
            }
            for p in players{
                if pull <= 0 && push <= 0 {
                    pull = 1;
                    push = 1;
                    p.xScale = (player1.xScale+1);
                    p.yScale = (player1.yScale+1);
                    break;
                }
            }
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        //once per frame
    }
    
    override func didFinishUpdate() {

    }
}