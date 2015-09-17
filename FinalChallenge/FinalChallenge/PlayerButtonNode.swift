//
//  PlayerButtonNode.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 9/16/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class PlayerButtonNode: SKSpriteNode {
    
    var textureOn = SKTexture()
    var textureOff = SKTexture()
    
    init(textureOn:SKTexture, textureOff:SKTexture) {
        self.textureOn = textureOn
        self.textureOff = textureOff
        super.init(texture: textureOn, color: UIColor.clearColor(), size: textureOn.size())
        userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        texture = textureOff
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        texture = textureOn
    }

}
