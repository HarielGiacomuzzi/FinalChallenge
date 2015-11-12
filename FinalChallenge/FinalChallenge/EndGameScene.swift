//
//  EndGameScene.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 10/2/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

class EndGameScene : SKScene{
    
    var playerNodes : [SKNode] = [SKNode]()
    
    override func didMoveToView(view: SKView) {
        
        /*
        AudioSource.sharedInstance.stopAudio()
        
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

        */
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
        
        
        
        let fadeIn : SKAction = SKAction.fadeInWithDuration(0.5)
        self.runAction(fadeIn) { () -> Void in
            let ascend : SKAction = SKAction.moveToY(self.frame.height * 0.9, duration: 0.5)
            titleBar.runAction(ascend, completion: { () -> Void in
                self.showPlayer("OI")
                
            })
            
            
        }
    }
    
    
    deinit{
        //print("retirou a endgamescene")
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
            else{
                showPlayer("oi")
            }
        }
    }
    
    func showPlayer( position : String){
        
        for i in playerNodes{
            i.removeFromParent()
        }
        
        
        
        
        // let playerAvatar : SKTexture = SKTexture(imageNamed: p.avatar)
        let playerAvatar : SKTexture = SKTexture(imageNamed: "knight")
        let playerNode : SKSpriteNode = SKSpriteNode(texture: playerAvatar)
        
        let playerPosition : SKTexture = SKTexture(imageNamed: "")
        let positionNode : SKSpriteNode = SKSpriteNode(texture: playerPosition)
        
        
        
        playerNode.position = CGPoint(x: self.frame.width + playerNode.frame.width, y: self.frame.height * 0.2)
        playerNode.size = CGSize(width: playerNode.size.width * 0.9, height: playerNode.size.height * 0.9)
        positionNode.position = CGPoint(x: -(positionNode.frame.width), y: self.frame.height * 0.15)
        
        let goMid : SKAction = SKAction.moveToX(self.frame.width/2, duration: 1)
        
        self.addChild(playerNode)
        self.addChild(positionNode)
        
        playerNode.zPosition = 50
        positionNode.zPosition = 51
        
        playerNodes.append(playerNode)
        playerNodes.append(positionNode)
        
        playerNode.runAction(goMid)
        positionNode.runAction(goMid) { () -> Void in
            let globParticles = endParticle.fromFile("endGameParticle")
            globParticles!.position = CGPointMake(self.frame.width/2, -200)
            self.addChild(globParticles!)
            globParticles?.alpha = 0.3
            globParticles?.zPosition = 1
            globParticles?.particleColorSequence = nil
            globParticles?.particleColorBlendFactor = 0.85
            globParticles?.particleColor = UIColor.redColor()
        
            self.playerNodes.append(globParticles!)
        }
        
        
 
        
        
    }
    
    
    
    
    

}

