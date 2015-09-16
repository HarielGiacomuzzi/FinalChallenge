//
//  PlayerControllerScene.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 9/9/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class PlayerControllerScene: SKScene {
    
    
    override func didMoveToView(view: SKView) {
        
        
        var card1 = SKSpriteNode(texture: nil, color: UIColor.blueColor(), size: CGSize(width: 300, height: 600))
        var card2 = SKSpriteNode(texture: nil, color: UIColor.greenColor(), size: CGSize(width: 300, height: 600))
        var card3 = SKSpriteNode(texture: nil, color: UIColor.redColor(), size: CGSize(width: 300, height: 600))
        var card4 = SKSpriteNode(texture: nil, color: UIColor.whiteColor(), size: CGSize(width: 300, height: 600))
        
        
        
        var cards = [card1,card2,card3,card4]
        
        var carousel = CardCarouselNode(cardsArray: cards)
        carousel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        self.addChild(carousel)
        
    }
    
    
    
    
}
