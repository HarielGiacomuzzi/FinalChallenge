//
//  EndGameIphoneScene.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 10/6/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import SpriteKit

class EndGameIphoneScene : SKScene{
    
    override func didMoveToView(view: SKView) {
        ConnectionManager.sharedInstance.closeConections()
        
        self.backgroundColor = UIColor.blueColor()
        let label = SKLabelNode(fontNamed: "GillSans-Bold")
        label.text = "Game ended someone won, the rest lost, deal with it"
        label.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.addChild(label)
        
        let backToMain = SKLabelNode(fontNamed: "GillSans-Bold")
        backToMain.name = "back"
        backToMain.text = "Back to Start Screen"
        backToMain.position = CGPoint(x: self.frame.width/2, y: self.frame.height/5)
        self.addChild(backToMain)
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch : UITouch? = touches.first as UITouch!
        
        if let location = touch?.locationInNode(self) {
            let touchedNode = self.nodeAtPoint(location)
            
            if touchedNode.name == "back"{
                _ = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1.0)
                // self.view?.presentScene(nil)
                GameManager.sharedInstance.restartGameManager()
                GameManager.sharedInstance.dismissPlayerViewController()
            }
        }
    }
    
    deinit{
        print("retirou a endgamescene")
    }
    
}