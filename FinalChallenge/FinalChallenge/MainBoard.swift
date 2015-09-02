//
//  MainBoard.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 8/19/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

class MainBoard: SKScene, SKPhysicsContactDelegate {
    var viewController: UIViewController?
    
    override func didMoveToView(view: SKView) {
        GameManager.sharedInstance.boardViewController = self.viewController;
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
        
        var x = BoardGraph.SharedInstance.nodes["01"]?.posX;
        var y = BoardGraph.SharedInstance.nodes["01"]?.posY;
        
        for p in GameManager.sharedInstance.players{
            var sprite = SKShapeNode(circleOfRadius: 10.0);
            p.x = x;
            p.y = y;
            sprite.zPosition = 100;
            sprite.fillColor = UIColor.blueColor();
            p.nodeSprite = sprite;
            BoardGraph.SharedInstance.nodes["01"]?.currentPlayers.append(p)
            
            self.addChild(p.nodeSprite!)
        }
        

        GameManager.sharedInstance.playerTurnEnded(nil)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
          //BoardGraph.SharedInstance.walk(1, player: realPlayer, view: self.viewController)
           //GameManager.sharedInstance.beginMinigame()
        
    }
    
    
    override func didFinishUpdate() {
        super.didFinishUpdate();
        for p in GameManager.sharedInstance.players{
            p.nodeSprite?.position.x = CGFloat(p.x/2);
            p.nodeSprite?.position.y = CGFloat(p.y/2);
        }
    }
}