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
    let partsAtlas = SKTextureAtlas(named: "puffGame")
    
    override func didMoveToView(view: SKView) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_PuffGamePadAction", object: nil);
        
        player1.position.x = CGFloat((self.frame.width/4));
        player1.position.y = CGFloat((self.frame.height/2));
        
        player2.position.x = CGFloat((self.frame.width/2));
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
    
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        player1.xScale = (player1.xScale+1)
        player1.yScale = (player1.yScale+1)
        if player1.xScale > 10{
         explodePuff(player1)
        }
    }
    
    
    func explodePuff(player:SKNode){
        player.removeFromParent()
        let outExplosion = SKSpriteNode(texture: partsAtlas.textureNamed("explosion0"))
        let midExplosion = SKSpriteNode(texture: partsAtlas.textureNamed("explosion1"))
        let inExplosion = SKSpriteNode(texture: partsAtlas.textureNamed("explosion2"))
        
        let explosionParts : [SKSpriteNode] = [outExplosion, midExplosion , inExplosion]
        
        for explosion in explosionParts{
            
            let m = explosion.size
            explosion.size = CGSize(width: explosion.size.width * 0.2, height: explosion.size.height * 0.2)
            explosion.position = CGPoint(x: player.position.x, y: player.position.y)
            
            let crescimento = SKAction.resizeToWidth(m.width * 2, height: m.height * 2, duration: 0.5)
            
            let rotacao = CGFloat(arc4random_uniform(5)+1);
            explosion.physicsBody = SKPhysicsBody(rectangleOfSize: m)
            explosion.physicsBody?.categoryBitMask = 0x0
            explosion.physicsBody?.applyAngularImpulse(rotacao)
            explosion.physicsBody?.dynamic = false
            
            self.addChild(explosion)
            
            explosion.runAction(crescimento, completion: { () -> Void in
                explosion.removeFromParent()
            })
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        //once per frame
    }
    
    override func didFinishUpdate() {

    }
}