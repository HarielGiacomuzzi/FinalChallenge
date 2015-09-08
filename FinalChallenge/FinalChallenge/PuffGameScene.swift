//
//  PuffGameViewController.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 9/3/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

class PuffGameScene: SKScene, SKPhysicsContactDelegate {
    var pull = 1;
    var push = 1;
    let partsAtlas = SKTextureAtlas(named: "puffGame")
    
    override func didMoveToView(view: SKView) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_PuffGamePadAction", object: nil);
        
        var count = GameManager.sharedInstance.players.count
        var width = (self.frame.width-20)/CGFloat(GameManager.sharedInstance.players.count*2)
        
        for p in GameManager.sharedInstance.players{
            var sprite = SKShapeNode(circleOfRadius: 10.0);
            p.x = Double(width)*Double(count);
            p.y = Double((self.frame.height/2));
            count--;
            sprite.zPosition = 100;
            sprite.position.x = CGFloat(p.x)
            sprite.position.y = CGFloat(p.y)
            sprite.fillColor = UIColor.blueColor();
            p.nodeSprite = sprite;
            
            self.addChild(p.nodeSprite!)
        }

        
    }
    
    func messageReceived(data : NSNotification){
        if let message = data.userInfo!["actionReceived"] as? String{
            var messageEnum = PlayerAction(rawValue: message)
           
            for p in GameManager.sharedInstance.players{
                if p.playerIdentifier == data.userInfo!["peerID"] as? String{
                    if messageEnum == PlayerAction.PuffPull{
                        p.pull--;
                    }
                    if messageEnum == PlayerAction.PuffPush{
                        p.push--;
                    }
                    if p.pull <= 0 && p.push <= 0 {
                        p.pull = 1;
                        p.push = 1;
                        p.nodeSprite!.xScale = (p.nodeSprite!.xScale+1);
                        p.nodeSprite!.yScale = (p.nodeSprite!.yScale+1);
                        if p.nodeSprite!.xScale > 10{
                            explodePuff(p.nodeSprite!)
                        }
                        break;
                    }
                }
            }
        }
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
       
    }
    
    
    func explodePuff(player:SKNode){
        if player.hidden == false{
            player.hidden = true;
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
    }
    
    override func update(currentTime: NSTimeInterval) {
        //once per frame
    }
    
    override func didFinishUpdate() {

    }
}