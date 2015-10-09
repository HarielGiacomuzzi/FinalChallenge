//
//  GameOverSceneSP.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 9/9/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

class GameOverSceneSP : MinigameScene{
    
    //used in all games
    var game : String!
    //used in flappyfish,
    var score : Int!
    //used in bombGame,
    var winner : String!
    
    func setupView(){
        //self.backgroundColor = UIColor.redColor()
    }
    
    override func didMoveToView(view: SKView) {
        //self.backgroundColor = UIColor.redColor()
        let background = SKTexture(imageNamed: "setupBG")
        let bg = SKSpriteNode(texture: background, size: background.size())
        self.addChild(bg)
        bg.name = "bg"
        bg.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        bg.zPosition = 0
        self.backgroundColor = UIColor.whiteColor()
        
        switch(game){
        case "fish": self.setupFlappyFishGameOver()
        case "bomb": self.setupBombGameOver()
        default: break
        }
    }
    
    //sets flappyfish game over scene
    func setupFlappyFishGameOver(){
        
        print("entrou aqui ta sacando 2")
        
        let restartGame = SKLabelNode(fontNamed: "GillSans-Bold")
        restartGame.text = "Restart Game"
        restartGame.name = "Restart Game"
        restartGame.position = CGPointMake(self.size.width/2, 50)
        restartGame.zPosition = 2
        self.addChild(restartGame)
        
        let returnMinigameScene = SKLabelNode(fontNamed: "GillSans-Bold")
        returnMinigameScene.text = "Return to Minigames Collection"
        returnMinigameScene.name = "Return MinigameScene"
        returnMinigameScene.position = CGPointMake(self.size.width/2, 150)
        returnMinigameScene.zPosition = 2
        self.addChild(returnMinigameScene)
        
        let scoreLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        scoreLabel.text = "Final Score: \(score)"
        scoreLabel.name = "Final Score"
        scoreLabel.position = CGPointMake(self.size.width/2, self.size.height/2)
        scoreLabel.zPosition = 2
        self.addChild(scoreLabel)
    }
    
    func setupBombGameOver(){
        let restartGame = SKLabelNode(fontNamed: "GillSans-Bold")
        restartGame.text = "Restart Game"
        restartGame.name = "Restart Game"
        restartGame.position = CGPointMake(self.size.width/2, 50)
        restartGame.zPosition = 2
        self.addChild(restartGame)
        
        let returnMinigameScene = SKLabelNode(fontNamed: "GillSans-Bold")
        returnMinigameScene.text = "Return to Minigames Collection"
        returnMinigameScene.name = "Return MinigameScene"
        returnMinigameScene.position = CGPointMake(self.size.width/2, 150)
        returnMinigameScene.zPosition = 2
        self.addChild(returnMinigameScene)
        
        let scoreLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        scoreLabel.text = "Winner: \(winner)"
        scoreLabel.name = "Winner"
        scoreLabel.position = CGPointMake(self.size.width/2, self.size.height/2)
        scoreLabel.zPosition = 2
        self.addChild(scoreLabel)
    }
    
    //touch nodes
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch : UITouch? = touches.first as UITouch?
        
        if let location = touch?.locationInNode(self) {
            let touchedNode = self.nodeAtPoint(location)
            
            if touchedNode.name == "Restart Game" {
                //let transition = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1.0)
                var scene = MinigameScene()
                switch(game){
                case "fish":  scene = FlappyGameScene(size: self.scene!.size)
                case "bomb":  scene = BombTGameScene(size: self.scene!.size)
                default: break
                }
                
                scene.scaleMode = SKSceneScaleMode.Fill
                self.scene!.view!.presentScene(scene)
            }
            
            if touchedNode.name == "Return MinigameScene" {
                _ = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1.0)
                self.removeFromParent()
                self.view?.presentScene(nil)
                //self.view?.removeFromSuperview()
                GameManager.sharedInstance.newDismissMinigameSP()
            }
        }
    }
    
    deinit{
        print("\(self.game) is being deInitialized")
    }
    
}