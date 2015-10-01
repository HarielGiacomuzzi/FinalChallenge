//
//  MinigameScene.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 8/21/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class MinigameScene: SKScene {
    var gameController : MiniGameViewController? = nil
    var gameName = String()
    var playerRank:[String] = []
    
    func messageReceived(identifier: String, dictionary: NSDictionary) {
        
    }
    
    func gameOverSP(game:String, winner:String, score:Int) {
        self.removeAllChildren()
        self.removeAllActions()
        _ = SKTransition.flipHorizontalWithDuration(0.5)
        let goScene = GameOverSceneSP(size: self.size)
        goScene.scaleMode = .AspectFit
        goScene.winner = winner
        goScene.game = game
        goScene.score = score
        self.view?.presentScene(goScene)
    }
    
    deinit{
        print("MinigameScene is out")
    }
}