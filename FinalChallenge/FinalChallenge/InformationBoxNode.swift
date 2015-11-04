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
    var textNode2: SKLabelNode!
    weak var delegate: InformationNodeDelegate?
    var atlas = SKTextureAtlas(named: "tutorial")
    var isIphone = false

    
    init(isIphone: Bool, text: String) {
        super.init()
         self.isIphone = isIphone
        loadSprite(isIphone)
        loadText(text)
        loadTouchToContinueText()
        self.isIphone = isIphone

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
        let texts = text.separateInCharacter(50)
        textNode = SKLabelNode(text: texts[0])
        textNode.fontName = "Helvetica-Bold"
        textNode.fontSize = 40
        if isIphone {
            textNode.fontSize = 20
        }
        textNode.zPosition = 2
        textNode.position.y = textNode.frame.size.height
        addChild(textNode)
        
        textNode2 = SKLabelNode(text: texts[1])
        textNode2.fontName = "Helvetica-Bold"
        textNode2.fontSize = 40
        if isIphone {
            textNode2.fontSize = 20
        }
        textNode2.zPosition = 2
//        textNode2.position.y = -textNode.frame.size.height
        addChild(textNode2)
    }
    
    func loadTouchToContinueText() {
        let node = SKLabelNode(text: "Touch to Continue")
        node.position.y = -background.frame.height/2 + node.frame.size.height + 20
        node.fontName = "Helvetica-Bold"
        node.zPosition = 2
        node.fontSize = 20
        if isIphone {
            node.fontSize = 10
        }
        addChild(node)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        delegate?.closeInformation()
    }

}

protocol InformationNodeDelegate: class {
    func closeInformation()
}