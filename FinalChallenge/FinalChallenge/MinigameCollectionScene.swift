//
//  MinigameCollectionScene.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 9/10/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

class MinigameCollectionScene : SKScene{
    
    weak var viewController : MinigameCollectionViewController!
    
    var collection = [SKSpriteNode()]
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor.blackColor()
        
        let minigameTitle = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        minigameTitle.text = "Minigame Collection"
        minigameTitle.name = "Minigame Collection"
        minigameTitle.position = CGPointMake(self.size.width/2, self.size.height/1.2)
        self.addChild(minigameTitle)
        
        for i in GameManager.sharedInstance.allMinigames{
            let sprite =  SKSpriteNode(imageNamed: i.rawValue)
            
            sprite.name = i.rawValue
            
            //sprite.size = CGSize(width: 200, height: 100)
            sprite.setScale(0.5)
            
            let aux = GameManager.sharedInstance.allMinigames.count
            
            let offsetFraction = (CGFloat(i.hashValue) + 1.0)/(CGFloat(aux) + 1.0)
            
            sprite.position = CGPoint(x: size.width * offsetFraction, y: size.height/2)
            
            sprite.setScale(0.3)
            
            self.addChild(sprite)
        }
        
        let backButton = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        backButton.text = "Back"
        backButton.name = "Back"
        backButton.position = CGPointMake(self.size.width/2, self.size.height/10)
        self.addChild(backButton)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch : UITouch? = touches.first as UITouch!
        
        if let location = touch?.locationInNode(self) {
            let touchedNode = self.nodeAtPoint(location)
            
            if touchedNode.name == "FlappyFish" {
                viewController.gameSelected("fish")
            }
            
            if touchedNode.name == "BombGame" {
                viewController.gameSelected("bomb")
            }
            
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
