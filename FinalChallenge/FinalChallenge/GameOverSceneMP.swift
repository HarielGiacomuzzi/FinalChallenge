//
//  GameOverSceneMP.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 9/10/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

class GameOverSceneMP : MinigameScene {
   
    var player:[String] = []
    var playerNode:[SKSpriteNode] = []
    
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor.redColor()
        let back = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        back.text = "Back to Board"
        back.name = "Back to Board"
        back.position = CGPointMake(self.size.width/2, 50)
        self.addChild(back)
        
        for i in 0..<player.count{
            
            var p = Player()
            
            for j in GameManager.sharedInstance.players{
                if player[i] == j.playerIdentifier{
                    p = j
                }
            }
            
            //FOR DEBUG
            p.avatar = "red";
            //FOR DEBUG
            
            let sprite =  SKSpriteNode(imageNamed: p.avatar!)
            
            sprite.name = p.avatar!
            
            sprite.size = CGSize(width: 100, height: 200)
            
            let offsetFraction = (CGFloat(i) + 1.0)/(CGFloat(player.count) + 1.0)
            
            if i < 2{
                sprite.position = CGPoint(x: size.width * offsetFraction, y: size.height/2)
            }else{
               sprite.position = CGPoint(x: size.width * offsetFraction, y: size.height*offsetFraction/2)
            }
            self.addChild(sprite)
        }
        
        
    }
    
    //touch nodes
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch : UITouch? = touches.first as UITouch?
        
        if let location = touch?.locationInNode(self) {
            let touchedNode = self.nodeAtPoint(location)
            
            if touchedNode.name == "Back to Board" {
                _ = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1.0)
                self.view?.presentScene(nil)
                GameManager.sharedInstance.dismissMinigameSP()
            }
        }
    }
    
}
