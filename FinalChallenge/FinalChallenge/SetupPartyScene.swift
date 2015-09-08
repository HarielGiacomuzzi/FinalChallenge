//
//  SetupPartyScene.swift
//  FinalChallenge
//
//  Created by Jonathas Hernandes on 08/09/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import SpriteKit

class SetupPartyScene: SKScene {
    
    override func update(currentTime: NSTimeInterval) {

        
    }
    
    override func didMoveToView(view: SKView) {
        
        setObjects()
        
        
    }
    
    func setObjects(){
        let redBanner : SKTexture = SKTexture(imageNamed: "redBanner")
        let banner : SKSpriteNode = SKSpriteNode(texture: redBanner, size: redBanner.size() )
        
        self.addChild(banner)
        banner.position = CGPoint(x: 0, y: (self.frame.height)/2 + 300)
        
        
        
        
    }

    
    
}
