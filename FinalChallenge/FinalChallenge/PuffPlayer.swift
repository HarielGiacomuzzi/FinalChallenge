//
//  PuffPlayer.swift
//  FinalChallenge
//
//  Created by Cristiane on 04/09/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class PuffPlayer: SKSpriteNode {
    
    var sprite : SKNode?
    var x : Double?
    var y : Double?
    var playerName : String = ""
    
    init(name : String){
        self.playerName = name
        let playerSpriteAtlas = SKTextureAtlas(named: "puffGame")
        let pTexture = playerSpriteAtlas.textureNamed("spike")
        super.init(texture: pTexture, color: UIColor.clearColor(), size: pTexture.size())
        zPosition = 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
