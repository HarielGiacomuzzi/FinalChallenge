//
//  MinigameCollectionScene.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 9/10/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

class MinigameCollectionScene : SKScene{
    
    var viewController : MinigameCollectionViewController!
    
    var collection = [SKSpriteNode()]
    
    override func didMoveToView(view: SKView) {
        
        let minigameTitle = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        minigameTitle.text = "Minigame Collection"
        minigameTitle.name = "Minigame Collection"
        minigameTitle.position = CGPointMake(self.size.width/2, self.size.height-100)
        self.addChild(minigameTitle)
        
        for i in GameManager.sharedInstance.allMinigames{
            let sprite =  SKSpriteNode(imageNamed: i.rawValue)
            
            sprite.name = i.rawValue
            
            sprite.size = CGSize(width: 200, height: 100)
            
            let aux = GameManager.sharedInstance.allMinigames.count
            
            let offsetFraction = (CGFloat(i.hashValue) + 1.0)/(CGFloat(aux) + 1.0)
            
            sprite.position = CGPoint(x: size.width * offsetFraction, y: size.height/2)
            
            self.addChild(sprite)
        }
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
        }
    }
}
