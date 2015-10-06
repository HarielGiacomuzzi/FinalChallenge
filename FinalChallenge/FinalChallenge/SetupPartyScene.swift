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
    
    
    weak var viewController : PartyModeViewControllerIPAD!
    
    // set buttons and nodes
    var banner : SKSpriteNode?
    var turns : SKSpriteNode?
    var connect : SKSpriteNode?
    var go : SKSpriteNode?
    var numberOfTurns : SKLabelNode?
    
    // characters nodes
    let char1 : SKSpriteNode = SKSpriteNode(imageNamed: "paladinCard")
    let char2 : SKSpriteNode = SKSpriteNode(imageNamed: "rangerCard")
    let char3 : SKSpriteNode = SKSpriteNode(imageNamed: "thiefCard")
    let char4 : SKSpriteNode = SKSpriteNode(imageNamed: "wizardCard")
    
    var charInitialPosition : CGFloat?

    // set textures
    let yellowButton : SKTexture = SKTexture(imageNamed: "yellowButton")
    let yellowButtonOff : SKTexture = SKTexture(imageNamed: "yellowButtonOff")
    let redBanner : SKTexture = SKTexture(imageNamed: "redTitle")
    let greenButton : SKTexture = SKTexture(imageNamed: "greenButtonOn")
    let greenButtonOff : SKTexture = SKTexture(imageNamed: "greenButtonOff")
    let yellowTurnsOn : SKTexture = SKTexture(imageNamed: "turnsOn")
    let yellowTurnsOff : SKTexture = SKTexture(imageNamed: "turnsOff")

    let arrowOn : SKTexture = SKTexture(imageNamed: "arrowButtonOn")
    let arrowOff : SKTexture = SKTexture(imageNamed: "arrowButtonOff")
    
    
    
    // colisions
    let boundaryCategoryMask: UInt32 =  0x1 << 1
    let fallingCategoryMask: UInt32 =  0x1 << 2

    var turnCounter = 5
    
    
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
        turns = SKSpriteNode(texture: yellowTurnsOn, size: yellowTurnsOn.size())
        self.addChild(turns!)
        turns!.position = CGPoint(x: self.frame.width * 0.35, y: banner!.position.y - 110)
        turns?.zPosition = 4
        
        // set the connect players button
        
        connect = SKSpriteNode(texture: yellowButton, size: yellowButton.size())
        self.addChild(connect!)
        connect!.position = CGPoint(x: turns!.position.x, y: turns!.position.y - 90)
        connect?.zPosition = 4
        
        // set the GO BUTTON
        go = SKSpriteNode(texture: greenButton, size: greenButton.size())
        self.addChild(go!)
        go!.position = CGPoint(x: self.frame.width * 0.75, y: (connect!.position.y + turns!.position.y)/2)
        go!.name = "goButton"
        go?.zPosition = 4
        
        // set the turn controll buttons

        
        numberOfTurns = SKLabelNode(fontNamed: "Helvetica Neue")
        numberOfTurns?.text = "max turns : 5"
        numberOfTurns?.fontSize = 30
        numberOfTurns?.position = CGPoint(x: turns!.position.x, y: turns!.position.y)
        numberOfTurns?.zPosition = 5
        GameManager.sharedInstance.totalGameTurns = self.turnCounter
        self.addChild(numberOfTurns!)
        
        
        //setup background
        let background = SKTexture(imageNamed: "setupBG")
        let bg = SKSpriteNode(texture: background, size: background.size())
        self.addChild(bg)
        bg.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        bg.zPosition = 0
        self.backgroundColor = UIColor.whiteColor()
        
        //setup particles
        
        let globParticles = SetupParticle.fromFile("setupParticle1")
        globParticles!.position = CGPointMake(self.frame.width/2, self.frame.height + 10)
        self.addChild(globParticles!)
        globParticles?.zPosition = 1

        
        
      /*let spawn = SKAction.runBlock({() in self.spawnItem()})
        
        let delay = SKAction.waitForDuration(0.7, withRange: 1.4)
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)*/
        
        
        //set boundary
        let boundary : SKNode = SKNode()
        boundary.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: self.frame.width, height: 1))
        boundary.physicsBody?.dynamic = false
        boundary.physicsBody?.categoryBitMask = boundaryCategoryMask
        boundary.position = CGPoint(x: self.frame.width/2, y: -200)
        self.addChild(boundary)
        
        // set characters
        
        charInitialPosition = (char1.size.height/2)*(-1)
        
        char1.position = CGPoint(x: self.frame.width*0.2, y: charInitialPosition!)
        char1.setScale(0.2)
        char1.zPosition = 6
        char1.setScale(0.5)
        self.addChild(char1)
        /*
        let shadow1 = SKSpriteNode(imageNamed: "player1")
        shadow1.blendMode = SKBlendMode(rawValue: 0)!
        shadow1.colorBlendFactor = 1
        shadow1.color = SKColor.blackColor()
        shadow1.alpha = 0.25
        char1.addChild(shadow1)
        shadow1.zPosition = -1
        shadow1.position = CGPoint(x: 5, y: -10)
        */
    
      
        char2.position = CGPoint(x: self.frame.width * 0.4, y: charInitialPosition!)
        char2.setScale(0.2)
        char2.zPosition = 6
        self.addChild(char2)
        char2.setScale(0.5)
        /*
        let shadow2 = SKSpriteNode(imageNamed: "player2")
        shadow2.blendMode = SKBlendMode(rawValue: 0)!
        shadow2.colorBlendFactor = 1
        shadow2.color = SKColor.blackColor()
        shadow2.alpha = 0.25
        char2.addChild(shadow2)
        shadow2.zPosition = -1
        shadow2.position = CGPoint(x: 5, y: -10)
*/
        
        
        char3.position = CGPoint(x: self.frame.width*0.6, y: charInitialPosition!)
        char3.setScale(0.2)
        char3.zPosition = 6
        char3.setScale(0.5)
        self.addChild(char3)
        
        char4.position = CGPoint(x: self.frame.width*0.8, y: charInitialPosition!)
        char4.setScale(0.2)
        char4.zPosition = 6
        char4.setScale(0.5)
        self.addChild(char4)
 
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first as UITouch!
        let location: CGPoint = touch.locationInNode(self)

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
        
        if(turns!.containsPoint(location)){
            turns!.texture = yellowTurnsOff
        }else{
            turns!.texture = yellowTurnsOn
        }
        
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first as UITouch!
        let location: CGPoint = touch.locationInNode(self)
        
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
        
        
        if(turns!.containsPoint(location)){
            turns!.texture = yellowTurnsOff
        }else{
            turns!.texture = yellowTurnsOn
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {

        go?.texture = greenButton
        connect?.texture = yellowButton
        turns?.texture = yellowTurnsOn

        
        
        let touch: UITouch = touches.first as UITouch!
        let location: CGPoint = touch.locationInNode(self)
        
        if(go!.containsPoint(location)){
            print("apertei o botao de GO")
            var canGo = false
            for p in GameManager.sharedInstance.players{
                if p.avatar == nil {
                    canGo = false
                    break
                }else{
                    canGo = true
                }
            }
            if canGo{
                self.view?.presentScene(nil)
                viewController.turns = turnCounter
                viewController.gotoBoardGame()
            }
        }
        if(connect!.containsPoint(location)){
            print("apertei o botao de CONNECT")
            viewController.ConnectPlayers()
            
        }

        if(turns!.containsPoint(location)){
            turnCounter = turnCounter + 5
            if turnCounter > 30 {
                turnCounter = 5
            }
            
            numberOfTurns?.text = "max turns : \(turnCounter)"
            GameManager.sharedInstance.totalGameTurns = turnCounter
        }

    }
    
    func spawnItem(){
       
        let effectsNode = SKEffectNode()
        let filter = CIFilter(name: "CIGaussianBlur")
        // Set the blur amount. Adjust this to achieve the desired effect
        let blurAmount = CGFloat.random(min: 0, max: 20)
        filter!.setValue(blurAmount, forKey: kCIInputRadiusKey)
        
        effectsNode.filter = filter
        effectsNode.position = self.view!.center
        effectsNode.blendMode = .Alpha
        self.addChild(effectsNode)
        
        
        let itemVal = CGFloat.random(min: 0.6, max: 3.4)
        let intItemval = Int(round(itemVal))
        let itemName = "item\(intItemval)"
        
        let texture = SKTexture(imageNamed: itemName)
        let sprite = SKSpriteNode(texture: texture)
        let diff = CGFloat.random(min: 0.5, max: 1)
        sprite.size = CGSize(width: sprite.size.width * diff, height: sprite.size.height * diff)
        effectsNode.addChild(sprite)
        
        let pos = CGFloat.random(min: 0, max: 1024)
        effectsNode.position = CGPoint(x: pos, y: self.frame.height+50)

        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.height/2)
        let angle = CGFloat.random(min: 0.1, max: 0.6)
        sprite.physicsBody?.applyAngularImpulse(angle  * sprite.size.width * 0.01)
        sprite.physicsBody?.affectedByGravity = true
        sprite.zPosition = 2
        sprite.physicsBody?.categoryBitMask = fallingCategoryMask
        sprite.physicsBody?.contactTestBitMask = boundaryCategoryMask
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == fallingCategoryMask {
            let filter = contact.bodyA.node?.parent
            contact.bodyA.node?.removeFromParent()
            filter?.removeFromParent()
        }
        
        if contact.bodyB.categoryBitMask == fallingCategoryMask {
            let filter = contact.bodyB.node?.parent
            contact.bodyB.node?.removeFromParent()
            filter?.removeFromParent()
        }
    }
    
    func riseCharacter(char : SKSpriteNode){
        
        char.position = CGPoint(x: char.position.x, y: charInitialPosition!)
        
        
        let location = char.position
        
        let action = SKAction.moveToY(location.y + char.size.height, duration: 0.7) // Or however much time you want to the action to run.
        action.timingMode = .EaseInEaseOut
        
        char.runAction(action)
    }
    
    deinit{
        print("SetupScene do Ipad foi retirada")
    }
    
    
}
