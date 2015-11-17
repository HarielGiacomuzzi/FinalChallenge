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
        
        let redBanner : SKTexture = SKTexture(imageNamed: "redTitle")
        // self.backgroundColor = UIColor(red: 14/255, green: 234/255, blue: 158/255, alpha: 1)
        
        let background = SKTexture(imageNamed: "setupBG")
        let bg = SKSpriteNode(texture: background)
        bg.size = CGSize(width: self.frame.width, height: self.frame.height * 2)
        self.addChild(bg)
        bg.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        bg.zPosition = 0
        
        
        let titleBar : SKSpriteNode = SKSpriteNode(texture: redBanner )
        titleBar.size = CGSize(width: self.frame.width, height: self.frame.height * 0.3)
        titleBar.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.addChild(titleBar)
        
        let titleLabel : SKLabelNode = SKLabelNode(fontNamed: "GillSans-Bold")
        titleLabel.fontSize = titleBar.size.height * 0.55
        titleLabel.text = "End Game"
        titleBar.addChild(titleLabel)
        titleLabel.position = CGPoint(x: 0, y: -(titleLabel.frame.height/2))
        titleLabel.zPosition = 21
        titleBar.zPosition = 20
        titleLabel.fontColor = UIColor(red: 255/255, green: 242/255, blue: 202/255, alpha: 1)
        

        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        ConnectionManager.sharedInstance.closeConections()
        GameManager.sharedInstance.restartGameManager()
        GameManager.sharedInstance.dismissPlayerViewController()
    
    }
    
    deinit{
        //print("retirou a endgamescene do iphone")
    }
    
}