//
//  NotificationNode.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 10/5/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class NotificationNode: SKNode {
    
    var label: SKLabelNode!
    var background: SKSpriteNode!
    
    init(text:String) {
        super.init()
        label = SKLabelNode(text: text)
        label.color = UIColor.blueColor()
        label.fontSize = 100
        label.zPosition = 20000
        
        addChild(label)
        
        background = SKSpriteNode(texture: nil, color: UIColor.redColor(), size: label.frame.size)
        background.zPosition = 10000
        background.position.y += label.frame.size.height/2
        
        addChild(background)
        userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.removeFromParent()
    }
    
}
