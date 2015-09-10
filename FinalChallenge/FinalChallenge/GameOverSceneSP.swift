//
//  GameOverSceneSP.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 9/9/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

class GameOverSceneSP : MinigameScene{
    
    var score : Int!
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor.redColor()
        var restartGame = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        restartGame.text = "Restart Game"
        restartGame.name = "Restart Game"
        restartGame.position = CGPointMake(self.size.width/2, 50)
        self.addChild(restartGame)
        
        var returnMinigameScene = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        returnMinigameScene.text = "Return to Minigames"
        returnMinigameScene.name = "Return MinigameScene"
        returnMinigameScene.position = CGPointMake(self.size.width/2, 150)
        self.addChild(returnMinigameScene)
        
        var scoreLabel = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        scoreLabel.text = "Final Score: \(score)"
        scoreLabel.name = "Final Score"
        scoreLabel.position = CGPointMake(self.size.width/2, self.size.height/2)
        self.addChild(scoreLabel)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        var touch : UITouch? = touches.first as? UITouch
        
        if let location = touch?.locationInNode(self) {
            let touchedNode = self.nodeAtPoint(location)
            
            if touchedNode.name == "Restart Game" {
                let transition = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1.0)
                
                let scene = FlappyGameScene(size: self.scene!.size)
                scene.scaleMode = SKSceneScaleMode.AspectFit
                
                self.scene!.view!.presentScene(scene, transition: transition)
            }
            
            if touchedNode.name == "Return MinigameScene" {
                let transition = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1.0)
                self.view?.presentScene(nil)
                GameManager.sharedInstance.dismissMinigameSP()
                
            }
        }
    }
    
    
}