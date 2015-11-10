//
//  InfoButtonNode.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 11/10/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class InfoButtonNode: SKSpriteNode {
    var textureOn = SKTexture(imageNamed: "infobuttonon")
    var textureOff = SKTexture(imageNamed: "infobuttonoff")
    
    weak var delegate: InfoDelegate?
    
    init() {
        super.init(texture: textureOn, color: UIColor.clearColor(), size: textureOn.size())
        userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        delegate?.infoButtonPressed(self)
        texture = textureOff
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        texture = textureOn
    }
}

protocol InfoDelegate: class {
    func infoButtonPressed(sender: InfoButtonNode)
}

