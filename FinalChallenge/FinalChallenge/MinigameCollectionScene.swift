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
        
        setupMinigames()
        
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
        carousel.canRemoveWithSwipeUp = false
        carousel.canRemoveWithSwipeDown = true
        carousel.delegate = self
        addChild(carousel)
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
        print("MinigameCollectionScene did deinit")
    }
    
}
