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
    var playerRank:[String] = []
    var gameManager = GameManager()
    
    func messageReceived(identifier:String, action:PlayerAction) {
        
    }
    
}
