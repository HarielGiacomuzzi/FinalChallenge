//
//  PartyModeScene.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 9/1/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

private let movableAvatarNodeName = "movable"

class PartyModeScene: SKScene, SKPhysicsContactDelegate {
    
    weak var viewController : iPhonePlayerViewController?
    let background = SKSpriteNode(imageNamed: "board_beta")
    var selectedNode = SKSpriteNode()
    var playerSpriteNodeArray = [SKSpriteNode()]
    var beginPosition = CGPoint()
    let imageNames = ["paladinCard", "rangerCard", "thiefCard", "wizardCard"]
    var takenAvatar = [String()]
    var takenFlag = Bool()
    var arrayAvatarSprite = [SKSpriteNode()]
    var gestureRecognizer : UIPanGestureRecognizer!
    var canSelectAvatar = false
    
    var banner : SKSpriteNode?
    var turns : SKSpriteNode?
    var connect : SKSpriteNode?
    var go : SKSpriteNode?
    var numberOfTurns : SKLabelNode?
    var tutorialNode : SKSpriteNode?
    
    var charInitialPosition : CGFloat?
    
    // colisions
    let boundaryCategoryMask: UInt32 =  0x1 << 1
    let fallingCategoryMask: UInt32 =  0x1 << 2
    
    override init(size: CGSize) {
        super.init(size: size)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_IphoneGameSetup", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeView:", name: "ConnectionManager_IphoneChangeView", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "avatarIsSelectable:", name: "ConnectionManager_canSelectAvatar", object: nil);
        
        banner = SKSpriteNode(imageNamed: "setUpBanner")
        self.addChild(banner!)
        banner!.position = CGPoint(x: self.frame.width/2, y: (self.frame.height)*0.85)
        banner!.size.height = banner!.size.height/2
        banner?.zPosition = 4
        banner?.name = "banner"
        
        let titleLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        titleLabel.text = "Choose your Character"
        titleLabel.name = "label"
        titleLabel.zPosition = 5
        titleLabel.position = CGPoint(x: self.frame.width/2, y: (self.frame.height)*0.85)
        self.addChild(titleLabel)
        
        let back = SKLabelNode(fontNamed: "GillSans-Bold") // will be a texture probably
        back.name = "back"
        back.text = "Back"
        back.position = CGPoint(x: self.frame.width/10, y: (self.frame.height)*0.85)
        back.zPosition = 5
        self.addChild(back)
        
        
        let background = SKTexture(imageNamed: "setupBG")
        let bg = SKSpriteNode(texture: background, size: background.size())
        self.addChild(bg)
        bg.name = "bg"
        bg.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        bg.zPosition = 0
        self.backgroundColor = UIColor.whiteColor()
    
        
        for i in 0..<imageNames.count {
            let imageName = imageNames[i]
            
            let sprite = SKSpriteNode(imageNamed: imageName)
            
            switch(imageName){
            case "paladinCard" : sprite.name = "knight"
            case "rangerCard" : sprite.name = "ranger"
            case "thiefCard" : sprite.name = "thief"
            case "wizardCard" : sprite.name = "wizard"
            default : break
            }
    
            //sprite.size = CGSize(width: 50, height: 50)
            
            sprite.setScale(0.3)
            
            let offsetFraction = (CGFloat(i) + 1.0)/(CGFloat(imageNames.count) + 1.0)
            
            sprite.position = CGPoint(x: size.width * offsetFraction, y: size.height/2.2)
            
            sprite.zPosition = 100
            
            arrayAvatarSprite.append(sprite)
            
            self.addChild(sprite)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        gestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanFrom:"))
        self.view!.addGestureRecognizer(gestureRecognizer)
        
        setObjects()
        
        self.physicsWorld.gravity = CGVectorMake( 0.0, -5.0 )
        self.physicsWorld.contactDelegate = self
        
        self.setTutorialScene()
    }
    
    func setTutorialScene(){
        tutorialNode = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: self.frame.width/1.3, height: self.frame.height/1.3))
        tutorialNode?.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        tutorialNode?.zPosition = 10000
        tutorialNode?.name = "tutorial"
        
        let tutorialText = SKLabelNode(fontNamed: "GillSans-Bold")
        tutorialText.name = "tutorial label"
        tutorialText.text = "Tutorial"
        tutorialText.position.y = tutorialNode!.frame.height/2.5
        tutorialText.zPosition = 11000
        
        let text = SKLabelNode(fontNamed: "GillSans-Bold")
        text.name = "tutorial label"
        text.text = "Two or more Players"
        text.position.y = tutorialNode!.frame.height/3.2
        text.zPosition = 11000
        text.fontSize = 20
        
        let sprite1 = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: tutorialNode!.frame.width/2, height: tutorialNode!.frame.height/5))
        sprite1.name = "Tutorial sprite"
        sprite1.position.y = tutorialNode!.frame.height/5
        sprite1.zPosition = 11000
        
        tutorialNode?.addChild(tutorialText)
        tutorialNode?.addChild(text)
        tutorialNode?.addChild(sprite1)
        self.addChild(tutorialNode!)
    }
    
    override func willMoveFromView(view: SKView) {
        view.removeGestureRecognizer(gestureRecognizer)
    }
    
    func handlePanFrom(recognizer : UIPanGestureRecognizer) {
        if recognizer.state == .Began {
            var touchLocation = recognizer.locationInView(recognizer.view)
            touchLocation = self.convertPointFromView(touchLocation)
            self.selectNodeForTouch(touchLocation)
            
        } else if recognizer.state == .Changed {
            var translation = recognizer.translationInView(recognizer.view!)
            translation = CGPoint(x: translation.x, y: -translation.y)
            
            self.panForTranslation(translation)
            
            recognizer.setTranslation(CGPointZero, inView: recognizer.view)
        } else if recognizer.state == .Ended {
            for sp in imageNames{
                var aux = sp
                switch(aux){
                case "paladinCard" : aux = "knight"
                case "rangerCard" : aux = "ranger"
                case "thiefCard" : aux = "thief"
                case "wizardCard" : aux = "wizard"
                default : break
                }
                if selectedNode.name != aux {
                    let scrollDuration = 0.2
                    let velocity = recognizer.velocityInView(recognizer.view)
                    _ = selectedNode.position
                
                    // This just multiplies your velocity with the scroll duration.
                    _ = CGPoint(x: velocity.x * CGFloat(scrollDuration), y: velocity.y * CGFloat(scrollDuration))
                    selectedNode.removeAllActions()
                }else{
                    if selectedNode.position.y > self.frame.height/1.2{
                        for ta in takenAvatar{
                            if ta != aux{
                                takenFlag = false
                            } else {
                                takenFlag = true
                                break
                            }
                        }
                        if takenFlag == false{
                            self.sendDataToIpad()
                        } else {
                            self.selectedNode.position = self.beginPosition
                        }
                    } else {
                        self.selectedNode.position = self.beginPosition
                    }
                }
            }
            
        }
    }
    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(degree / 180.0 * M_PI)
    }
    
    func selectNodeForTouch(touchLocation : CGPoint) {
        // 1
        let touchedNode = self.nodeAtPoint(touchLocation)
    
        if touchedNode is SKSpriteNode {
            // 2
            if !selectedNode.isEqual(touchedNode) {
                selectedNode.removeAllActions()
                selectedNode.runAction(SKAction.rotateToAngle(0.0, duration: 0.1))
                
                selectedNode = touchedNode as! SKSpriteNode
                
                for sp in imageNames{
                    var aux = sp
                    switch(aux){
                    case "paladinCard" : aux = "knight"
                    case "rangerCard" : aux = "ranger"
                    case "thiefCard" : aux = "thief"
                    case "wizardCard" : aux = "wizard"
                    default : break
                    }
                    if touchedNode.name! == aux {
                        let sequence = SKAction.sequence([SKAction.rotateByAngle(degToRad(-4.0), duration: 0.1),
                            SKAction.rotateByAngle(0.0, duration: 0.1),
                            SKAction.rotateByAngle(degToRad(4.0), duration: 0.1)])
                        self.beginPosition = self.selectedNode.position
                        selectedNode.runAction(SKAction.repeatActionForever(sequence))
                    }
                }
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch : UITouch? = touches.first as UITouch?
        
        if let location = touch?.locationInNode(self) {
            if (tutorialNode!.containsPoint(location)){
                tutorialNode?.removeFromParent()
            }
            let touchedNode = self.nodeAtPoint(location)
            if touchedNode.name == "back"{
                viewController?.dismissViewControllerAnimated(false, completion: nil)
            }
        }
        
    }
    
    func panForTranslation(translation : CGPoint) {
        let position = selectedNode.position
        for sp in imageNames{
            if let nodeName = selectedNode.name{
                var aux = sp
                
                switch(aux){
                case "paladinCard" : aux = "knight"
                case "rangerCard" : aux = "ranger"
                case "thiefCard" : aux = "thief"
                case "wizardCard" : aux = "wizard"
                default : break
                }
                
                if nodeName == aux {
                    selectedNode.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
                }
            }
            
            
        }
    }
    
    func sendDataToIpad(){
        //print(self.selectedNode.name)
        if let avatarName : String = self.selectedNode.name{
            if canSelectAvatar{
                var avatar:[String:String] = [:]
                
                switch avatarName {
                case "knight":
                    avatar = ["avatar":"knight"]
                    viewController!.playerColor = UIColor.redColor()
                case "ranger":
                    avatar = ["avatar":"ranger"]
                    viewController!.playerColor = UIColor.whiteColor()
                case "thief":
                    avatar = ["avatar":"thief"]
                    viewController!.playerColor = UIColor.blackColor()
                case "wizard":
                    avatar = ["avatar":"wizard"]
                    viewController!.playerColor = UIColor.blueColor()
                default:
                    ()
                }
//                let avatar = ["avatar":avatarName]
                let dic = ["GameSetup":" ", "avatar":avatar]
                ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
            }
        }
        self.selectedNode.position = self.beginPosition
    }
    
    func messageReceived(data : NSNotification){
        _ = data.userInfo!["peerID"] as! String
        let dictionary = data.userInfo!["arrayPlayers"] as! NSDictionary
        let message = dictionary["arrayPlayers"] as! [String]
        self.takenAvatar = message
        //print(self.takenAvatar)
        
        // muda formato das imagens identificando se foi pego ou nao
        for sprite in arrayAvatarSprite{
            for taken in takenAvatar{
                if sprite.name == taken{
                    let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.40)
                    sprite.color = color
                    sprite.colorBlendFactor = 0.45
                    break
                } else {
                    sprite.color = UIColor.clearColor()
                    sprite.colorBlendFactor = 0.0
                }
            }
        }
        
    }
    
    func changeView(data : NSNotification){
        let dictionary = data.userInfo!["change"] as! NSDictionary
        let message = dictionary["change"] as! String
        
        if message == "change" {
            //change view
            viewController?.loadPlayerView()
        }
        
    }
    
    func avatarIsSelectable(data : NSNotification){
        let dictionary = data.userInfo!["able"] as! NSDictionary
        let message = dictionary["able"] as! String
        
        if message == "able" {
            //change view
            self.canSelectAvatar = true
        }
        
    }
    
    
    
    func setObjects(){
        
        //setup particles
        
        let globParticles = SetupParticle.fromFile("setupParticle1")
        globParticles!.name = "particles"
        globParticles!.position = CGPointMake(self.frame.width/2, self.frame.height + 10)
        self.addChild(globParticles!)
        globParticles?.zPosition = 1
        
        
        //for some reason this code dont wornk on the iPhone, the phone trys to mantein a 40 fps just like the iPad, but for some reason starts dropping
        /*let spawn = SKAction.runBlock({() in self.spawnItem()})
        
        let delay = SKAction.waitForDuration(0.7, withRange: 1.4)
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)*/

        
        //set boundary
        let boundary : SKNode = SKNode()
        boundary.name = "boundry"
        boundary.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: self.frame.width, height: 1))
        boundary.physicsBody?.dynamic = false
        boundary.physicsBody?.categoryBitMask = boundaryCategoryMask
        boundary.position = CGPoint(x: self.frame.width/2, y: -200)
        self.addChild(boundary)
    }
    
    func spawnItem(){
        
        let effectsNode = SKEffectNode()
        effectsNode.name = "effect"
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
        sprite.name = "something"
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
        
        //print("teve contato")
        if contact.bodyA.categoryBitMask == fallingCategoryMask {
            let filter = contact.bodyA.node?.parent
            //contact.bodyA.node?.removeFromParent()
            filter?.removeAllChildren()
            filter?.removeAllActions()
            filter?.removeFromParent()
        }
        
        if contact.bodyB.categoryBitMask == fallingCategoryMask {
            let filter = contact.bodyB.node?.parent
            //contact.bodyB.node?.removeFromParent()
            filter?.removeAllChildren()
            filter?.removeAllActions()
            filter?.removeFromParent()
        }
    }
    
}


