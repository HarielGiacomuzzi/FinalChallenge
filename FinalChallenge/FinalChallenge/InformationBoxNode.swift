//
//  TutorialNode.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 10/26/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class InformationBoxNode: SKNode {
    
    var background: SKSpriteNode!
    var textNode: SKLabelNode!
    weak var delegate: InformationNodeDelegate?
    var atlas = SKTextureAtlas(named: "tutorial")

    
    init(isIphone: Bool, text: String) {
        super.init()
        loadSprite(isIphone)
        loadText(text)
        loadTouchToContinueText()

        userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadSprite(isIphone: Bool) {
        if isIphone {
            background = SKSpriteNode(imageNamed: "iphoneboxfinal")
        } else {
            background = SKSpriteNode(imageNamed: "ipadboxfinal")
        }
        background.zPosition = 1
        addChild(background)
    }
    
    func loadText(text: String) {
        textNode = SKLabelNode(text: text)
        textNode.fontName = "Helvetica-Bold"
        textNode.fontSize = 40
        textNode.zPosition = 2
        addChild(textNode)
    }
    
    func loadTouchToContinueText() {
        let node = SKLabelNode(text: "Touch to Continue")
        node.position.y = -background.frame.height/2 + node.frame.size.height + 20
        node.fontName = "Helvetica-Bold"
        node.zPosition = 2
        node.fontSize = 20
        addChild(node)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        delegate?.closeInformation()
    }

}

protocol InformationNodeDelegate: class {
    func closeInformation()
}