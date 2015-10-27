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
    weak var delegate:SetupPartyButtonDelegate?
    
    init(textureOn: SKTexture, textureOff: SKTexture) {
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
        delegate?.buttonTouched(self)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        texture = textureOn
        
    }

}

protocol SetupPartyButtonDelegate : class {
    func buttonTouched(sender: SetupPartyButton)
}