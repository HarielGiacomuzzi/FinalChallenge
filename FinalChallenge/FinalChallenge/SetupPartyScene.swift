//
//  SetupPartyScene.swift
//  FinalChallenge
//
//  Created by Jonathas Hernandes on 08/09/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import SpriteKit

class SetupPartyScene: SKScene, SKPhysicsContactDelegate {
    
    // set buttons and nodes
    var banner : SKSpriteNode?
    var turns : SKSpriteNode?
    var connect : SKSpriteNode?
    var go : SKSpriteNode?
    
    
    
    // set textures
    let yellowButton : SKTexture = SKTexture(imageNamed: "yellowButton")
    let yellowButtonOff : SKTexture = SKTexture(imageNamed: "yellowButtonOff")
    let redBanner : SKTexture = SKTexture(imageNamed: "redTitle")
    let greenButton : SKTexture = SKTexture(imageNamed: "greenButtonOn")
    let greenButtonOff : SKTexture = SKTexture(imageNamed: "greenButtonOff")
    let yellowBanner : SKTexture = SKTexture(imageNamed: "yellowBanner")
    
    
    override func update(currentTime: NSTimeInterval) {

        
    }
    
    override func didMoveToView(view: SKView) {
        
        setObjects()
        
        self.physicsWorld.gravity = CGVectorMake( 0.0, -5.0 )
        self.physicsWorld.contactDelegate = self
        
        
        
    }
    
    func setObjects(){

        

        
        // set the red SETUP GAME banner
        banner = SKSpriteNode(texture: redBanner, size: redBanner.size() )
        self.addChild(banner!)
        banner!.position = CGPoint(x: self.frame.width/2, y: (self.frame.height)*0.85)
        banner?.zPosition = 4
       
        // set the turn select banners
        turns = SKSpriteNode(texture: yellowBanner, size: yellowButton.size())
        self.addChild(turns!)
        turns!.position = CGPoint(x: self.frame.width * 0.35, y: banner!.position.y - 110)
        turns?.zPosition = 4
        
        // set the connect players button
        
        connect = SKSpriteNode(texture: yellowButton, size: yellowButton.size())
        self.addChild(connect!)
        connect!.position = CGPoint(x: turns!.position.x, y: turns!.position.y - 80)
        connect?.zPosition = 4
        
        // set the GO BUTTON
        go = SKSpriteNode(texture: greenButton, size: greenButton.size())
        self.addChild(go!)
        go!.position = CGPoint(x: self.frame.width * 0.75, y: (connect!.position.y + turns!.position.y)/2)
        go!.name = "goButton"
        go?.zPosition = 4
        
        //setup background
        let background = SKTexture(imageNamed: "setupBG")
        let bg = SKSpriteNode(texture: background, size: background.size())
        self.addChild(bg)
        bg.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        bg.zPosition = 0
        self.backgroundColor = UIColor.whiteColor()
        
        //setup particles
        
        var globParticles = SetupParticle.fromFile("setupParticle1")
        globParticles!.position = CGPointMake(self.frame.width/2, self.frame.height + 10)
        self.addChild(globParticles!)
        globParticles?.zPosition = 1

        
        
        let spawn = SKAction.runBlock({() in self.spawnSword()})
        
        let delay = SKAction.waitForDuration(1, withRange: 1)
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)
        
        
        
        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch: UITouch = touches.first as! UITouch
        var location: CGPoint = touch.locationInNode(self)

        if(go!.containsPoint(location)){
            go!.texture = greenButtonOff
        }else{
            go!.texture = greenButton
        }
        
        
        
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch: UITouch = touches.first as! UITouch
        var location: CGPoint = touch.locationInNode(self)
        
        if(go!.containsPoint(location)){
            go!.texture = greenButtonOff
        }else{
            go!.texture = greenButton
        }
        
        if(connect!.containsPoint(location)){
            connect!.texture = yellowButtonOff
        }else{
            connect!.texture = yellowButton
        }

    
    
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        go?.texture = greenButton
        connect?.texture = yellowButton
        
        var touch: UITouch = touches.first as! UITouch
        var location: CGPoint = touch.locationInNode(self)
        
        if(go!.containsPoint(location)){
            println("apertei o botao de GO")
        }
        if(connect!.containsPoint(location)){
            println("apertei o botao de CONNECT")
        }

        
        
    }
    
    func spawnSword(){
       
        
        let effectsNode = SKEffectNode()
        let filter = CIFilter(name: "CIGaussianBlur")
        // Set the blur amount. Adjust this to achieve the desired effect
        let blurAmount = CGFloat.random(min: 0, max: 20)
        filter.setValue(blurAmount, forKey: kCIInputRadiusKey)
        
        effectsNode.filter = filter
        effectsNode.position = self.view!.center
        effectsNode.blendMode = .Alpha
        self.addChild(effectsNode)
        
        let texture = SKTexture(imageNamed: "sword")
        let sprite = SKSpriteNode(texture: texture)
        let diff = CGFloat.random(min: 0.5, max: 1)
        sprite.size = CGSize(width: sprite.size.width * diff, height: sprite.size.height * diff)
        effectsNode.addChild(sprite)
        
        let pos = CGFloat.random(min: 0, max: 1024)
        effectsNode.position = CGPoint(x: pos, y: self.frame.height)

     //   sprite.position = CGPoint(x: pos, y: self.frame.height)
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: 2)
        let angle = CGFloat.random(min: 0, max: 0.10)
        sprite.physicsBody?.applyAngularImpulse(angle)
        sprite.physicsBody?.affectedByGravity = true
        sprite.zPosition = 2

        
    }
    
    

    
    
}
