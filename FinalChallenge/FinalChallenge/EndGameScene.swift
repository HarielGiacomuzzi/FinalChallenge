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
        self.backgroundColor = UIColor.blueColor()
        let label = SKLabelNode(fontNamed: "GillSans-Bold")
        label.text = "Game ended some one won, the rest lost, deal with it"
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
                
            }
        }
    }
}

