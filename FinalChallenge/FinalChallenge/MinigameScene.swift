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
    weak var gameController : MiniGameViewController? = nil
    
    var playerRank:[String] = []

    func messageReceived(identifier: String, dictionary: NSDictionary) {
        
    }
    
    deinit{
        print("deu deinit")
    }
    
}
