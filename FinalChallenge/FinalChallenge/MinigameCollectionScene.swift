//
//  MinigameCollectionScene.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 9/10/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

class MinigameCollectionScene : SKScene, CardCarousellDelegate {
    
    weak var viewController : MinigameCollectionViewController!
    
    var collection = [SKSpriteNode()]
    
    // colisions
    let boundaryCategoryMask: UInt32 =  0x1 << 1
    let fallingCategoryMask: UInt32 =  0x1 << 2
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor.blackColor()
        
        let banner = SKSpriteNode(imageNamed: "setUpBanner")
        self.addChild(banner)
        banner.position = CGPoint(x: self.frame.width/2, y: (self.frame.height)*0.85)
        banner.size.height = banner.size.height/2
        banner.zPosition = 4
        banner.name = "banner"
        
        let minigameTitle = SKLabelNode(fontNamed: "GillSans-Bold")
        minigameTitle.text = "Minigame Collection"
        minigameTitle.name = "Minigame Collection"
        minigameTitle.position = CGPointMake(self.size.width/2, self.size.height*0.85)
        minigameTitle.zPosition = 5
        self.addChild(minigameTitle)
        
//        for i in GameManager.sharedInstance.allMinigames{
//            let sprite =  SKSpriteNode(imageNamed: i.rawValue)
//            
//            sprite.name = i.rawValue
//            
//            //sprite.size = CGSize(width: 200, height: 100)
//            sprite.setScale(0.5)
//            
//            let aux = GameManager.sharedInstance.allMinigames.count
//            
//            let offsetFraction = (CGFloat(i.hashValue) + 1.0)/(CGFloat(aux) + 1.0)
//            
//            sprite.position = CGPoint(x: size.width * offsetFraction, y: size.height/2)
//            
//            sprite.setScale(0.3)
//            
//            self.addChild(sprite)
//        }
        
//        let carousel = CardCarouselNode(cardsArray: GameManager.sharedInstance.allMinigames, startIndex: 0)
        
        let backButton = SKLabelNode(fontNamed: "GillSans-Bold")
        backButton.text = "Back"
        backButton.name = "Back"
        backButton.position = CGPoint(x: self.frame.width/10, y: (self.frame.height)*0.85)
        backButton.zPosition = 5
        self.addChild(backButton)
        
        let background = SKTexture(imageNamed: "setupBG")
        let bg = SKSpriteNode(texture: background, size: background.size())
        self.addChild(bg)
        bg.name = "bg"
        bg.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        bg.zPosition = 0
        self.backgroundColor = UIColor.whiteColor()
        
        self.setupMinigames()
        
        self.setObjects()
        
    }
    
    func setupMinigames() {
        var minigameSprites:[SKSpriteNode] = []
        for i in GameManager.sharedInstance.allMinigames {
            let sprite = SKSpriteNode(imageNamed: i.rawValue)
            sprite.name = i.rawValue
            sprite.zPosition = 5
            minigameSprites.append(sprite)
        }
        let carousel = CardCarouselNode(cardsArray: minigameSprites, startIndex: 0)
        carousel.setScale(0.3)
        carousel.position = CGPointMake(frame.size.width/2, frame.size.height/2)
        carousel.distanceToMoveDown = 500
        carousel.canRemoveWithSwipeUp = false
        carousel.canRemoveWithSwipeDown = true
        carousel.delegate = self
        addChild(carousel)
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

    
    func sendCard(card: SKNode) {
        let minigame = Minigame(rawValue: card.name!)!
        switch minigame {
        case .FlappyFish :
            viewController.gameSelected("fish")
        case .BombGame:
            viewController.gameSelected("bomb")
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch : UITouch? = touches.first as UITouch!
        
        if let location = touch?.locationInNode(self) {
            let touchedNode = self.nodeAtPoint(location)
            
            if touchedNode.name == "Back" {
                self.removeAllChildren()
                self.removeAllActions()
                viewController.backToMain()
            }
        }
    }
    
    deinit{
        //print("MinigameCollectionScene did deinit")
    }
    
}
