//
//  PuffGameViewController.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 9/3/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

class PuffGameScene: SKScene, SKPhysicsContactDelegate {
    let partsAtlas = SKTextureAtlas(named: "puffGame")
    
    var players = [PuffPlayer]()
    
    var spikeWallRight = SKNode()
    var spikeWallLeft = SKNode()
    var spikeWallTop = SKNode()
    var spikeWallDown = SKNode()
    
    var actionWallRight : SKAction?
    var actionWallLeft : SKAction?
    var actionWallTop : SKAction?
    var actionWallDown : SKAction?
    
    override func didMoveToView(view: SKView) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_PuffGamePadAction", object: nil);
        
        var count = GameManager.sharedInstance.players.count
        let width = (self.frame.width-20)/CGFloat(GameManager.sharedInstance.players.count*2)
        
        for p in GameManager.sharedInstance.players{
            let player = PuffPlayer(name: "aaa")
            let sprite = SKShapeNode(circleOfRadius: 10.0);
            player.x = Double(width)*Double(count);
            player.y = Double((self.frame.height/2));
            count--;
            sprite.zPosition = 100;
            sprite.position.x = CGFloat(player.x!)
            sprite.position.y = CGFloat(player.y!)
            sprite.fillColor = UIColor.blueColor();
            player.sprite = sprite
            self.players.append(player)
            
            self.addChild(player.sprite!)
        }
        
        setupSpikes();

    }
    
    func setupSpikes(){
        for i in 0...Int(self.view!.frame.width/partsAtlas.textureNamed("spike").size().width){
            let spike = SKSpriteNode(texture: partsAtlas.textureNamed("spike"));
            spike.position = CGPointMake(CGFloat(i)*partsAtlas.textureNamed("spike").size().width, -partsAtlas.textureNamed("spike").size().height);
            spikeWallDown.addChild(spike)
        }
        
        for i in 0...Int(self.view!.frame.width/partsAtlas.textureNamed("spike").size().width){
            let spike = SKSpriteNode(texture: partsAtlas.textureNamed("spike"));
            spike.position = CGPointMake(CGFloat(i)*partsAtlas.textureNamed("spike").size().width, self.view!.frame.height+partsAtlas.textureNamed("spike").size().height);
            spike.zRotation = CGFloat(3.14159265);
            spikeWallTop.addChild(spike)
        }
        
        for i in 0...Int(self.view!.frame.width/partsAtlas.textureNamed("spike").size().width){
            let spike = SKSpriteNode(texture: partsAtlas.textureNamed("spike"));
            spike.position = CGPointMake(self.view!.frame.width+partsAtlas.textureNamed("spike").size().width, CGFloat(i)*partsAtlas.textureNamed("spike").size().height);
            spike.zRotation = CGFloat(1.57079633);
            spikeWallRight.addChild(spike)
        }
        
        for i in 0...Int(self.view!.frame.height/partsAtlas.textureNamed("spike").size().height){
            let spike = SKSpriteNode(texture: partsAtlas.textureNamed("spike"));
            spike.position = CGPointMake(-partsAtlas.textureNamed("spike").size().width, CGFloat(i)*partsAtlas.textureNamed("spike").size().height);
            spike.zRotation = CGFloat(-1.57079633);
            spikeWallLeft.addChild(spike);
        }
        
        let down = SKAction.moveBy(CGVector(dx: 0, dy: partsAtlas.textureNamed("spike").size().height*1.5), duration: NSTimeInterval(1.5))
        actionWallDown = SKAction.sequence([down, down.reversedAction()]);
        let top = SKAction.moveBy(CGVector(dx: 0, dy: -partsAtlas.textureNamed("spike").size().height*1.5), duration: NSTimeInterval(1.5))
        actionWallTop = SKAction.sequence([top,top.reversedAction()]);
        let right = SKAction.moveBy(CGVector(dx: -partsAtlas.textureNamed("spike").size().height*1.5, dy: 0), duration: NSTimeInterval(1.5))
        actionWallRight = SKAction.sequence([right,right.reversedAction()]);
        let left = SKAction.moveBy(CGVector(dx: partsAtlas.textureNamed("spike").size().height*1.5, dy: 0), duration: NSTimeInterval(1.5))
        actionWallLeft = SKAction.sequence([left,left.reversedAction()]);
        
        self.addChild(spikeWallDown);
        self.addChild(spikeWallTop);
        self.addChild(spikeWallRight);
        self.addChild(spikeWallLeft);
        
        spikeWallTop.runAction(SKAction.repeatActionForever(actionWallTop!));
        spikeWallDown.runAction(SKAction.repeatActionForever(actionWallDown!));
        spikeWallLeft.runAction(SKAction.repeatActionForever(actionWallLeft!));
        spikeWallRight.runAction(SKAction.repeatActionForever(actionWallRight!));
    }
    
    func messageReceived(data : NSNotification){
        if let message = data.userInfo!["actionReceived"] as? String{
            _ = PlayerAction(rawValue: message)
           
            for p in self.players{
                //if p.playerIdentifier == data.userInfo!["peerID"] as? String{
                        p.sprite!.xScale = (p.sprite!.xScale+1);
                        p.sprite!.yScale = (p.sprite!.yScale+1);
                        if p.sprite!.xScale > 30{
                            explodePuff(p.sprite!)
                        }
                        //break;
                    if data.userInfo!["directionX"] as! PlayerAction == PlayerAction.Left{
                        p.sprite?.position.x--
                    }else{
                         p.sprite?.position.x++
                    }
                if data.userInfo!["directionY"] as! PlayerAction == PlayerAction.Up{
                    p.sprite?.position.y++
                }else{
                    p.sprite?.position.y--
                }
                }
                //}
            }
        }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
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