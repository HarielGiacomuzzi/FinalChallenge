//
//  SetupPartyButton.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 10/27/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class SetupPartyButton: SKSpriteNode {
    
    var textureOn:SKTexture!
    var textureOff:SKTexture!
    lazy var maskSprite = SKSpriteNode()
    var textLabel : SKLabelNode?
    var posOn : CGFloat!
    
    weak var delegate:SetupPartyButtonDelegate?
    
    override var userInteractionEnabled:Bool {
        didSet {
            if !userInteractionEnabled {
                if maskSprite.parent == nil {
                    addChild(maskSprite)                    
                }
            } else {
                maskSprite.removeFromParent()
            }
        }
    }
    
    init(textureOn: SKTexture, textureOff: SKTexture) {
        self.textureOn = textureOn
        self.textureOff = textureOff
        super.init(texture: textureOn, color: UIColor.clearColor(), size: textureOn.size())
        setupMaskSprite()
        userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        texture = textureOff
        posOn = textLabel?.position.y
        textLabel?.position.y = ((textLabel?.position.y)! - 10)
        delegate?.buttonTouched(self)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        texture = textureOn
        textLabel?.position.y = posOn
    }
    
    func setupMaskSprite() {
        maskSprite = SKSpriteNode(texture: texture)
        maskSprite.zPosition = 1
        maskSprite.colorBlendFactor = 1.0
        maskSprite.color = UIColor.blackColor()
        maskSprite.alpha = 0.5
    }

}

protocol SetupPartyButtonDelegate : class {
    func buttonTouched(sender: SetupPartyButton)
}