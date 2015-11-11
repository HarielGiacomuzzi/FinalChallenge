//
//  PuffGameViewController.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 9/3/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

// OVERLOADS
func * (left: CGSize, right: CGFloat) -> CGSize {
    return CGSizeMake(left.width * right, left.height * right)
}

func / (left: CGSize, right: Int) -> CGSize {
    return CGSizeMake(left.width / CGFloat(right),left.height / CGFloat(right))
}

func + (left: CGSize, right: CGSize) -> CGSize {
    return CGSizeMake(left.width + right.width,left.height + right.height)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPointMake(left.x - right.x,left.y - right.y)
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPointMake(left.x + right.x,left.y + right.y)
}

func - (left: CGSize, right: CGSize) -> CGSize {
    return CGSizeMake(left.width - right.width, left.height - left.height)
}

func - (left: CGSize, right: CGFloat) -> CGSize {
    return CGSizeMake(left.width - right, left.height - right)
}

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
        setupPlayers();
        //setupSpikes();
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -0.01)
        self.physicsWorld.contactDelegate = self;
        setupBackground();
        setupTowers();

    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var player : SKPhysicsBody?
        var spike : SKPhysicsBody?
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        {
            player = contact.bodyA;
            spike = contact.bodyB;
        }
        else
        {
            player = contact.bodyB;
            spike = contact.bodyA;
        }
        
        if ((player!.categoryBitMask & self.playerCategory) != 0 &&
            (spike!.categoryBitMask & self.spikeCategory) != 0)
        {
           self.playerColidedWithSpike((player?.node)! , spike: (spike?.node)!)
        }
        
    }
    
    func setupPlayers(){
        let scaleFactor = CGFloat(0.33)
        var count = GameManager.sharedInstance.players.count
        let width = (self.frame.width-20)/CGFloat(GameManager.sharedInstance.players.count*2)
        let aux1 = partsAtlas.textureNamed("babyHead").size()*CGFloat(scaleFactor)/2
        let aux2 = partsAtlas.textureNamed("babyBody").size()*CGFloat(scaleFactor)/2
        
        for p in GameManager.sharedInstance.players{
            let player = PuffPlayer(name: p.playerIdentifier)
            
            //----------------------------------------------------------------------------
            // Creates the Player Body
            //----------------------------------------------------------------------------
            let head = SKSpriteNode(texture: partsAtlas.textureNamed("babyHead"), color: UIColor.blueColor(), size: partsAtlas.textureNamed("babyHead").size()*CGFloat(0.33))
            head.zPosition = 1
            head.physicsBody = SKPhysicsBody(rectangleOfSize: partsAtlas.textureNamed("babyHead").size()*CGFloat(0.33))
            head.position = CGPointMake(0, 0)
            
            let helmet = SKSpriteNode(texture: partsAtlas.textureNamed("helmet"), color: UIColor.blueColor(), size: partsAtlas.textureNamed("helmet").size()*CGFloat(scaleFactor))
            helmet.zPosition = 3
            helmet.physicsBody = SKPhysicsBody(rectangleOfSize: partsAtlas.textureNamed("helmet").size()*CGFloat(scaleFactor))
            helmet.position = CGPointMake(0, 0)
            helmet.physicsBody?.mass = CGFloat(10.0)
            helmet.name = "head"
            
            let helmetReflex = SKSpriteNode(texture: partsAtlas.textureNamed("helmetReflex"), color: UIColor.blueColor(), size: partsAtlas.textureNamed("helmetReflex").size()*CGFloat(scaleFactor))
            helmetReflex.zPosition = 4
            helmetReflex.physicsBody = SKPhysicsBody(rectangleOfSize: partsAtlas.textureNamed("helmetReflex").size()*CGFloat(scaleFactor))
            helmetReflex.position = CGPointMake(0, 0)
            
            let body = SKSpriteNode(texture: partsAtlas.textureNamed("babyBody"), color: UIColor.blueColor(), size: partsAtlas.textureNamed("babyBody").size()*CGFloat(scaleFactor))
            body.zPosition = 1
            
            body.physicsBody = SKPhysicsBody(rectangleOfSize: partsAtlas.textureNamed("body").size()*CGFloat(scaleFactor))
            body.position = CGPointMake(helmet.position.x,  -(aux1 + aux2).height+15)
            body.physicsBody?.mass = CGFloat(10.0)
           
            let armRight = SKSpriteNode(texture: partsAtlas.textureNamed("babyArm"), color: UIColor.blueColor(), size:partsAtlas.textureNamed("babyArm").size()*CGFloat(scaleFactor))
            armRight.zPosition = 0
            armRight.physicsBody = SKPhysicsBody(rectangleOfSize: (partsAtlas.textureNamed("babyArm").size()*CGFloat(0.15)))
            armRight.physicsBody?.angularDamping = CGFloat(0.15)
            armRight.position = CGPointMake(aux2.width+5,-(aux1 + aux2).height+15)
            armRight.physicsBody?.mass = CGFloat(2.5)
            
            let armLeft = SKSpriteNode(texture: partsAtlas.textureNamed("babyArm"), color: UIColor.blueColor(), size:partsAtlas.textureNamed("babyArm").size()*CGFloat(scaleFactor))
            armLeft.zPosition = 0
            armLeft.xScale = -armLeft.xScale
            armLeft.physicsBody = SKPhysicsBody(rectangleOfSize: (partsAtlas.textureNamed("babyArm").size()*CGFloat(0.15)))
            armLeft.physicsBody?.angularDamping = CGFloat(0.15)
            armLeft.position = CGPointMake(-aux2.width-5,-(aux1 + aux2).height+15)
            armLeft.physicsBody?.mass = CGFloat(2.5)
            
            let legRight = SKSpriteNode(texture: partsAtlas.textureNamed("babyLeg"), color: UIColor.blueColor(), size:partsAtlas.textureNamed("babyLeg").size()*CGFloat(scaleFactor))
            legRight.zPosition = 0
            legRight.zRotation = CGFloat(4.71239)
            legRight.physicsBody = SKPhysicsBody(rectangleOfSize: partsAtlas.textureNamed("babyLeg").size()*CGFloat(0.25))
            legRight.position = CGPointMake(aux2.width/2.5, -aux1.height-body.size.height)
            legRight.physicsBody?.mass = CGFloat(2.5)
            
            let legLeft = SKSpriteNode(texture: partsAtlas.textureNamed("babyLeg"), color: UIColor.blueColor(), size:partsAtlas.textureNamed("babyLeg").size()*CGFloat(scaleFactor))
            legLeft.zPosition = 0
            legLeft.zRotation = CGFloat(1.5708)
            legLeft.xScale = -legLeft.xScale
            legLeft.physicsBody = SKPhysicsBody(rectangleOfSize: partsAtlas.textureNamed("babyLeg").size()*CGFloat(0.25))
            legLeft.position = CGPointMake(-aux2.width/2.5,-aux1.height-body.size.height)
            legLeft.physicsBody?.mass = CGFloat(2.5)
            
            
            //----------------------------------------------------------------------------
            // Creates the player master Node
            //----------------------------------------------------------------------------
            
            let spriteNode = SKSpriteNode()
            spriteNode.addChild(head)
            spriteNode.addChild(helmet)
            spriteNode.addChild(helmetReflex)
            spriteNode.addChild(body)
            spriteNode.addChild(armRight)
            spriteNode.addChild(armLeft)
            spriteNode.addChild(legRight)
            spriteNode.addChild(legLeft)
            spriteNode.size = helmet.size
            
            player.x = Double(width)*Double(count);
            player.y = Double((self.frame.height/2));
            count--;
            spriteNode.zPosition = 100;
            spriteNode.position.x = CGFloat(player.x!)
            spriteNode.position.y = CGFloat(player.y!)
            player.sprite = spriteNode
            self.players.append(player)
            self.addChild(player.sprite!)
            
            //----------------------------------------------------------------------------
            // Creates the Player Body Joints
            //----------------------------------------------------------------------------
            
            let armLeftJoint = SKPhysicsJointPin.jointWithBodyA(body.physicsBody!, bodyB: armLeft.physicsBody!, anchor:spriteNode.position + CGPointMake(-aux2.width-5,-(aux1 + aux2).height+15))
            body.scene!.physicsWorld.addJoint(armLeftJoint)
            
            
            let armRightJoint = SKPhysicsJointPin.jointWithBodyA(body.physicsBody!, bodyB: armRight.physicsBody!, anchor:spriteNode.position + CGPointMake(aux2.width+5,-(aux1 + aux2).height+15))
            body.scene?.physicsWorld.addJoint(armRightJoint)
            
            let legLeftJoint = SKPhysicsJointPin.jointWithBodyA(body.physicsBody!, bodyB: legLeft.physicsBody!, anchor:spriteNode.position + CGPointMake(-aux2.width/2.5,-aux1.height-body.size.height))
            body.scene?.physicsWorld.addJoint(legLeftJoint)
            
            let legRightJoint = SKPhysicsJointPin.jointWithBodyA(body.physicsBody!, bodyB: legRight.physicsBody!, anchor:spriteNode.position + CGPointMake(aux2.width/2.5, -aux1.height-body.size.height))
            body.scene?.physicsWorld.addJoint(legRightJoint)
            
            let headJoint = SKPhysicsJointPin.jointWithBodyA(body.physicsBody!, bodyB: helmet.physicsBody!, anchor:spriteNode.position + helmet.position)
            body.scene?.physicsWorld.addJoint(headJoint)
            
            let faceJoint = SKPhysicsJointPin.jointWithBodyA(helmet.physicsBody!, bodyB: head.physicsBody!, anchor:spriteNode.position + head.position)
            body.scene?.physicsWorld.addJoint(faceJoint)
            
            let reflexJoint = SKPhysicsJointPin.jointWithBodyA(helmet.physicsBody!, bodyB: helmetReflex.physicsBody!, anchor:spriteNode.position + helmetReflex.position)
            body.scene?.physicsWorld.addJoint(reflexJoint)
            
            //----------------------------------------------------------------------------
            // sets the player's physics
            //----------------------------------------------------------------------------
            
            //            player.sprite!.physicsBody = SKPhysicsBody(rectangleOfSize: spriteNode.size)
            //            player.sprite!.physicsBody?.dynamic = true
            //            player.sprite!.physicsBody?.categoryBitMask = self.playerCategory
            //            player.sprite!.physicsBody?.contactTestBitMask = self.spikeCategory
            //            player.sprite!.physicsBody?.collisionBitMask = 0
            //            player.sprite!.physicsBody?.usesPreciseCollisionDetection = true
            
            for child in spriteNode.children{
                child.physicsBody?.dynamic = true;
                child.physicsBody?.categoryBitMask = self.playerCategory;
            }
            
        }
    }
    
    func playerColidedWithSpike(player : SKNode, spike : SKNode){
        self.explodePuff(player.parent!)
    }
    
    func playerColidedWihtPlayer(playerA : SKNode, playerB : SKNode){
        //playerB.physicsBody.applyForce()
    }
    
    func setupSpikes(){
        for i in 0...Int(self.view!.frame.width/partsAtlas.textureNamed("spike").size().width){
            let spike = SKSpriteNode(texture: partsAtlas.textureNamed("spike"));
            spike.position = CGPointMake(CGFloat(i)*partsAtlas.textureNamed("spike").size().width - self.view!.frame.width/2, -partsAtlas.textureNamed("spike").size().height + partsAtlas.textureNamed("spike").size().height);
            spikeWallDown.addChild(spike)
        }
        
        for i in 0...Int(self.view!.frame.width/partsAtlas.textureNamed("spike").size().width){
            let spike = SKSpriteNode(texture: partsAtlas.textureNamed("spike"));
            spike.position = CGPointMake(CGFloat(i)*partsAtlas.textureNamed("spike").size().width  - self.view!.frame.width/2, partsAtlas.textureNamed("spike").size().height - partsAtlas.textureNamed("spike").size().height);
            spike.zRotation = CGFloat(3.14159265);
            spikeWallTop.addChild(spike)
        }
        
        for i in 0...Int(self.view!.frame.width/partsAtlas.textureNamed("spike").size().width){
            let spike = SKSpriteNode(texture: partsAtlas.textureNamed("spike"));
            spike.position = CGPointMake(partsAtlas.textureNamed("spike").size().width - partsAtlas.textureNamed("spike").size().height, CGFloat(i)*partsAtlas.textureNamed("spike").size().height - self.view!.frame.height/2);
            spike.zRotation = CGFloat(1.57079633);
            spikeWallRight.addChild(spike)
        }
        
        for i in 0...Int(self.view!.frame.height/partsAtlas.textureNamed("spike").size().height){
            let spike = SKSpriteNode(texture: partsAtlas.textureNamed("spike"));
            spike.position = CGPointMake(-partsAtlas.textureNamed("spike").size().width + partsAtlas.textureNamed("spike").size().height, CGFloat(i)*partsAtlas.textureNamed("spike").size().height - self.view!.frame.height/2);
            spike.zRotation = CGFloat(-1.57079633);
            spikeWallLeft.addChild(spike);
        }
        
        // CONFIGURAÇÃO DA FISICA
        spikeWallDown.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: CGFloat(self.view!.frame.width), height: partsAtlas.textureNamed("spike").size().height))
        //spikeWallDown.physicsBody?.
        spikeWallDown.physicsBody?.dynamic = true
        spikeWallDown.physicsBody?.categoryBitMask = self.spikeCategory
        spikeWallDown.physicsBody?.contactTestBitMask = self.playerCategory
        spikeWallDown.physicsBody?.collisionBitMask = 0
        spikeWallDown.physicsBody?.affectedByGravity = false
        spikeWallDown.position = CGPointMake(CGFloat(self.view!.frame.width/2), -partsAtlas.textureNamed("spike").size().height)

        spikeWallTop.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: CGFloat(self.view!.frame.width), height: partsAtlas.textureNamed("spike").size().height))
        spikeWallTop.physicsBody?.dynamic = true
        spikeWallTop.physicsBody?.categoryBitMask = self.spikeCategory
        spikeWallTop.physicsBody?.contactTestBitMask = self.playerCategory
        spikeWallTop.physicsBody?.collisionBitMask = 0
        spikeWallTop.physicsBody?.affectedByGravity = false
        spikeWallTop.position = CGPointMake(CGFloat(self.view!.frame.width/2), CGFloat(self.view!.frame.height + partsAtlas.textureNamed("spike").size().height))
        
        spikeWallRight.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: partsAtlas.textureNamed("spike").size().height, height: CGFloat((self.view?.frame.size.height)!)))
        spikeWallRight.physicsBody?.dynamic = true
        spikeWallRight.physicsBody?.categoryBitMask = self.spikeCategory
        spikeWallRight.physicsBody?.contactTestBitMask = self.playerCategory
        spikeWallRight.physicsBody?.collisionBitMask = 0
        spikeWallRight.physicsBody?.affectedByGravity = false
        spikeWallRight.position = CGPointMake(self.view!.frame.width + partsAtlas.textureNamed("spike").size().height, self.view!.frame.height/2)
        
        spikeWallLeft.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: partsAtlas.textureNamed("spike").size().height, height: CGFloat((self.view?.frame.size.height)!)))
        spikeWallLeft.physicsBody?.dynamic = true
        spikeWallLeft.physicsBody?.categoryBitMask = self.spikeCategory
        spikeWallLeft.physicsBody?.contactTestBitMask = self.playerCategory
        spikeWallLeft.physicsBody?.collisionBitMask = 0
        spikeWallLeft.physicsBody?.affectedByGravity = false
        spikeWallLeft.position = CGPointMake(-partsAtlas.textureNamed("spike").size().height, self.view!.frame.height/2)
        
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
            for p in self.players{
                if data.userInfo!["peerID"] as! String == p.playerName{
                    if data.userInfo!["actionReceived"] as! String == PlayerAction.PuffGrow.rawValue{
                        p.sprite!.xScale += 0.1
                        p.sprite!.yScale += 0.1
                        p.sprite?.childNodeWithName("head")?.physicsBody?.mass =  CGFloat(5) + (p.sprite?.childNodeWithName("head")?.physicsBody?.mass)!
                    }
                    if data.userInfo!["directionX"]! as! String == PlayerAction.Left.rawValue{
                        if p.sprite?.position.x > 0{
                            p.sprite?.childNodeWithName("head")?.physicsBody?.applyImpulse(CGVectorMake(-250, 0))
                            //p.sprite?.position.x = CGFloat((p.sprite?.position.x)!-5)
                        }
                    }else{
                        if p.sprite?.position.x < self.view!.frame.width{
                            p.sprite?.childNodeWithName("head")?.physicsBody?.applyImpulse(CGVectorMake(+250, 0))
                            //p.sprite?.position.x = CGFloat((p.sprite?.position.x)!+5)
                        }
                    }
                    if data.userInfo!["directionY"] as! String == PlayerAction.Up.rawValue{
                        if p.sprite?.position.y < self.view!.frame.height{
                            p.sprite?.childNodeWithName("head")?.physicsBody?.applyImpulse(CGVectorMake(0, +250))
                            //p.sprite?.position.y = CGFloat((p.sprite?.position.y)!+5)
                        }
                    }else{
                        if p.sprite?.position.y > 0{
                           p.sprite?.childNodeWithName("head")?.physicsBody?.applyImpulse(CGVectorMake(0, -250))
                           //p.sprite?.position.y = CGFloat((p.sprite?.position.y)!-5)
                        }
                    }
                }
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
    
    func spawnStars (){
        let star = SKSpriteNode(texture: randomStars())
        star.zPosition = -2
        let y = arc4random_uniform(UInt32((self.view?.frame.height)!))
        star.position = CGPointMake(CGFloat((self.view?.frame.width)! + 5), CGFloat(y))
        star.setScale(CGFloat.random(min: 0.10, max: 0.9))
        star.zRotation = CGFloat.random(min: 1, max: 4)
        self.addChild(star)
        
        let starMovement = SKAction.moveBy(CGVector(dx: -(self.view?.frame.width)!, dy: star.position.y + CGFloat.random(min: -10, max: 10)), duration: NSTimeInterval(CGFloat.random(min: 0.8, max: 2.5)))
        
        star.runAction(starMovement) { () -> Void in
            star.removeFromParent()
        }
    }
    
    func randomStars()->SKTexture{
    let a = arc4random_uniform(5)
        let starAtlas = SKTextureAtlas(named: "babiesAssetsBundle")
        switch a{
        case 1 : return starAtlas.textureNamed("bigstar")
        case 2 : return starAtlas.textureNamed("comet")
        case 3 : return starAtlas.textureNamed("planet")
        case 4 : return starAtlas.textureNamed("planetRing")
        default: return starAtlas.textureNamed("smallStar")
        }
    }
    
    func setupBackground(){
        let spawn = SKAction.runBlock({( ) in self.spawnStars()})
        let delay = SKAction.waitForDuration(0.8, withRange: 1)
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnDelayForever)
        let background = SKSpriteNode(imageNamed: "iPad Landscape")
        background.zPosition = -1
        background.position = CGPointMake((self.view?.frame.width)!/2, (self.view?.frame.height)!/2)
        self.addChild(background)
        self.backgroundColor = UIColor.blackColor()
        
        // particles
        
        weak var particles = StarEmiter(fileNamed: "starsParticle")
        particles?.position = CGPointMake((self.view?.frame.width)!+30, (self.view?.frame.height)!/2)
        particles?.zPosition = -2
        self.addChild(particles!)
    }
    
    func setupTowers(){
        let a = SKTexture(imageNamed: "raioTower")
        let towerSizeFactor = CGFloat((a.size().height)/2)
        let raiosVerticais = [SKTexture(imageNamed: "raiov1"),SKTexture(imageNamed: "raiov2"),SKTexture(imageNamed: "raiov3")]
        let raiosHorizontais = [SKTexture(imageNamed: "raio1"),SKTexture(imageNamed: "raio2"),SKTexture(imageNamed: "raio3")]
        
        let positions = [CGPointMake(towerSizeFactor, towerSizeFactor),CGPointMake(towerSizeFactor, (self.view?.frame.height)! - towerSizeFactor), CGPointMake((self.view?.frame.width)! - towerSizeFactor, (self.view?.frame.height)! - towerSizeFactor), CGPointMake((self.view?.frame.width)! - towerSizeFactor, towerSizeFactor)]
        for i in 0...3{
            let tower = SKSpriteNode(imageNamed: "raioTower")
            tower.position = positions[i]
            tower.zPosition = 1;
            self.addChild(tower)
        }
        
        //######################################################
        //# Cria os raios                                      #
        //######################################################
        
        let dissappear = SKAction.hide()
        let waitTime = SKAction.waitForDuration(0.5)
        let appear = SKAction.unhide()
        let initialHorizontal = SKTexture(imageNamed: "raio1")
        let initialVertical = SKTexture(imageNamed: "raiov1")
        
        let spriteRaio1 = SKSpriteNode(texture: initialHorizontal)
        spriteRaio1.position = CGPointMake((self.view?.frame.width)!/2, positions[0].y)
        spriteRaio1.zPosition = 0
        self.addChild(spriteRaio1)
        
        let spriteRaio2 = SKSpriteNode(texture: initialVertical)
        spriteRaio2.zPosition = 0
        spriteRaio2.position = CGPointMake(positions[0].x, (self.view?.frame.height)!/2)
        self.addChild(spriteRaio2)
        
        let spriteRaio3 = SKSpriteNode(texture: initialHorizontal)
        spriteRaio3.zPosition = 0
        spriteRaio3.position = CGPointMake((self.view?.frame.width)!/2, positions[1].y)
        self.addChild(spriteRaio3)
        
        let spriteRaio4 = SKSpriteNode(texture: initialVertical)
        spriteRaio4.zPosition = 0
        spriteRaio4.position = CGPointMake(positions[3].x, (self.view?.frame.height)!/2)
        self.addChild(spriteRaio4)
        
        let raio1 = SKAction.animateWithTextures(raiosHorizontais, timePerFrame: 0.2)
        let sequence1 = SKAction.sequence([raio1,dissappear,waitTime,appear])
        spriteRaio1.runAction(SKAction.repeatActionForever(sequence1))
        
        let raio2 = SKAction.animateWithTextures(raiosVerticais, timePerFrame: 0.2)
        let sequence2 = SKAction.sequence([raio2,dissappear,waitTime,appear])
        spriteRaio2.runAction(SKAction.repeatActionForever(sequence2))
        
        let raio3 = SKAction.animateWithTextures(raiosHorizontais, timePerFrame: 0.2)
        let sequence3 = SKAction.sequence([raio3,dissappear,waitTime,appear])
        spriteRaio3.runAction(SKAction.repeatActionForever(sequence3))
        
        let raio4 = SKAction.animateWithTextures(raiosVerticais, timePerFrame: 0.2)
        let sequence4 = SKAction.sequence([raio4,dissappear,waitTime,appear])
        spriteRaio4.runAction(SKAction.repeatActionForever(sequence4))
        
        //######################################################
        //# Coisas da fisica dos raios                         #
        //######################################################
        
        // CONFIGURAÇÃO DA FISICA
        spriteRaio1.physicsBody = SKPhysicsBody(rectangleOfSize: spriteRaio1.size - spriteRaio1.size.height/2)
        spriteRaio1.physicsBody?.dynamic = true
        spriteRaio1.physicsBody?.categoryBitMask = self.spikeCategory
        spriteRaio1.physicsBody?.contactTestBitMask = self.playerCategory
        spriteRaio1.physicsBody?.collisionBitMask = 0
        spriteRaio1.physicsBody?.affectedByGravity = false

        
        spriteRaio2.physicsBody = SKPhysicsBody(rectangleOfSize: spriteRaio2.size - spriteRaio1.size.height/2)
        spriteRaio2.physicsBody?.dynamic = true
        spriteRaio2.physicsBody?.categoryBitMask = self.spikeCategory
        spriteRaio2.physicsBody?.contactTestBitMask = self.playerCategory
        spriteRaio2.physicsBody?.collisionBitMask = 0
        spriteRaio2.physicsBody?.affectedByGravity = false
        
        spriteRaio3.physicsBody = SKPhysicsBody(rectangleOfSize: spriteRaio3.size - spriteRaio1.size.height/2)
        spriteRaio3.physicsBody?.dynamic = true
        spriteRaio3.physicsBody?.categoryBitMask = self.spikeCategory
        spriteRaio3.physicsBody?.contactTestBitMask = self.playerCategory
        spriteRaio3.physicsBody?.collisionBitMask = 0
        spriteRaio3.physicsBody?.affectedByGravity = false
        
        spriteRaio4.physicsBody = SKPhysicsBody(rectangleOfSize: spriteRaio4.size - spriteRaio1.size.height/2)
        spriteRaio4.physicsBody?.dynamic = true
        spriteRaio4.physicsBody?.categoryBitMask = self.spikeCategory
        spriteRaio4.physicsBody?.contactTestBitMask = self.playerCategory
        spriteRaio4.physicsBody?.collisionBitMask = 0
        spriteRaio4.physicsBody?.affectedByGravity = false

    }

    override func update(currentTime: NSTimeInterval) {
        //once per frame
    }
    
    override func didFinishUpdate() {

    }
}