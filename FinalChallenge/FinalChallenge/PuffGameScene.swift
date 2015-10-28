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
    
    let playerCategory : UInt32 = 0x1 << 0
    let spikeCategory : UInt32 = 0x1 << 1
    
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
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;

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
        
        // CONFIGURAÇÃO DA FISICA
        spikeWallDown.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: CGFloat(self.view!.frame.width), height: partsAtlas.textureNamed("spike").size().height))
        spikeWallDown.physicsBody?.dynamic = true
        spikeWallDown.physicsBody?.categoryBitMask = self.spikeCategory
        spikeWallDown.physicsBody?.contactTestBitMask = self.playerCategory
        spikeWallDown.physicsBody?.collisionBitMask = 0

        spikeWallTop.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: CGFloat(self.view!.frame.width), height: partsAtlas.textureNamed("spike").size().height))
        spikeWallTop.physicsBody?.dynamic = true
        spikeWallTop.physicsBody?.categoryBitMask = self.spikeCategory
        spikeWallTop.physicsBody?.contactTestBitMask = self.playerCategory
        spikeWallTop.physicsBody?.collisionBitMask = 0
        
        spikeWallRight.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: partsAtlas.textureNamed("spike").size().height, height: CGFloat((self.view?.frame.size.height)!)))
        spikeWallRight.physicsBody?.dynamic = true
        spikeWallRight.physicsBody?.categoryBitMask = self.spikeCategory
        spikeWallRight.physicsBody?.contactTestBitMask = self.playerCategory
        spikeWallRight.physicsBody?.collisionBitMask = 0
        
        spikeWallLeft.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: partsAtlas.textureNamed("spike").size().height, height: CGFloat((self.view?.frame.size.height)!)))
        spikeWallLeft.physicsBody?.dynamic = true
        spikeWallLeft.physicsBody?.categoryBitMask = self.spikeCategory
        spikeWallLeft.physicsBody?.contactTestBitMask = self.playerCategory
        spikeWallLeft.physicsBody?.collisionBitMask = 0
        
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
//                        p.sprite!.xScale = (p.sprite!.xScale+1);
//                        p.sprite!.yScale = (p.sprite!.yScale+1);
//                        if p.sprite!.xScale > 30{
//                            explodePuff(p.sprite!)
//                        }
                        //break;
                    if data.userInfo!["directionX"]! as! String == PlayerAction.Left.rawValue{
                        if p.sprite?.position.x > 0{
                            p.sprite?.position.x = CGFloat((p.sprite?.position.x)!-5)
                        }
                    }else{
                        if p.sprite?.position.x < self.view!.frame.width{
                         p.sprite?.position.x = CGFloat((p.sprite?.position.x)!+5)
                        }
                    }
                if data.userInfo!["directionY"] as! String == PlayerAction.Up.rawValue{
                    if p.sprite?.position.y < self.view!.frame.height{
                        p.sprite?.position.y = CGFloat((p.sprite?.position.y)!+5)
                    }
                }else{
                    if p.sprite?.position.y > 0{
                       p.sprite?.position.y = CGFloat((p.sprite?.position.y)!-5)
                    }
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