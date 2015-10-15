//
//  DiceNode.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 10/15/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class DiceNode: SKSpriteNode {
    
    var textureOn:SKTexture!
    var textureOff:SKTexture!
    var active = false
    weak var delegate:DiceDelegate?
    
    init() {
        textureOn = SKTexture(imageNamed: "dadoOn")
        textureOff = SKTexture(imageNamed: "dadoOff")
        super.init(texture: textureOff, color: UIColor.clearColor(), size: textureOn.size())
        userInteractionEnabled = true
        deactivateDice()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if active {
            deactivateDice()
            delegate?.diceRolled(self)
        }
    }
    
    func deactivateDice() {
        texture = textureOff
        setScale(0.5)
        active = false
    }
    
    func activateDice() {
        texture = textureOn
        setScale(1.0)
        active = true
    }

}

protocol DiceDelegate : class {
    func diceRolled(sender:SKSpriteNode)
}


