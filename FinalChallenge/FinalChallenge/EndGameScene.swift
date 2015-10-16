//
//  EndGameScene.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 10/2/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

class EndGameScene : SKScene{
    
    override func didMoveToView(view: SKView) {
        ConnectionManager.sharedInstance.closeConections()
        
        let background = SKTexture(imageNamed: "setupBG")
        let bg = SKSpriteNode(texture: background, size: background.size())
        self.addChild(bg)
        bg.name = "bg"
        bg.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        bg.zPosition = 0
        self.backgroundColor = UIColor.whiteColor()

        let label = SKLabelNode(fontNamed: "GillSans-Bold")
        label.text = "Game ended someone won, the rest lost, deal with it"
        label.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        label.zPosition = 5
        self.addChild(label)
        
        let backToMain = SKLabelNode(fontNamed: "GillSans-Bold")
        backToMain.name = "back"
        backToMain.text = "Back to Start Screen"
        backToMain.position = CGPoint(x: self.frame.width/2, y: self.frame.height/5)
        backToMain.zPosition = 5
        self.addChild(backToMain)
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch : UITouch? = touches.first as UITouch!
        
        if let location = touch?.locationInNode(self) {
            let touchedNode = self.nodeAtPoint(location)
            
            if touchedNode.name == "back"{
                _ = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1.0)
               // self.view?.presentScene(nil)
                ConnectionManager.sharedInstance.closeConections()
                GameManager.sharedInstance.restartGameManager()
                GameManager.sharedInstance.dismissBoardGame()
            }
        }
    }
    
    deinit{
        //print("retirou a endgamescene")
    }
}

