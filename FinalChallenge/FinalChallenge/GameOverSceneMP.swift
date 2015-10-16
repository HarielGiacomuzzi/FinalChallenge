//
//  GameOverSceneMP.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 9/10/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

class GameOverSceneMP : MinigameScene {
   
    var players:[String] = []
    var playerNode:[SKSpriteNode] = []
    
    
    override func didMoveToView(view: SKView) {
        
        let background = SKTexture(imageNamed: "setupBG")
        let bg = SKSpriteNode(texture: background, size: background.size())
        self.addChild(bg)
        bg.name = "bg"
        bg.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        bg.zPosition = 0
        self.backgroundColor = UIColor.whiteColor()
        
        
        let back = SKLabelNode(fontNamed: "GillSans-Bold")
        back.text = "Back to Board"
        back.name = "Back to Board"
        back.position = CGPointMake(self.size.width/2, 50)
        back.zPosition = 5
        self.addChild(back)
        
        //precisa estar do maior pro menor
        for i in 0..<players.count{
            
            var p = Player()
            
            for j in GameManager.sharedInstance.players{
                if players[i] == j.playerIdentifier{
                    p = j
                }
            }
            
            let sprite =  SKSpriteNode(imageNamed: p.avatar!)
            
            sprite.name = p.avatar!
            
            sprite.size = CGSize(width: 100, height: 200)
            
            let offsetFraction = (CGFloat(i) + 1.0)/(CGFloat(players.count) + 1.0)

            sprite.position = CGPoint(x: size.width * offsetFraction, y: size.height/2)
            
            sprite.zPosition = 5
            
            self.addChild(sprite)
            
            //print("dando o dinheiro para o player \(p.playerIdentifier)")
            //print("playerCount =  \(players.count)")
            
            if i < players.count-1 { //not last player
                switch i {
                case 0:
                    GameManager.sharedInstance.updatePlayerMoney(p, value: 50)
                    //print("dando 50 para o player \(p.playerIdentifier)")
                case 1:
                    GameManager.sharedInstance.updatePlayerMoney(p, value: 25)
                    //print("dando 25 para o player \(p.playerIdentifier)")
                case 2:
                    GameManager.sharedInstance.updatePlayerMoney(p, value: 5)
                    //print("dando 5 para o player \(p.playerIdentifier)")
                default:
                    ()
                }
            }
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
                GameManager.sharedInstance.dismissMinigameMP()
            }
        }
    }
    
}
