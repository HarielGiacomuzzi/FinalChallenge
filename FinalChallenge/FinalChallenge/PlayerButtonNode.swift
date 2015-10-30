//
//  PlayerButtonNode.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 9/16/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class PlayerButtonNode: SKNode {
    
    var textureOn = SKTexture()
    var textureOff = SKTexture()
    var animationArray : [SKTexture] = []
    var openRight = true
    var button:SKSpriteNode!
    var background:SKSpriteNode!
    var number:SKLabelNode!
    
    weak var delegate: PlayerButtonDelegate?
    
    init(textureOn:SKTexture, textureOff:SKTexture, openRight:Bool) {

        self.textureOn = textureOn
        self.textureOff = textureOff
        self.openRight = openRight
        super.init()
        
        button = SKSpriteNode(texture: textureOn)
        button.zPosition = 5

        for i in 0...19 {
            animationArray.append(SKTexture(imageNamed: "buttonAnimation\(i)"))
        }
        background = SKSpriteNode(texture: animationArray[0])
        if !openRight {
            background.xScale = -1.0
        }

        addChild(button)
        userInteractionEnabled = true
        setupText()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        delegate?.buttonClicked(self)
        button.texture = textureOff
        openBackground()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        button.texture = textureOn
        number.hidden = true
        closeBackground()
    }
    
    func setupText() {
        
        number = SKLabelNode(text: "0")
        if openRight {
            number.position = CGPointMake(background.position.x + background.size.width - button.size.width - 20, background.position.y)
        } else {
            number.position = CGPointMake(background.position.x - background.size.width.mod() + button.size.width + 20, background.position.y)
        }

        number.hidden = true
        number.fontSize = 50.0
        number.fontName = "GillSans-Bold"
        number.zPosition = 5
        addChild(number)
    }
    
    func openBackground() {
        let action = SKAction.animateWithTextures(animationArray, timePerFrame: 0.015)
        
        if openRight {
            let leftButtonLeftPoint = button.position.x - button.size.width/2
            let leftButtonTopPoint = button.position.y + button.size.height/2
            background.position = CGPointMake(leftButtonLeftPoint + background.size.width/2, (leftButtonTopPoint - background.size.height/2) + 15)
        } else {
            let rightButtonTopPoint = button.position.y + button.size.height/2
            let rightButtonRightPoint = button.position.x + button.size.width/2
            background.position = CGPointMake(rightButtonRightPoint - background.size.width.mod()/2, (rightButtonTopPoint - background.size.height/2) + 15)
        }
        
        background.zPosition = 2
        if background.parent == nil {
            addChild(background)
        }
        background.runAction(action, completion: {() in
            self.number.hidden = false
        })

    }
    
    func closeBackground() {
        background.removeFromParent()

    }
    
    func updateNumber(number:Int) {
        self.number.text = "\(number)"
    }
    
}

protocol PlayerButtonDelegate : class {
    func buttonClicked(sender:SKNode)
}
