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
    
    var spikeWallRight = SKNode()
    var spikeWallLeft = SKNode()
    var spikeWallTop = SKNode()
    var spikeWallDown = SKNode()
    
    var actionWallRight : SKAction?
    var actionWallLeft : SKAction?
    var actionWallTop : SKAction?
    var actionWallDown : SKAction?
    
    var counter = 1
    
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
        
        
        for i in 0...Int(self.frame.width/partsAtlas.textureNamed("spike").size().width){
            let spike = SKSpriteNode(texture: partsAtlas.textureNamed("spike"));
            spike.position = CGPointMake(CGFloat(i)*partsAtlas.textureNamed("spike").size().width, -partsAtlas.textureNamed("spike").size().height);
            spikeWallDown.addChild(spike)
        }
        
        for i in 0...Int(self.frame.width/partsAtlas.textureNamed("spike").size().width){
            let spike = SKSpriteNode(texture: partsAtlas.textureNamed("spike"));
            spike.position = CGPointMake(CGFloat(i)*partsAtlas.textureNamed("spike").size().width, self.frame.height+partsAtlas.textureNamed("spike").size().height);
            spike.zRotation = CGFloat(3.14159265);
            spikeWallTop.addChild(spike)
        }
        
        for i in 0...Int(self.frame.width/partsAtlas.textureNamed("spike").size().width){
            let spike = SKSpriteNode(texture: partsAtlas.textureNamed("spike"));
            spike.position = CGPointMake(self.frame.width+partsAtlas.textureNamed("spike").size().width, CGFloat(i)*partsAtlas.textureNamed("spike").size().height);
            spike.zRotation = CGFloat(1.57079633);
            spikeWallRight.addChild(spike)
        }
        
        for i in 0...Int(self.frame.height/partsAtlas.textureNamed("spike").size().height){
            let spike = SKSpriteNode(texture: partsAtlas.textureNamed("spike"));
            spike.position = CGPointMake(-partsAtlas.textureNamed("spike").size().width, CGFloat(i)*partsAtlas.textureNamed("spike").size().height);
            spike.zRotation = CGFloat(-1.57079633);
            spikeWallLeft.addChild(spike);
        }
        
        var down = SKAction.moveBy(CGVector(dx: 0, dy: partsAtlas.textureNamed("spike").size().height*1.5), duration: NSTimeInterval(1.5))
        actionWallDown = SKAction.sequence([down, down.reversedAction()]);
        var top = SKAction.moveBy(CGVector(dx: 0, dy: -partsAtlas.textureNamed("spike").size().height*1.5), duration: NSTimeInterval(1.5))
        actionWallTop = SKAction.sequence([top,top.reversedAction()]);
        var right = SKAction.moveBy(CGVector(dx: -partsAtlas.textureNamed("spike").size().height*1.5, dy: 0), duration: NSTimeInterval(1.5))
        actionWallRight = SKAction.sequence([right,right.reversedAction()]);
        var left = SKAction.moveBy(CGVector(dx: partsAtlas.textureNamed("spike").size().height*1.5, dy: 0), duration: NSTimeInterval(1.5))
        actionWallLeft = SKAction.sequence([left,left.reversedAction()]);
        
//        println(UIScreen.mainScreen().bounds.height)
//        println(UIScreen.mainScreen().bounds.width)
//        println(self.frame.height)
//        println(self.frame.width)
        //spikeWall.position = CGPointMake(0, 0);

        self.addChild(spikeWallDown);
        self.addChild(spikeWallTop);
        self.addChild(spikeWallRight);
        self.addChild(spikeWallLeft);
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
            spikeWallTop.runAction(SKAction.repeatActionForever(actionWallTop!));
            spikeWallDown.runAction(SKAction.repeatActionForever(actionWallDown!));
            spikeWallLeft.runAction(SKAction.repeatActionForever(actionWallLeft!));
            spikeWallRight.runAction(SKAction.repeatActionForever(actionWallRight!));
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